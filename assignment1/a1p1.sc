sealed trait Expr[+A]
case class Const[A](a: Int) extends Expr[A]
case class Neg[A](a: Expr[A]) extends Expr[A]
case class Abs[A](a: Expr[A]) extends Expr[A]
case class Plus[A](a: Expr[A], b: Expr[A]) extends Expr[A]
case class Times[A](a: Expr[A], b: Expr[A]) extends Expr[A]
case class Minus[A](a: Expr[A], b: Expr[A]) extends Expr[A]
case class Exp[A](a: Expr[A], b: Expr[A]) extends Expr[A]

def interpretExpr[A](s: => Expr[A]): Int = s match {
  case Const(a) => a
  case Neg(a) => - interpretExpr(a)
  case Abs(a) => interpretExpr(a).abs
  case Plus(a,b) => interpretExpr(a) + interpretExpr(b)
  case Times(a,b) => interpretExpr(a) * interpretExpr(b)
  case Minus(a,b) => interpretExpr(a) - interpretExpr(b)
  case Exp(a,b) => math.pow(interpretExpr(a),interpretExpr(b)).toInt
}

