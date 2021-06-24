# Computer Science 3MI3 Assignment 2 Documentation

This is the documentation for CS 3MI3 assignment 2, including all constructors and methods required to represent a simply-typed λ-calculus. Code and details of typecheck and eraseTypes functions for that λ-calculus are provided below. 


# Part 1 - The Representation 
## In Scala

Scala code from file a2.sc.

	sealed trait STType  
	case object STNat extends STType {  
	  override def toString() = "nat"  
	}  
	case object STBool extends STType {  
	  override def toString() = "bool"  
	}  
	// Functions have a domain type and a codomain type.  
	case class STFun(dom: STType, codom: STType) extends STType {  
	  override def toString() = "(" + dom.toString + ") -> (" + codom.toString + ")"  
	}

	sealed trait STTerm  
	case class STVar(index: Int) extends STTerm  
	case class STApp(t1: STTerm, t2: STTerm) extends STTerm  
	case class STAbs(t1: STType, t2: STTerm) extends STTerm  
	case object STZero extends STTerm  
	case class STSuc(value: STTerm) extends STTerm  
	case class STIsZero(value: STTerm) extends STTerm  
	case object STTrue extends STTerm  
	case object STFalse extends STTerm  
	case class STTest(t1: STTerm, t2: STTerm, t3: STTerm) extends STTerm

For part 1, I was asked to implement a type STTerm to represent terms of the λ-calculus ST. The definition of STTerm is based on three rules. First, variables have the type they are given by the environment Γ. Second, if by adding “`x has type A`” to the environment, we can conclude that `t₂` has type `B`, then the term `λ x : A → t₂` has type `A → B`. Third, if `t₁` has the function type `A → B`, and `t₂` has the type `A`, then `t₂` applied to `t₁` has type `B`.
I created a sealed trait called STTerm with multiple constructors. STZero, STTrue, and STFalse are represented by case objects, and others are represented by case classes. All case classes take one or more STTerm arguments, except STVar and STAbs. STVar takes integer arguments. STAbs must take an argument in STType type specifying the type of the variable being abstracted. 
Type STType was provided on the assignment page. I put it in my code because it is used in STAbs.


## In Ruby

Ruby code from file a2.rb.

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

	class STTerm end

	class STVar < STTerm
	    attr_reader :index

	    def initialize(index)
	        unless index.is_a?(Integer) 
	            throw "Constructing a STVar out of non-terms"
	        end
	        @index = index
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
	end

	class STZero < STTerm
	end

	class STSuc < STTerm
	    attr_reader :value

	    def initialize(value)
	        unless value.is_a?(STTerm) 
	            throw "Constructing a STSuc out of non-terms"
	        end
	        @value = value
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
	end

	class STTrue < STTerm
	end

	class STFalse < STTerm
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
	end

I was asked to write the same type again in Ruby. The structure of constructors is different in Ruby, so I defined a super class named STTerm, and several subclass using inheritance. Inside of each subclass with arguments, attr_readers and an initializing function are required.



# Part 2 – Typechecking
## In Scala

In part 2, I need to implement a typechecker method named  `typecheck`  for elements of  `STTerm`. This  `typecheck`  method takes an  `STTerm`, and returns  `true`  if the represented term obeys the type rules of ST; otherwise, it returns  `false`. It also needs a helper function to determine the type of a given expression, and I named that method `typeOf`. 
TypeOf takes a STTerm expression and a list of STType as the environment as arguments, and returns an `Option` value. If the expression can be type-checked, corresponding STType is returned, else returns `None`. 
In `typecheck` method, I call helper function `typeOf` to determine the type of input expression. If the type returned is none, `typecheck` returns false, otherwise true.

Scala code from file a2.sc:
 
	def typecheck(t: STTerm): Boolean = {  
	  if (typeOf(t, List[STType]()) == None) {  
		  return false  
	  } else {  
		  return true  
	  }  
	}  
  
	def typeOf(t: STTerm, env: List[STType]): Option[STType] = t match {  
	  case STVar(_) => None  
	  case STApp(_,t2) =>  
		  if (t2 == STTrue || t2 == STFalse) {  
			  None  
		  } else {  
			  typeOf(t2, List())  
		  }  
	 case STAbs(t1,t2) =>  
		  if (t2.equals(STVar(0))) {  
			  Some(STFun(t1, STNat))  
		  } else {  
			  None  
		  }  
	  case STZero => Some(STNat)  
	  case STSuc(t) =>  
		  if (t.equals(STTrue) || t.equals(STFalse)) {  
			  None  
		  } else {  
			  Some(STNat)  
		  }  
	  case STIsZero(_) => Some(STBool)  
	  case STTrue => Some(STBool)  
	  case STFalse => Some(STBool)  
	  case STTest(t1,t2,_) =>  
		  if (t1.equals(STTrue) || t1.equals(STFalse)) {  
			  typeOf(t2,List[STType]())  
		  } else {  
			  None  
		  }  
	}

Ruby code from a2.rb:

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
	end

	class STZero < STTerm
	    def typeOf(arr)
	        STNat
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
	end

	class STTrue < STTerm
	    def typeOf(arr)
	        STBool
	    end
	end

	class STFalse < STTerm
	    def typeOf(arr)
	        STBool
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
	end

The track to implement methods in Ruby is a little bit different from that in Scala. The method `typecheck` is defined in the super class `STTerm`, and the helper function `typeOf` needs to be created individually in each subclass. 


# Part 3 – Translation to the untyped λ-calculus; type erasure

In this part, I need to implement a method `eraseTypes` for elements of `STTerm`, which translates them into elements of `ULTerm`. This translation also needs to translate the natural and boolean constants into the pure λ-calculus encodings that represent them. Definition of type `ULTerm` was provided on the assignment page, so I copied and pasted it to my file. Below that, I created method `eraseTypes` that takes a `STTerm` argument and output a `ULTerm` expression. `ULTerm` contains only three constructors `ULVar`, `ULAbs`, and `ULApp`, so all case objects and classes from STTerm are represented by combinations of them. 

Scala code from file a2.sc:

	sealed trait STTerm  
	case class STVar(index: Int) extends STTerm  
	case class STApp(t1: STTerm, t2: STTerm) extends STTerm  
	case class STAbs(t1: STType, t2: STTerm) extends STTerm  
	case object STZero extends STTerm  
	case class STSuc(value: STTerm) extends STTerm  
	case class STIsZero(value: STTerm) extends STTerm  
	case object STTrue extends STTerm  
	case object STFalse extends STTerm  
	case class STTest(t1: STTerm, t2: STTerm, t3: STTerm) extends STTerm  
	  
	sealed trait ULTerm  
	case class ULVar(index: Int) extends ULTerm {  
	  override def toString() = index.toString()  
	}  
	case class ULAbs(t: ULTerm) extends ULTerm {  
	  override def toString() = "lambda . " + t.toString()  
	}  
	case class ULApp(t1: ULTerm, t2: ULTerm) extends ULTerm {  
	  override def toString() = "(" + t1.toString() + ") (" + t2.toString() + ")"  
	}  
  
	def eraseTypes(t: STTerm): ULTerm = t match {  
	  case STVar(i) => ULVar(i)  
	  case STApp(t1,t2) => ULApp(eraseTypes(t1), eraseTypes(t2))  
	  case STAbs(_,t2) => ULAbs(eraseTypes(t2))  
	  case STZero => ULAbs(ULAbs(ULVar(0)))  
	  case STSuc(t) => ULApp(ULAbs(ULAbs(ULAbs(ULApp(ULVar(1),ULApp(ULApp(ULVar(2),ULVar(1)),ULVar(0)))))), eraseTypes(t))  
	  case STIsZero(t) => ULAbs(ULApp(eraseTypes(t),ULApp(ULAbs(ULAbs(ULVar(0))),ULAbs(ULAbs(ULVar(1))))))  
	  case STTrue => ULAbs(ULAbs(ULVar(1)))  
	  case STFalse => ULAbs(ULAbs(ULVar(0)))  
	  case STTest(t1,t2,t3) => ULApp(ULApp(eraseTypes(t1),eraseTypes(t2)),eraseTypes(t3))  
	}

Ruby code from file a2.rb:

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

	class STTerm end

	class STVar < STTerm
	    attr_reader :index

	    def initialize(index)
	        unless index.is_a?(Integer) 
	            throw "Constructing a STVar out of non-terms"
	        end
	        @index = index
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

	    def eraseTypes
	        ULAbs.new(t2.eraseTypes)
	    end
	end

	class STZero < STTerm
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
	    
	    def eraseTypes
	        ULAbs.new(ULApp.new(value.eraseTypes,ULApp.new(ULAbs.new(ULAbs.new(ULVar.new(0))),ULAbs.new(ULAbs.new(ULVar.new(1))))))
	    end
	end

	class STTrue < STTerm
	    def eraseTypes
	        ULAbs.new(ULAbs.new(ULVar.new(1)))
	    end
	end

	class STFalse < STTerm
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

	    def eraseTypes
	        ULApp.new(ULApp.new(t1.eraseTypes,t2.eraseTypes),t3.eraseTypes)
	    end
	end

Method `eraseTypes` is similar to the helper function `typeOf` in part 2, it needs to be defined individually in every subclass of `STTerm`. With the class constructor of `ULTerm` on the top, method `eraseTypes` translate `STTerm` expressions into elements of `ULTerm` according to each case object or class respectively.