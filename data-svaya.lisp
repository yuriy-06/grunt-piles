(in-package :grunt-piles)

(defun 3915-10 (&key nodes-file limit-r)  ;  (3915-10 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 5.7)
  (let (grunts sv1 odin-j  m-alfa-i m-z m-c)
  ;задаем характеристики грунтов
  (setf 
   grunts
   ;ГРУНТЫ !!!
   ;задаем список порядка расположения грунтов и сами грунты
   ;сверху вниз от верха сваи
   ;общая Н должна быть 1,5 длины сваи (есть проверка)
   (make-instance 'ig-list 
                  :dH (list (make-instance 'ig :H 5 :E 660 :mu 0.37 :K 1800)      ;ИГЭ 1
                            (make-instance 'ig :H 3.7 :E 600 :mu 0.37 :K 1576)    ;ИГЭ 2а
                            (make-instance 'ig :H 5.4 :E 1200 :mu 0.31 :K 1800)   ;ИГЭ 3
                            (make-instance 'ig :H 15 :E 2450 :mu 0.3 :K 1800))))  ;ИГЭ 4
   ;НИЖЕ ЗАДАЮТСЯ ПАРАМЕТРЫ СВАИ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  (setf sv1 (make-instance 'svaya :L 15 :A 0.1225 :E 3e6))
  ;-------------------------------------------------------------------------------------
  (proverka-h-grunts sv1 grunts)
  (z grunts)  ; расчитываются координаты z грунтов  
  (setf odin-j (s sv1 grunts))  ;вычисляется жесткость под концом одиночной сваи
  (setf m-c (s-ad sv1 nodes-file)) ;вычисляется и затем выводится список жесткостей с координатами свай, с учетом взаимного влияния
  (plot m-c "c:/lisp/grunt/svaya-c.svg" "svaya-c")  ;данные (список жесткостей) выводятся в картинку
  ;ЗДЕСЬ ЗАДАЕТСЯ ТИП СВАИ!!!!!!!
  (Lr grunts sv1 "S0") ;вычисляем расчетную длину сваи
  (setf m-alfa-i (alfa-c sv1 :node-csv-file nodes-file :gamma-c 1.2 :limit-r limit-r)) ;вычисляются коэффициенты по боковой поверхности свай
  (plot m-alfa-i "c:/lisp/grunt/svaya-alfa-c.svg" "alfa_i")  ; а затем тоже выводятся в картинку
  (let ((m-ig (list )))
    (setf m-ig (layer-small sv1 grunts)
          m-z (layer-z-list m-ig))

    (lira (point-init m-ig m-c m-alfa-i sv1 m-z) sv1 "S0")
    (print "расчетная длина сваи") 
    (print (svaya-Lr sv1)) 
    (print "жесткость под концом одиночной сваи" )
    (print odin-j)
    )))

(defmacro data-svaya (&key poz-func-name ig-grunt-list svaya tip-sv gamma-c-bok)
  `(defun ,poz-func-name (&key nodes-file limit-r)  ;  (3915-10 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 5.7)
     (let (grunts sv1 m-alfa-i )
     (setf grunts  ,ig-grunt-list )  
     (setf sv1 ,svaya)
  ;-------------------------------------------------------------------------------------
     (proverka-h-grunts sv1 grunts)
     (z grunts) 
     (setf odin-j (s sv1 grunts) 
           m-c (s-ad sv1 nodes-file)) 
     (plot m-c "c:/lisp/grunt/svaya-c.svg" "svaya-c")
     (Lr grunts sv1 ,tip-sv) 
     (setf m-alfa-i (alfa-c sv1 :node-csv-file nodes-file :gamma-c ,gamma-c-bok :limit-r limit-r))
     (plot m-alfa-i "c:/lisp/grunt/svaya-alfa-c.svg" "alfa_i")  
     (let (m-ig m-z)
       (setf m-ig (layer-small sv1 grunts)
             m-z (layer-z-list m-ig))

       (lira (point-init m-ig m-c m-alfa-i sv1 m-z) sv1 ,tip-sv)
       (print "Расчетная длина сваи (м)") 
       (print (svaya-Lr sv1))
       (print "жесткость под концом одиночной сваи (тс/м)" )
       (print odin-j)))))

(defmacro data-svaya-web (&key poz-func-name ig-grunt-list svaya tip-sv gamma-c-bok directory)
  `(defun ,poz-func-name (&key nodes-file limit-r)  ;  (3915-10 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 5.7)
     (let (grunts sv1 m-alfa-i odin-j m-c)
     (setf grunts  ,ig-grunt-list )  
     (setf sv1 ,svaya)
  ;-------------------------------------------------------------------------------------
     (proverka-h-grunts sv1 grunts)
     (z grunts) 
     (setf odin-j (s sv1 grunts) 
           m-c (s-ad sv1 nodes-file)) 
     (plot m-c (concatenate 'string ,directory "svaya-c.svg") "svaya-c")
     (Lr grunts sv1 ,tip-sv) 
     (setf m-alfa-i (alfa-c sv1 :node-csv-file nodes-file :gamma-c ,gamma-c-bok :limit-r limit-r))
     (plot m-alfa-i  (concatenate 'string ,directory "svaya-alfa-c.svg") "alfa_i")  
     (let (m-ig m-z)
       (setf m-ig (layer-small sv1 grunts)
             m-z (layer-z-list m-ig))

       (lira-web (point-init m-ig m-c m-alfa-i sv1 m-z) sv1 ,tip-sv ,directory)  
       (print "Расчетная длина сваи (м)") 
       (print (svaya-Lr sv1))
       (print "жесткость под концом одиночной сваи (тс/м)" )
       (print odin-j)))))

(defun inet-svaya (&key grunt-list L A E b gamma-c-bok limit-r file-upload directory section)
  (data-svaya-web  ;; создали функцию  inet-svaya*
   :poz-func-name inet-svaya*
   :directory directory
   :ig-grunt-list (make-instance 'ig-list :dH grunt-list)		  
   :svaya (make-instance
	   'svaya
	   :L L
	   :A A
	   :E E
	   :b b)
   ;; для круглых свай сейчас обязательно диаметр задавать
   :tip-sv section  ;; т.е. свая всегда круглая?
   :gamma-c-bok gamma-c-bok );; для забивных свай сплошного сечения
  (inet-svaya* :nodes-file file-upload :limit-r limit-r)
  ;;(handler-case (inet-svaya* :nodes-file file :limit-r limit-r)
    ;;(sb-int:simple-file-error () 
      ;;(inet-svaya* :nodes-file "~/lisp/grunt/nodes.csv" :limit-r limit-r)))
  )
