/*
 * COMPSCI 3MI3 Homework 3
 * Zoe Ning (ningh4)
 * October 4, 2020
 */

def isPrime[A](num: Int): Boolean = {
  if (num <= 1) false
  else if (num == 2) true
  else !(2 until num).exists(x => num % x == 0)
}

def isPalindrome[A](l: List[A]): Boolean = l match {
  case Nil => true
  case List(a) => true
  case list => (list.head == list.last && isPalindrome(list.tail.init))
}

def primePalindrome[A](n: Int): Boolean = {
  if (isPrime(n) && isPalindrome(digitList(n))) true
  else false
}

def digitList[A](n: Int): List[Int] = {
  def reverse[A](l: List[Int]): List[Int] = l match {
    case Nil => Nil
    case head :: tail => reverse(tail) ::: List(head)
  }
  reverse(n.toString.map(_.asDigit).toList)
}
