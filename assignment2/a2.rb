class ULTerm end

class ULVar < ULTerm
    attr_reader :index
  
    # We require our variables are only indexed by integers.
    def initialize(i)
        unless i.is_a?(Integer)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @index = i
    end
  
    def ==(r); r.is_a?(ULVar) && r.index == @index end
end

class ULAbs < ULTerm
    attr_reader :t
  
    def initialize(t)
        unless t.is_a?(ULTerm)
            throw "Constructing a lambda term out of a non-lambda term"
        end
        @t = t
    end
  
    def ==(r); r.is_a?(ULAbs) && r.t == @t end
end

class ULApp < ULTerm
    attr_reader :t1
    attr_reader :t2
  
    def initialize(t1,t2)
        unless t1.is_a?(ULTerm) && t2.is_a?(ULTerm)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @t1 = t1; @t2 = t2
    end
  
    def ==(r); r.is_a?(ULApp) && r.t1 == @t1 && r.t2 == @t2 end
end

class STType end

class STNat < STType
    # Comparison and printing methods
    def ==(type); type.is_a?(STNat) end
    def to_s; "nat" end
end

class STBool < STType
    # Comparison and printing methods
    def ==(type); type.is_a?(STBool) end
    def to_s; "bool" end
end

# Functions have a domain type and a codomain type.
class STFun < STType
    attr_reader :dom
    attr_reader :codom
    
    def initialize(dom, codom)
        unless dom.is_a?(STType) && dom.is_a?(STType)
            throw "Constructing a type out of non-types"
        end
        @dom = dom; @codom = codom
    end
  
    # Comparison and printing methods
    def ==(type); type.is_a?(STFun) && type.dom == @dom && type.codom == @codom end 
    def to_s; "(" + dom.to_s + ") -> (" + codom.to_s + ")" end
end

# Example use: the type "nat -> bool" is written STFun.new(STNat.new,STBool.new)

class STTerm 
    def typecheck
        if typeOf(Array.new) == nil
            false
        else
            true
        end
    end
end

class STVar < STTerm
    attr_reader :index

    def initialize(index)
        unless index.is_a?(Integer) 
            throw "Constructing a STVar out of non-terms"
        end
        @index = index
    end

    def typeOf(arr)
        nil
    end

    def eraseTypes
        ULVar.new(index)
    end
end

class STApp < STTerm
    attr_reader :t1
    attr_reader :t2

    def initialize(t1, t2)
        unless t1.is_a?(STTerm) && t2.is_a?(STTerm)
            throw "Constructing a STApp out of non-terms"
        end
        @t1 = t1; @t2 = t2
    end

    def typeOf(arr)
        if @t2.is_a?(STTrue) || @t2.is_a?(STFalse)
            nil
        else
            @t1.typeOf(Array.new)
        end
    end

    def eraseTypes
        ULApp.new(t1.eraseTypes, t2.eraseTypes)
    end
end

class STAbs < STTerm
    attr_reader :t1
    attr_reader :t2

    def initialize(t1, t2)
        unless t1.is_a?(STType) && t2.is_a?(STTerm)
            throw "Constructing a STAbs with wrong type"
        end
        @t1 = t1; @t2 = t2
    end

    def typeOf(arr)
        if @t2.is_a?(STVar) 
            arr.append(@t1)
            i = @t2.index 
            if arr[i] == @t1
                STFun.new(@t1, STNat)
            end
        else
            nil
        end
    end

    def eraseTypes
        ULAbs.new(t2.eraseTypes)
    end
end

class STZero < STTerm
    def typeOf(arr)
        STNat
    end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(0)))
    end
end

class STSuc < STTerm
    attr_reader :value

    def initialize(value)
        unless value.is_a?(STTerm) 
            throw "Constructing a STSuc out of non-terms"
        end
        @value = value
    end

    def typeOf(arr)
        if @value.is_a?(STTrue) || @value.is_a?(STFalse)
            nil
        else
            STNat
        end
    end

    def eraseTypes
        ULApp.new(ULAbs.new(ULAbs.new(ULAbs.new(ULApp.new(ULVar.new(1),ULApp.new(ULApp.new(ULVar.new(2),ULVar.new(1)),ULVar.new(0)))))), value.eraseTypes)
    end
end

class STIsZero < STTerm
    attr_reader :value

    def initialize(value)
        unless value.is_a?(STTerm) 
            throw "Constructing a STIsZero out of non-terms"
        end
        @value = value
    end

    def typeOf(arr)
        STBool
    end

    def eraseTypes
        ULAbs.new(ULApp.new(value.eraseTypes,ULApp.new(ULAbs.new(ULAbs.new(ULVar.new(0))),ULAbs.new(ULAbs.new(ULVar.new(1))))))
    end
end

class STTrue < STTerm
    def typeOf(arr)
        STBool
    end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(1)))
    end
end

class STFalse < STTerm
    def typeOf(arr)
        STBool
    end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(0)))
    end
end

class STTest < STTerm
    attr_reader :t1
    attr_reader :t2
    attr_reader :t3

    def initialize(t1,t2,t3)
        unless t1.is_a?(STTerm) && t2.is_a?(STTerm) && t3.is_a?(STTerm)
            throw "Constructing a STTest out of non-terms"
        end
        @t1 = t1; @t2 = t2; @t3 = t3
    end

    def typeOf(arr)
        @t2.typeOf(Array.new)
    end

    def eraseTypes
        ULApp.new(ULApp.new(t1.eraseTypes,t2.eraseTypes),t3.eraseTypes)
    end
end
