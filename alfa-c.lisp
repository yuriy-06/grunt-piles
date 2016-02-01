(in-package :grunt-piles)
(defmethod alfa-c ((obj1 svaya) &key node-csv-file gamma-c limit-r) 
;(alfa-c (make-instance 'svaya :L 9 :A 0.1225 :E 3.06e6) :node-csv-file "c:/lisp/grunt/nodes.csv" :gamma-c 1.2 :limit-r 5)
					;(alfa-c sv1 :node-csv-file "c:/lisp/grunt/nodes.csv" :gamma-c 1.2 :limit-r 5)
  (let (d nodes-massive stroka m-nodes m-v m2-nodes number1 x1 y1 number2 x2 y2 r a1 a2 b2 b11 b1 alfa-j m-delta a-sv) ;; инициируются переменные
    (setf d (svaya-b obj1)      nodes-massive (nodes node-csv-file))  ;; задается именно сторона сваи а не обязательно размер выводимый из площади сваи
    
    (dolist (x nodes-massive) 
      (setf stroka (split ";" (filter x))
	    m-nodes (append m-nodes (list stroka)))) ;рубим nodes-massive ";" и оформляем ввиде m-nodes
    (setf m2-nodes m-nodes) ;размножаем массив m-nodes на m2-nodes, чтобы организовать цикл в цикле
	
    (dolist (x m-nodes) (progn
			  (setf number1 (first x)  ;первый цикл пошел и number1 - номер узла 
				x1 (parse-float (second x)) ;соответственно координаты х
				y1 (parse-float (third x))) ; и y
			  (dolist (j m2-nodes)    ; второй цикл пошел
			    (progn
			      (setf number2 (first j) ; number2  -- номер узла во втором цикле
				    x2 (parse-float (second j)) ;соответственно координаты х
				    y2 (parse-float (third j))) ; и y
			      (if (equal number1 number2)() ; если номера узлов совпадают, то ничего не происходит 
					; иначе выполняется тело цикла
					;------------------------------------------------------
				  (progn 
				    (setf r (sqrt (+ (expt (- x1 x2) 2) (expt (- y1 y2) 2) )))  ;; расстояние между сваями
				    (if (> limit-r r) 
					  (setf
					   a1 (abs (- x2 x1)) ;по модулю взял в отличие от СП
					   a2 (expt (/ a1 r) 2)
					   b2 (* 0.15 a2)
					   b11 (/ a1 r)
					   b1 (* 0.36 b11)
					   alfa-j (- 1 (* (/ d r) (+ 1.17 (- b1 b2))))
					   m-delta (append m-delta (list alfa-j))))))))
					;---------------------------------------------------------
					; когда обсчитали все узлы во втором цикле
					; можно вычислить произведение   m-delta
                          (setf a-sv (* gamma-c (pr-number-list m-delta))   ;менял переменные a-sv и c-sv
					;обнулить m-delta
                                m-delta nil)
                          (if (> a-sv 1.2)(setf a-sv 1.2))
					;вывести в общий массив результатов
					;;что здесь происходит -- образуется массив 
					;; (номер-узла x y z alfa-c)
			  (setf m-v (append m-v (list (append x (list  (ocrugl-1.000 a-sv)))))) ;менял функцию округления
			  ))
    (values m-v) ;вывод массива результатов
    ))
