sealed trait Stream[+A]
case object SNil extends Stream[Nothing]
case class Cons[A](a: A, f: Unit => Stream[A]) extends Stream[A]

// Methods below are from the lecture/tutorial note Infinite data in Scala
def constantStream[A](a: A): Stream[A] =
  Cons(a, _ => constantStream(a))

def take[A](n: Int, s: => Stream[A]): List[A] = s match {
  case SNil => Nil
  case Cons(a,f) => n match {
    case n if n > 0 => a :: take(n-1,f())
    case _ => Nil
  }
}

def prepend[A](l: List[A], s: => Stream[A]): Stream[A] = l match {
  case Nil => s
  case (h :: t) => Cons(h, _ => prepend(t, s))
}

def toStream[A](l: List[A]): Stream[A] = prepend(l, SNil)

def repeat[A](l: List[A]): Stream[A] = prepend(l, repeat(l))

def append[A](s: => Stream[A], t: => Stream[A]): Stream[A] = s match {
  case SNil => t
  case Cons(a, f) => Cons(a, _ => append(f(),t))
}

// Part 1
def filter[A](p: A => Boolean, s: => Stream[A]): Stream[A] = s match {
  case SNil => s
  case Cons(a,f) => p match {
    case p if p(a) => append(toStream(List(a)), filter(p,f()))
    case p if !p(a) => filter(p,f())
    case _ => SNil
  }
}

// Part 2
def zip[A](x: => Stream[A], y: => Stream[A]): Stream[(A,A)] = x match {
  case SNil => SNil
  case Cons(a,f) => y match {
    case SNil => SNil
    case Cons(b,g) => Cons((a,b),_ => zip(f(),g()))
  }
}

def merge[A](x: => Stream[A], y: => Stream[A]): Stream[A] = x match {
  case SNil => y
  case Cons(a,f) => y match {
    case SNil => x
    case Cons(b,g) => append(toStream(List(a,b)), merge(f(),g()))
  }
}

// Part 3
def all[A](p: A => Boolean, s: => Stream[A]): Boolean = s match {
  case SNil => true
  case Cons(a,f) => p match {
    case p if p(a) => all(p,f())
    case p if !p(a) => false
    case Nil => true
  }
}

def exists[A](p: A => Boolean, s: => Stream[A]): Boolean = s match {
  case SNil => false
  case Cons(a,f) => p match {
    case p if p(a) => true
    case p if !p(a) => exists(p,f())
    case Nil => false
  }
}

// Part 4
def zipSafe[A](x: => Stream[A], y: => Stream[A]): Stream[(A,A)] = (x,y) match {
  case (SNil,_) => SNil
  case (_,SNil) => SNil
  case (Cons(a,f),Cons(b,g)) => Cons((a,b),_ => zipSafe(f(),g()))
}

def mergeSafe[A](x: => Stream[A], y: => Stream[A]): Stream[A] = (x,y) match {
  case (SNil,_) => y
  case (_,SNil) => x
  case (Cons(a,f),Cons(b,g)) => append(toStream(List(a,b)), mergeSafe(f(),g()))
}
