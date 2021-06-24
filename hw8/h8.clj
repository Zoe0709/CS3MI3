(load-file "./unwindrec.clj")

(unwindrec exponent [b n]
            (= n 0) 1
            (> n 0) (* b (exponent b (- n 1)))
            (throw (Exception. "Trying to calculate zero or negative exponent.")))

(defn exponent-tr [b n]
  (unwindrec exponent-tr-helper [b n collect]
              (= n 0) collect
              (> n 0) (exponent-tr-helper b (- n 1) (* collect b))
              (throw (Exception. "Trying to calculate zero or negative exponent.")))
  (exponent-tr-helper b n 1))

(unwindrec sumlist [l]
            (empty? l) 0
            :else (+ (first l) (sumlist (drop 1 l)))
            (throw (Exception. "Trying to calculate sum of a list of other types.")))

(defn sumlist-tr [l]
  (unwindrec sumlist-tr-helper [l collect]
              (empty? l) collect
              :else (sumlist-tr-helper (drop 1 l) (+ collect (first l)))
              (throw (Exception. "Trying to calculate sum of a list of other types.")))
  (sumlist-tr-helper l 0))

(unwindrec flattenlist [ls]
            (empty? ls) nil
            :else (concat (first ls) (flattenlist (drop 1 ls)))
            (throw (Exception. "Trying to flatten a list of other types of elements.")))
 
(defn flattenlist-tr [ls]
  (unwindrec flattenlist-tr-helper [ls collect]
              (empty? ls) collect
              :else (flattenlist-tr-helper (drop 1 ls) (concat collect (first ls)))
              (throw (Exception. "Trying to flatten a list of other types of elements.")))
  (flattenlist-tr-helper ls ()))

(unwindrec postfixes [l]
            (empty? l) '(())
            :else (concat (list l) (postfixes (drop 1 l)))
            (throw (Exception. "Trying to get a list of sublists of other types.")))

(defn postfixes-tr [l]
  (unwindrec postfixes-tr-helper [l collect]
              (empty? l) (concat collect '(()))
              :else (postfixes-tr-helper (drop 1 l) (concat collect (list l)))
              (throw (Exception. "Trying to get a list of sublists of other types.")))
  (postfixes-tr-helper l ()))


