class Expr
    def initialize
    end
end

class Const < Expr
    attr_accessor :value
    def initialize(value=nil)
        @value = value
    end

    def interpret
        self.value
    end
end

class Neg < Expr
    attr_accessor :value
    def initialize(value=nil)
        @value = value
    end

    def interpret
         -1 * self.value.interpret
    end
end

class Abs < Expr
    attr_accessor :value
    def initialize(value=nil)
        @value = value
    end

    def interpret
        self.value.interpret.abs
    end
end

class Plus < Expr
    attr_accessor :value1
    attr_accessor :value2
    def initialize(value1=nil,value2=nil)
        @value1 = value1
        @value2 = value2
    end

    def interpret
        self.value1.interpret + self.value2.interpret
    end
end

class Times < Expr
    attr_accessor :value1
    attr_accessor :value2
    def initialize(value1=nil,value2=nil)
        @value1 = value1
        @value2 = value2
    end

    def interpret
        self.value1.interpret * self.value2.interpret
    end
end

class Minus < Expr
    attr_accessor :value1
    attr_accessor :value2
    def initialize(value1=nil,value2=nil)
        @value1 = value1
        @value2 = value2
    end

    def interpret
        self.value1.interpret - self.value2.interpret
    end
end

class Exp < Expr
    attr_accessor :value1
    attr_accessor :value2
    def initialize(value1=nil,value2=nil)
        @value1 = value1
        @value2 = value2
    end

    def interpret
        self.value1.interpret ** self.value2.interpret
    end
end

def construct_const(a)
    const = Const.new()
    const.value = a
    return const
end

def construct_neg(a)
    neg = Neg.new(a)
    return neg
end
    
def construct_abs(a)
    absv = Abs.new(a)
    return absv
end

def construct_plus(a,b)
    plus = Plus.new(a,b)
    return plus 
end    
    
def construct_times(a,b) 
    times = Times.new(a,b)
    return times
end
    
def construct_minus(a,b) 
    minus = Minus.new(a,b)
    return minus
end
    
def construct_exp(a,b)
    exp = Exp.new(a,b)
    return exp
end


