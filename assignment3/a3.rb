module GCL

    class GCExpr
        include GCL
        class GCConst < GCExpr
            attr_reader :const

            def initialized(c)
                unless c.is_a?(Integer)
                    throw "Non-integer argument."
                end
                @const = c
            end

            def doReduce(arr)
                @const
            end
        end

        class GCVar < GCExpr
            attr_reader :var
    
            def initialize(v)
                @var = v[:var] if v[:var]
            end

            def doReduce(arr)
                arr.append(@var)
            end
        end

        class GCOp < GCExpr
            attr_reader :a1
            attr_reader :a2
            attr_reader :a3

            def initialize(a1,a2,a3)
                unless a1.is_a?(GCExpr) && a2.is_a?(GCExpr)
                    throw "Operation with non GC expression terms."
                end
                @a3 = a3[:a3] if a3[:a3]
            end
            @a1 = a1; @a2 = a2
        end
    end
        
        
    class GCTest 
        include GCL
        class GCComp < GCTest
            attr_reader :t1
            attr_reader :t2
            attr_reader :t3

            def initialize(t1,t2,t3)
                unless t1.is_a?(GCExpr) && t2.is_a?(GCExpr)
                    throw "Comparison with non GC expression terms."
                end
                @t3 = t3[:t3] if t3[:t3]
            end
            @t1 = t1; @t2 = t2
        end

        class GCAnd < GCTest
            attr_reader :b1
            attr_reader :b2
            def initialize(b1,b2)
                unless b1.is_a?(GCTest) &&b2.is_a?(GCTest)
                    throw "And logic with non GC test terms."
                end
            end
            @b1 = b1; b2 =b2
        end
            
        class GCOr < GCTest
            attr_reader :c1
            attr_reader :c2
            def initialize(c1,c2)
                unless c1.is_a?(GCTest) && c2.is_a?(GCTest)
                    throw "Or logic with non GC test terms."
                end
            end
            @c1 = c1; @c2 = c2
        end

        class GCTrue < GCTest

        end
            
        class GCFalse < GCTest
        
        end
    end 

    class GCStmt
        include GCL
        class GCSkip < GCStmt

        end

        class GCAssign < GCStmt
            attr_reader :s1
            attr_reader :s2
            def initialize(s1,s2)
                unless s2.is_a?(GCExpr)
                    throw "Incorrect assign."
                end
                @s1 = s1[:s1] if s1[:s1]
            end
            @s2 = s2

            def doReduce(arr)
                arr.append(@s1)
                @s2.doReduce(arr)
            end
        end

        class GCCompose < GCStmt
            attr_reader :d1
            attr_reader :d2
            def initialize(d1,d2)
                unless d1.is_a?(GCStmt) && d2.is_a?(GCStmt)
                    throw "Incorrect compose."
                end
            end
            @d1 = d1; @d2 = d2; 
        end 

        class GCIf < GCStmt
            attr_reader :e1
            attr_reader :e2
            def initialize(e1,e2)
                unless e1.all?(GCTest) && e2.all?(GCStmt)
                    throw "GCIf argument incorrect type."
                end
            end
            @e1 = e1; @e2 = e2;
        end
            
        class GCDo < GCStmt
            attr_reader :f1
            attr_reader :f2
            def initialize(f1,f2)
                unless f1.all?(GCTest) && f2.all?(GCStmt)
                    throw "GCDo argument incorrect type."
                end
            end
            @f1 = f1; @f2 = f2;
        end

        class GCLocal < GCStmt
            attr_reader :g1
            attr_reader :g2
            def initialize(g1,g2)
                unless g2.is_a?(GCStmt)
                    throw "Incorrect local."
                end
                @g1 = g1[:g1] if g1[:g1]
            end
            @g2 = g2

            def doReduce(arr)
                arr.append(@g1)
                @g2.doReduce(arr)
            end
        end
    end

    def stackEval(c,r,sigma)
        @c.each { |token| @r << token }
            if token.type == :a3
                rightn = @r.pop
                leftn = @r.pop
                sym = @r.pop
                raise "Invalid evaluate expression" unless rightn && leftn 
                rlt = evaluate(rightn, leftn, token)
                @r << rlt
            end
        updateState(sigma,sym,rlt)
    end 

    def evaluate(rn, ln, op)
        case op
        when :plus then ln + rn
        when :minus then ln - rn
        when :times then ln * rn
        when :div then ln / rn
        end
    end

    def emptyState
        lambda { |x| x = 0 }
    end

    def updateState(sigma,x,n)
        sigma.map { |x| x = n }
    end

end

module GCLe

    class GCProgram
        include GCLe

        attr_reader :globals
        attr_reader :stmt

        def initialize(globals,stmt)
            unless stmt.is_a?(GCStmt)
                throw "Incorrect program."
            end
        end
        @globals = globals; @stmt = stmt

        def doReduce(arr)
            @stmt.doReduce(arr)
        end
    end

    def inScope
        @stmt.doReduce(arr)
        @globals.each { |x| arr.include? x }
    end

    def wellScoped(pro)
        if (pro.inScope) 
            true
        else
            false
        end
    end

    def eval(gcpro)
        gcpro.stmt.doReduce(arr)
        rlt = hash.new
        until arr.emmpty? do
            rlt[globals] = stackEval(arr,[],gcpro)
            arr.first arr.size - 1
        end
    end
end

