sealed trait VarExpr[+A]
case class Const[A](a: Int) extends VarExpr[A]
case class Neg[A](a: VarExpr[A]) extends VarExpr[A]
case class Abs[A](a: VarExpr[A]) extends VarExpr[A]
case class Plus[A](a: VarExpr[A], b: VarExpr[A]) extends VarExpr[A]
case class Times[A](a: VarExpr[A], b: VarExpr[A]) extends VarExpr[A]
case class Minus[A](a: VarExpr[A], b: VarExpr[A]) extends VarExpr[A]
case class Exp[A](a: VarExpr[A], b: VarExpr[A]) extends VarExpr[A]
case class Var[A](v: Symbol) extends VarExpr[A]
case class Subst[A](s1: VarExpr[A], v: Symbol, s2: VarExpr[A]) extends VarExpr[A]


def interpretVarExpr[A](s: => VarExpr[A]): Int = s match {
  case Const(a) => a
  case Neg(a) => - interpretVarExpr(a)
  case Abs(a) => interpretVarExpr(a).abs
  case Plus(a,b) => interpretVarExpr(a) + interpretVarExpr(b)
  case Times(a,b) => interpretVarExpr(a) * interpretVarExpr(b)
  case Minus(a,b) => interpretVarExpr(a) - interpretVarExpr(b)
  case Exp(a,b) => math.pow(interpretVarExpr(a),interpretVarExpr(b)).toInt
  case Subst(s1,v,s2) => interpretVarExpr(substitution(s1,v,s2))
}

def substitution[A](e1: VarExpr[A], s: Symbol, e2: VarExpr[A]): VarExpr[A] = e1 match {
  case Plus(a,b) => (a,b) match {
    case (Var(v),_) if symbolCompare(v,s) => Plus(e2,b)
    case (_,Var(v)) if symbolCompare(v,s) => Plus(a,e2)
    case (_,_) =>
      Plus(substitution(a,s,e2),substitution(b,s,e2))
  }
  case Times(a,b) => (a,b) match {
    case (Var(v),_) if symbolCompare(v,s) => Times(e2,b)
    case (_,Var(v)) if symbolCompare(v,s) => Times(a,e2)
    case (_,_) =>
      substitution(a,s,e2)
      substitution(b,s,e2)
  }
  case Minus(a,b) => (a,b) match {
    case (Var(v),_) if symbolCompare(v,s) => Minus(e2,b)
    case (_,Var(v)) if symbolCompare(v,s) => Minus(a,e2)
    case (_,_) =>
      substitution(a,s,e2)
      substitution(b,s,e2)
  }
  case Exp(a,b) => (a,b) match {
    case (Var(v),_) if symbolCompare(v,s) => Exp(e2,b)
    case (_,Var(v)) if symbolCompare(v,s) => Exp(a,e2)
    case (_,_) =>
      substitution(a,s,e2)
      substitution(b,s,e2)
  }
  case Var(v) if symbolCompare(v,s) => e2
  case Subst(x,z,y) => substitution(substitution(x,z,y),s,e2)
}

def symbolCompare[A](s1: Symbol, s2: Symbol): Boolean = {
  s1.toString() == s2.toString()
}