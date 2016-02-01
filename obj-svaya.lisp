(in-package :grunt-piles)

(defvar *grunt-string* "")

(defclass ig ()   ;клас ИГЭ
  ((H :accessor ig-H  :initarg :H   :initform 0)
   (E :accessor ig-E  :initarg :E   :initform 1500)
   (mu :accessor ig-mu :initarg :mu :initform 0.3)
   (z1 :accessor ig-z1 :initarg :z1 :initform nil)
   (z2 :accessor ig-z2 :initarg :z2 :initform nil)
   (K :accessor ig-K   :initarg :K  :initform nil)
   (Il :accessor ig-Il :initarg :Il :initform nil)
   (gamma :accessor ig-gamma )
   (name :accessor name :initarg :name :initform nil)))

(defclass ig-list ()    ;класс список ИГЭ
  ((dH :accessor ig-list  :initarg :dH  :initform nil)))

(defclass dlina-svayi ()   ;класс длина сваи
  ((L :accessor dlina-L  :initarg :L :initform 0)
   (L0 :accessor dlina-L0 :initarg :L0 :initform 0)))

(defclass svaya (dlina-svayi)    ;класс свая  (совокупность всех свай данной длины)
  ((E :accessor svaya-E :initarg :E :initform 3e6)
   (A :accessor svaya-A :initarg :A)
   (kv :accessor svaya-kv :initarg :kv)
   (G1 :accessor svaya-G1 :initarg :G1)
   (G2 :accessor svaya-G2 :initarg :G2)
   (c :accessor svaya-c   :initarg :c)
   (b :accessor svaya-b :initarg :b :initform 0.35)
   (d :accessor svaya-d :initarg :d :initform 0.5)
   (Lr :accessor svaya-Lr :initarg :Lr)
   (bp :accessor svaya-bp :initarg :bp :initform 1.025)
   (list-xy-s :accessor svaya-list-xy-s :initarg :list-xy-s :initform (list ))))


(defmethod z ((obj ig-list))  ;назначает координаты свойствам z1 и z2 обьектам класса ig
  (let (hh zz)
    (setq hh 0)
    (dolist (x (ig-list obj))
      (progn
        (setf (ig-z1 x) hh
              zz (ocrugl-1.000 (+ (ig-H x) (ig-z1 x)))
              (ig-z2 x) zz
              hh zz)))))

(defmethod z-print ((obj ig-list))  ;тупо распечатывает эти свойства z1 и z2 обьектов класса ig
  (dolist (x (ig-list obj)) (print (list (ig-z1 x)(ig-z2 x)))))

(defmethod d ((obj svaya))  ;вычисляет диаметр (расчетный диаметр свай некруглого сечения)
  (let (A dd)
  (setf A (svaya-A obj)
        dd (sqrt (/ (* 4 A) 3.141592)))
  (values dd)))

(defmethod G1-mu1 ((obj1 svaya) (obj2 ig-list))  ;определяет параметры грунтового основания G1 и mu1
  (let (m-E m-mu L H E0 mu1 G1)
  (setf m-E 0 m-mu 0
        L (dlina-L obj1))
  (dolist (x (ig-list obj2))
    (progn
      (cond ((< (ig-z2 x) L)
	     (setf m-E (+ m-E (* (ig-H x) (ig-E x)))
		   m-mu (+ m-mu (* (ig-H x) (ig-mu x)))))
	    ((and (< (ig-z1 x) L)(> (ig-z2 x) L))
	     (progn 
	       (setf H (- L (ig-z1 x))) 
	       (setf m-E (+ m-E (* H (ig-E x)))
		     m-mu (+ m-mu (* H (ig-mu x)))))))))
  (setf E0 (/ m-E L)
        mu1 (/ m-mu L)
        G1 (/ E0 (* 2 (+ 1 mu1))))
  (values (list G1 mu1))))

(defun grunt-min-max-H (n1-min n2-min n1-max n2-max)
  (let (dh n-min n-max)
    (if (> n1-min n2-min) (setf n-min n1-min)(setf n-min n2-min))
    (if (< n1-max n2-max) (setf n-max n1-max)(setf n-max n2-max))
    (setf dh (- n-max n-min))
    (if (> dh 0) (values dh) (values 0))))

(defmethod G2-mu2 ((obj1 svaya) (obj2 ig-list)) ;определяет параметры грунтового основания G2 и mu2
  (let (m-E m-mu L L2 n1-min n2-min H E0 mu2 G2 n2-max n1-max)
  (setf m-E 0 m-mu 0
        L (dlina-L obj1) 
        L2 (+ (/ L 2) L))
  (dolist (x (ig-list obj2))
    (setf n1-min L 
          n2-min (ig-z1 x)
          n1-max L2
          n2-max (ig-z2 x)
          H (grunt-min-max-H n1-min n2-min n1-max n2-max)
          m-E (+ m-E (* H (ig-E x)))
          m-mu (+ m-mu (* H (ig-mu x)))))
  (setf E0 (/ m-E (/ L 2))
        mu2 (/ m-mu (/ L 2))
        G2 (/ E0 (* 2 (+ 1 mu2))))
  (values (list G2 mu2))))

(defmethod s ((obj1 svaya) (obj2 ig-list)) ;определяет коэффициет постели одиночной сваи - пружину под концом
  (let (d L E A list1 list2 G1 mu1 G2 mu2 mu kv kv1 b1 alfa1 ksi lambda1 b s vv)
  (setf d (d obj1)
        L (dlina-L obj1)
        E (svaya-E obj1)
        A (svaya-A obj1)
        list1 (G1-mu1 obj1 obj2)
        list2 (G2-mu2 obj1 obj2) ;;здесь вызов в метод в котором происходит ошибка, содержимое obj2 неверное
        G1 (first list1)
        (svaya-G1 obj1) G1
        mu1 (second list1)
        G2 (first list2)
        (svaya-G2 obj1) G2
        mu2 (second list2)
        mu (/ (+ mu1 mu2) 2)
        kv (+ (- 2.82 (* 3.78 mu)) (* 2.18 mu mu))
        (svaya-kv obj1) kv
        mu mu1
        kv1 (+ (- 2.82 (* 3.78 mu)) (* 2.18 mu mu)))
    (setf    b1 (* 0.17 (log (/ (* kv G1 L) (* G2 d)))))
    (setf    alfa1 (* 0.17 (log (/ (* kv1 L) d))))
    (setf    ksi  (/ (* E A)  (* G1 L L)))
    (setf    lambda1 (/ (* 2.12 (expt ksi 0.75) ) (+ 1 (* 2.12 (expt ksi 0.75)))))
    (setf    b (+ (/ b1 lambda1) (/ (- 1 (/ b1 alfa1)) ksi )))
     (setf   s (/ (* G1 L) b )
        (svaya-c obj1) s)
  (setf vv (/ (* G1 L) (* G2 d)))
  (if (and (> (/ L d) vv)(> vv 1))
      (progn (values s)(setf (svaya-c obj1) s)) 
      (progn 
		(print "условие l/d > G1*L/G2*d > 1 -- не соблюдается")
		(setf *grunt-string* (concatenate 'string *grunt-string* "условие l/d > G1*L/G2*d > 1 -- не соблюдается"))
		(values s)))))

(defmethod s-ad ((obj1 svaya) node-csv-file) ; (s-ad sv1 "c:/lisp/nodes.csv")
  (let (G1 G2 kv L c nodes-massive m-nodes m-v m-delta stroka m2-nodes smd a p delta delta-s x2 y2 x1 y1 c-sv )
    (setf  ; переменные, необходимые для вычисления именно этой полезной части (payload ,тело цикла для будущего макроса)
     G1 (svaya-G1 obj1)
     G2 (svaya-G2 obj1)
     kv (svaya-kv obj1)
     L (dlina-L obj1)
     c (svaya-c obj1)) 

    (setf 
     nodes-massive (nodes node-csv-file)
     m-nodes (list )
     m-v (list )
     m-delta (list ))
                               
    (dolist (x nodes-massive) 
      (setf stroka (split ";" (filter x))
	    m-nodes (append m-nodes (list stroka)))) ;рубим nodes-massive ";" и оформляем ввиде m-nodes
    (setf m2-nodes m-nodes) ;размножаем массив m-nodes на m2-nodes, чтобы организовать цикл в цикле
    
    (dolist (x m-nodes)
      (progn
	(setf number1 (first x)  ;первый цикл пошел и number1 - номер узла 
	      x1 (parse-float (second x)) ;соответственно координаты х
	      y1 (parse-float (third x)) ) ; и y
	(dolist (j m2-nodes)    ; второй цикл пошел
	  (progn
	    (setf number2 (first j) ; number2  -- номер узла во втором цикле
		  x2 (parse-float (second j)) ;соответственно координаты х
		  y2 (parse-float (third j))
		  a (expt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2)) 0.5)) ; и y
	    (if (= a 0.0)() ; если два узла совпадают по вертикали или одинаковы, то ничего не происходит 
					; иначе выполняется тело цикла
					;------------------------------------------------------
		(progn 
		  ;;(break "3 a = ~a G2 = ~a x2=~a x1=~a y2=~a y1=~a" a G2 x2 x1 y2 y1)
		  (setf p (/ (* L kv G1) (* 2 G2 a)))
		  (cond ((> p 1)(setf delta (* 0.17 (log p))))
			((>= 1 p)(setf delta 0)))
		  (setf m-delta (append m-delta (list delta)))))))
	;;---------------------------------------------------------
	;; когда обсчитали все узлы во втором цикле
	;; можно просуммировать m-delta
	
	(setf smd (summa-number-list m-delta))
	;;вычислить жесткость в точке
	(cond ((equal smd 0)(setf c-sv c))
	      ((> smd 0)(setf
			 delta-s (/ (* G1 L) smd)
			 c-sv (/ 1 (+ (/ 1 c)(/ 1 delta-s))))))
	(setf 
	 ;;обнулить m-delta
	 m-delta (list )
	 ;;вывести в общий массив результатов
	 m-v (append m-v (list (append x (list  (ocrugl-100 c-sv))))))))
    (values m-v))) ;вывод массива результатов

(defun plot (massive-svaya out-svg title) ;(plot (kam) "c:/lisp/grunt/svaya-c.svg" "svaya-c")
  (let (C C-V DX DY MN MN-X MN-Y N-LIST PX PY V X X-C X-M X-MAX X-MIN Y Y-C Y-M Y-MAX Y-MIN YC)
  (let (m)
     ;;на этом участке перебиваем строки массива в числа
    (dolist (x massive-svaya)
      (setf n (first x)
	    x-c (parse-float (second x));координата Х
	    y-c (parse-float (third x));координата Y
	    c-v (fifth x);вычисленная жесткость
	    n-list (list x-c y-c c-v)
	    m (append m (list n-list))
	    x-m (append x-m (list x-c));массив координат Х (для мин макс)
	    y-m (append y-m (list y-c))));массив координат Y (для мин макс)
    (setf massive-svaya m))
  
  (multiple-value-setq (x-min x-max) (min-max-list* x-m));выбираются мин макc
  (multiple-value-setq (y-min y-max) (min-max-list* y-m));для Y
  (setf dx (- x-max x-min)
        dy (- y-max y-min);габариты изображения
        yc (/ (- y-max y-min) 2 );центр тяжести по Y вычисляется
        xc (/ (- x-max x-min) 2 ))
  (cond ((= dx 0)(setf dx 20))
	((= dy 0)(setf dy 20)))
;затем пересчитываются координаты, приводятся к координатам изображения
  (let (m)
    (dolist (n massive-svaya)
      (progn
        (setf x (first n) y (second n) c-v (third n)
              x (-  x x-min );начало координат изображения приводится к левому нижнему углу этого изображения
              y (-  (yc-trans y yc) y-min );а игреки еще и зеркалятся (игрек svg направлен вниз)
              v (list x y c-v)
              m (append m (list v)))))
    (setf massive-svaya m))
  ;непосредственно вывод изображения
  (setf mn-x (/ 1024 dx)
        mn-y (/ 768 dy)); mn-x mn-y - множитили приведения координат к размеру изображения
  (if (> mn-x mn-y)(setq mn mn-y)(setq mn mn-x));затем выбираем единый множитель для габаритов изображения (тот который меньше)
  (setf px (/ (- 1024 (* dx mn 0.909)) 2)
        py (/ (- 768 (* dy mn 0.909)) 2)); поправка на поля
  (setf mn (/ mn 1.1));уменьшаем единый множитель, чтоб были "поля"
  (let ((scene (make-svg-toplevel 'svg-1.1-toplevel :height 768 :width  1024)))
    (title scene title)
    (draw scene (:rect :x 0 :y 0 :height 768 :width 1024)
          :stroke "blue" :stroke-width 1 :fill "rgb(255, 255, 255)")
    (dolist (n massive-svaya) 
      (progn
        (setf x (first n) y (second n) C (third n))
        (text scene (:x (+ (* x mn) px) :y (+ (* y mn) py))
          (tspan (:fill "red" :font-weight "bold" :font-size 12) (write-to-string  C))))
      (with-open-file (s (pathname out-svg) :direction :output :if-exists :supersede)
          (stream-out s scene))))))
