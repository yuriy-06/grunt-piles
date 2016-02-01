(in-package :grunt-piles)

(defclass point ()   ;то что будет выводиться непосредственно ввиде свай в лиру
  ((list-ig :accessor point-list-ig :initarg :list-ig :initform nil)  
   (x :accessor point-x :initarg :x :initform nil)
   (y :accessor point-y :initarg :y :initform nil)
   (c :accessor point-c :initarg :c :initform nil)
   (alfa-i :accessor point-alfa-i :initarg :alfa-i :initform nil)
   (Lr :accessor point-Lr :initarg :Lr :initform nil)
   (bp :accessor point-bp :initarg :bp :initform 1.025)
   (z-list :accessor point-z-list :initarg :z-list :initform nil)
   (ke-10type-list :accessor ke-10type-list :initarg :ke-10type-list :initform nil); не используется сейчас
   (nodes-point :accessor nodes-point :initarg :nodes-point :initform nil)   ; не используется сейчас
   ))

(defmethod Lr ((obj1 ig-list) (obj2 svaya) sech) ; (Lr obj-ig-list obj-svaya "S0") "S6" (круглое и квадратное)
; метод определяет и задает расчетную длину сваи и условную ширину сваи
  (let (K-list (gamma-c 3) b I bp r d K E ae L0 lr)
    (cond ((equal sech "S0")(setf  ; если свая квадратная
                             b (svaya-b obj2) 
                             I (/ (expt b 4) 12) 
                             bp (+ (* 1.5 b) 0.5)))
          ((equal sech "S6")(progn
                              (setf   ; если свая круглая
                               r (/ (svaya-d obj2) 2)
                               d (* r 2)
                               I (/ (* 3.142 (expt r 4)) 4))
                              (if (> d 0.8) (setf bp (+ d 1))
                                (setf bp (+ (* 1.5 d) 0.5)))))) 
    (dolist (x (ig-list obj1)) (setf K-list (append K-list (list (ig-K x)))))
    (setf K (nth 0 (min-max-list K-list))
          E (svaya-E obj2)
          ae (expt (/ (* K bp) (* gamma-c E I)) 1/5)
          L0 (dlina-L0 obj2)          
          lr (+ L0 (/ 2 ae)))
    (setf (svaya-Lr obj2) Lr
          (svaya-bp obj2) bp)
    (values "Lr" Lr "bp" bp) ;на всякий случай выводим для сверки значения на консоль
    ))

(defmethod point-init (m-ig m-c m-alfa-i (obj1 svaya) m-z)  
;; метод собирает до кучи все геометрические и расчетные параметры сваи, готовит их к выводу в схему лиры
  ;;(declare (optimize (debug 3)))
  ;;(break)
  (let (n m-point Lr bp mci mai x y c alfa-i )
    (setf n (list-length m-c)
          Lr (svaya-Lr obj1)
          bp (svaya-bp obj1))
    (do 
      ;var
        ((i 0 (+ i 1)))
      ;end-test-form
        ((equal i n))
    ;result-form
    ;statement
      (progn 
        (setf mci (nth i m-c)
              mai (nth i m-alfa-i)
              x (parse-float (second mci))
              y (parse-float (third mci))
              c (fifth mci)
              alfa-i (fifth mai)
              m-point (append m-point (list (make-instance 'point :list-ig m-ig :x x :y y :c c :alfa-i alfa-i :bp bp :Lr Lr :z-list m-z))))))
    (values m-point)))

(defun base-j-f (jest base-j) ; параметры жесткость и база жесткостей вида ((j1 1) (j2 2) (j3 3) ...)
  (let ((j jest) (bas base-j) f s )
    (dolist (x bas) (progn
                         (setf f (first x) ;сама жесткость
                               s (second x)) ; номер жесткости
                         (if (equal f j) (return-from base-j-f (values s bas)))))
    (setf bas (append bas (list (list j (+ s 1)))))
    (values (+ s 1) bas)))

(defmethod doc3-article ((obj1 svaya) tip-sv) ;тип сваи может быть "S0" и "S6" (квадратные и круглые) (doc3-article sv1 "S0")
;метод создает заголовок 3-го документа (жесткости)
  (let (RO b d doc3)
    (cond ((equal tip-sv "S0")
           (setf b (svaya-b obj1) RO (* 2.5 b b)
            doc3 (concatenate 'string "( 3/" (string #\Newline) "1 S0 3.000E+006 " (write-to-string (* b 100))  " " (write-to-string (* b 100)) 
                              "/" (string #\Newline) "0 RO " (write-to-string (ocrugl-1.00000 RO)) "/")))
          ((equal tip-sv "S6")
           (setf d (svaya-d obj1) RO (svaya-b obj1)
                 doc3 (concatenate 'string "( 3/" (string #\Newline) "1 S6 3.000E+006 " (write-to-string (* d 100))  
                                   " 0/" (string #\Newline) "0 RO " (write-to-string (ocrugl-1.000 RO)) "/"))))
    (values doc3)))

(defmacro lira-creater (&key name-method)
  `(defmethod ,name-method (m-point sv1 tip-sv &optional (directory "c:/lisp/")) ;(lira m-point sv1 tip-sv directory) ;выводит текстушку Лиры
 ;; (declare (optimize (debug 3)))
 ;; (break)
  (let (doc0  (doc1 "( 1/") doc3  (doc4 "( 4/") doc5  doc6  
	      doc7 doc19 (i 1) (i2 1) (gamma-c 3) file-lira
	       LIST-IG  ALFA-I  BP C XC YC Z-list c-bok k z1 z2 zsr ij n f s	      
        (base-j  (list (list "1 S0 3.000E+006     35     35/" 1))))
    (setf doc0 (concatenate 'string "( 0/ 1; 123/ 2; 5/" (string #\Newline) "28; 0 1 0  1 0 0  0 0 1; /" (string #\Newline) 
                            "33;M 1 CM 100 T 1 C 1 /" (string #\Newline) 
                            "39;" (string #\Newline) 
                            " 1: load 1 ;" (string #\Newline) 
                            " /" (string #\Newline) 
                            ")" (string #\Newline) ))
    (setf doc3 (doc3-article sv1 tip-sv)) ; документ 3 надо будет еще в конце закрыть скобкой
    (setf doc5 (concatenate 'string 
                            ;;(string #\Newline) 
                            "( 5/" (string #\Newline) 
                            "1 6 /" (string #\Newline) 
                            ")" (string #\Newline) ))
    (setf doc6 (concatenate 'string (string #\Newline)
                            "(6/" (string #\Newline)
                            "1 0 3 1 1 /" (string #\Newline)
                            ")" (string #\Newline) ))
    (setf doc7 (concatenate 'string  (string #\Newline)
                            "( 7/" (string #\Newline)
                            "1 0 0 /" (string #\Newline)
                            ")" (string #\Newline)  ))
    (setf doc19 (concatenate 'string "(19/" (string #\Newline)))
    (setf list-ig (point-list-ig (first m-point)))
    (dolist (x m-point) (progn
                          (setf z-list (point-z-list x)
                                xc (point-x x)
                                yc (point-y x)
                                c (point-c x)
                                bp (point-bp x)
                                alfa-i (point-alfa-i x))
                          (dolist (j z-list) (progn 
                                               (setf doc4 (concatenate 'string doc4 " " (write-to-string xc) " "
                                                                       (write-to-string yc) " " (write-to-string (- 0 j)) " /" (string #\Newline)));добавляются узлы сваи
                                               (if (equal (first (last z-list)) j) (return));
                                               (setf doc1 (concatenate 'string doc1 (write-to-string 10) " 1 " (write-to-string (+ i 1)) " "
                                                                       (write-to-string i) " /" (string #\Newline)); добавляются элементы сваи
                                                   i (+ i 1))))
                          (dolist (j list-ig) (progn
                                                (setf K (ig-K j)
                                                      z1 (ig-z1 j)
                                                      z2 (ig-z2 j)
                                                      zsr (/ (+ z1 z2) 2)
                                                      c-bok (round (/ (* K zsr alfa-i) gamma-c))
                                                      doc19 (concatenate 'string doc19 
                                                                         (write-to-string i2) " "
                                                                         (write-to-string bp) " "
                                                                         (write-to-string c-bok) " " "0" " "
                                                                         (write-to-string bp) " "
                                                                         (write-to-string c-bok) " " "0" "/
")
                                                      i2 (+ i2 1))
                                                (if (equal (first (last list-ig)) j) (progn 
                                                                                       (setf i2 (+ i2 1)) ; пропуск КЭ 51
                                                                                       (return)))
                                                ))
                          (multiple-value-setq (ij base-j) (base-j-f c base-j))
                          (setf doc1 (concatenate 'string doc1  "51 " (write-to-string ij) " " (write-to-string i) " /" (string #\Newline))) ;добавляются элементы 51-го типа (ij - номер жесткости)
                          (setf i (+ i 1))));начинается с нового узла новая свая
    (setf n (first base-j))
    (setf base-j (delete n base-j));удаление первого элемента списка
    (dolist (x base-j) (setf f (first x)
                             s (second x)
                             doc3 (concatenate 'string doc3 
                                               (write-to-string s) " "
                                               (write-to-string 3) " "
                                               (write-to-string f) " "
                                               (write-to-string '/) (string #\Newline))))
        (setf doc1 (concatenate 'string doc1 ")" )) ; закрываем здесь doc1
        (setf doc4 (concatenate 'string doc4 ")" )) ; закрываем здесь doc4
        (setf doc3 (concatenate 'string doc3 ")" )) ; закрываем здесь doc3
        (setf doc19 (concatenate 'string doc19 ")"));закрываем здесь doc19
	(setf file-lira (concatenate 'string directory "lira.txt"))

	(with-open-file (stream file-lira :direction :output :if-exists :supersede)
	  
	  (format stream "~{~a~}" (list doc0 doc1 doc3 doc4 doc5 doc6 doc7 doc19))))))

(lira-creater :name-method lira )
(lira-creater :name-method lira-web )

(defmethod proverka-h-grunts ((obj1 svaya) (obj2 ig-list)) ;(proverka-h-grunts sv1 grunts)
  (let ((h 0))
    (dolist (x (ig-list obj2)) (setf h (+ h (ig-H x))))
    (if (> (* (dlina-L obj1) 1.5) h) 
		(progn (print "недостаточна глубина слоев ИГЭ")
				(setf *grunt-string* (concatenate 'string *grunt-string* "недостаточна глубина слоев ИГЭ"))))))


;непосредственно задание данных---------------------------------------------------------------------------------------------------
(defun 3915-25-2 (&key nodes-file limit-r)  ;  (3915-25-2 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 1.7)
  (let (m-ig m-z grunts sv1 odin-j m-c m-alfa-i)
    (setf ;задаем характеристики грунтов
     grunts 
     (make-instance 'ig-list 
                    :dH (list (make-instance 'ig :H 4.6 :E 660 :mu 0.37 :K 1800)   ;задаем список порядка расположения грунтов и сами грунты
                              (make-instance 'ig :H 3 :E 890 :mu 0.37 :K 1576)     ;сверху вниз от верха сваи
                              (make-instance 'ig :H 6.3 :E 1290 :mu 0.31 :K 1800)   ;общая Н должна быть 1,5 длины сваи (ввести проверку)
                              (make-instance 'ig :H 10 :E 2450 :mu 0.3 :K 1800))))  
    (z grunts)  ; расчитываются координаты z грунтов
    (setf sv1 (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)) ;задаются параметры сваи
    (setf odin-j (s sv1 grunts))  ;вычисляется жесткость под концом одиночной сваи
    (setf m-c (s-ad sv1 nodes-file)) ;вычисляется и затем выводится список жесткостей с координатами свай, с учетом взаимного влияния
    (plot m-c "c:/lisp/grunt/svaya-c.svg" "svaya-c")  ;данные (список жесткостей) выводятся в картинку
    (Lr grunts sv1 "kv") ;вычисляем расчетную длину сваи
    (setf m-alfa-i (alfa-c sv1 :node-csv-file nodes-file :gamma-c 1.2 :limit-r limit-r)) ;вычисляются коэффициенты по боковой поверхности свай
    (plot m-alfa-i "c:/lisp/grunt/svaya-alfa-c.svg" "alfa-i")  ; а затем тоже выводятся в картинку

    (setf m-ig (layer-small sv1 grunts)
          m-z (layer-z-list m-ig))
    
    (lira (point-init m-ig m-c m-alfa-i sv1 m-z))
    (print "расчетная длина сваи") 
    (print (svaya-Lr sv1))
    (print "жесткость под концом одиночной сваи" )
    (print odin-j)))
