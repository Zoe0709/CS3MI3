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
  case STZero =>
    Some(STNat)
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

