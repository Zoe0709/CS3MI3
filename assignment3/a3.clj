(defrecord GuardedCommand [guard command])

(defrecord GCConst [int1 int2])

(defrecord GCVar [:var])

(defrecord GCOp [expr1 expr2 :op])

(defrecord GCComp [expr1 expr2 :compr])

(defrecord GCAnd [test1 test2])

(defrecord GCOr [test1 test2])

(defrecord GCTrue [t])

(defrecord GCFalse [f])

(defrecord GCSkip [n])

(defrecord GCAssign [:s expr])

(defrecord GCCompose [stmt1 stmt2])

(defrecord GCIf [testl stmtl])

(defrecord GCDo [testl stmtl])

(defrecord GCLocal [:global stmt])

(defrecord Config [stmt sig])

(defn reduce [config]
    (if (empty? config) (Config (GCSkip nil) emptyState)
        (let [[sig & rest] config]
            (if (eval (.stmt sig)) (.sig sig)
                ((reduce rest) (updateState sig))))))

(defn emptyState []
    (map (fn [x] (= x 0)))) 

(defn updateState [sigma,x,n]
    (map (fn [[key value]] [x n])
            sigma))