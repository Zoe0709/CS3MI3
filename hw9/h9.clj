(defrecord GuardedCommand [guard command])

(defn allowed-commands [commands]
    (if (empty? commands) nil
        
        (let [[command & rest] commands]
            (let [value (.command command)]
            (if (eval (.guard command)) 
                (concat (list value) (allowed-commands rest))
                (allowed-commands rest))))))

(defmacro guarded-if
    [& commands]
    `(eval 
      (rand-nth (allowed-commands  
       [~@commands])))) 

(defmacro guarded-do [& commands]
    (if (empty? commands) nil
        (let [[command & rest] commands]
            (let [value (.command command)]
            (if (eval (.guard command)) 
                (concat (list value) (allowed-commands rest))
                (allowed-commands rest))))))

(defn gcd [x y]
    (if (not (zero? y)) 
        (gcd y (rem x y)) 
        x))

