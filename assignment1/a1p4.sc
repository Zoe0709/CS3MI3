sealed trait MixedExpr[+A]
case class Const[A](a: Int) extends MixedExpr[A]
case class Neg[A](a: MixedExpr[A]) extends MixedExpr[A]
case class Abs[A](a: MixedExpr[A]) extends MixedExpr[A]
case class Plus[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]
case class Times[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]
case class Minus[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]
case class Exp[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]
case object TT extends MixedExpr[Nothing]
case object FF extends MixedExpr[Nothing]
case class Bnot[A](a: MixedExpr[A]) extends MixedExpr[A]
case class Band[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]
case class Bor[A](a: MixedExpr[A], b: MixedExpr[A]) extends MixedExpr[A]

def interpretInt[A](value: => MixedExpr[A]): Int = value match {
  case Const(a) => a
  case Neg(a) => - interpretInt(a)
  case Abs(a) => interpretInt(a).abs
  case Plus(a,b) => interpretInt(a) + interpretInt(b)
  case Times(a,b) => interpretInt(a) * interpretInt(b)
  case Minus(a,b) => interpretInt(a) - interpretInt(b)
  case Exp(a,b) => math.pow(interpretInt(a),interpretInt(b)).toInt
}

def interpretBool[A](value: => MixedExpr[A]): Boolean = value match {
  case TT => true
  case FF => false
  case Bnot(a) => !interpretBool(a)
  case Band(a,b) => interpretBool(a) && interpretBool(b)
  case Bor(a,b) => interpretBool(a) || interpretBool(b)
}

def interpretMixedExpr[A](m: => MixedExpr[A]): Option[Either[Int,Boolean]] = m match {
  case Const(a) => Some(Left(a))
  case Neg(a) => Some(Left(interpretInt(Neg(a))))
  case Abs(a) => Some(Left(interpretInt(Abs(a))))
  case Plus(a,b) => Some(Left(interpretInt(Plus(a,b))))
  case Times(a,b) => Some(Left(interpretInt(Times(a,b))))
  case Minus(a,b) => Some(Left(interpretInt(Minus(a,b))))
  case Exp(a,b) => Some(Left(interpretInt(Exp(a,b))))
  case TT => Some(Right(interpretBool(TT)))
  case FF => Some(Right(interpretBool(FF)))
  case Bnot(a) => Some(Right(interpretBool(Bnot(a))))
  case Band(a,b) => Some(Right(interpretBool(Band(a,b))))
  case Bor(a,b) => Some(Right(interpretBool(Bor(a,b))))
}


