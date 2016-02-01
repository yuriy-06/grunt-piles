(in-package :grunt-piles)

(defun test-layer ()  ;(test-layer)
  (let (ige1 ige2 grunts sv1 m)
    (setf 
     ige1 (make-instance 'ig :H 2.45 :E 940 :mu 0.37) ;задаем характеристики грунтов
     ige2 (make-instance 'ig :H 12.05 :E 860 :mu 0.37)   ;
     grunts (make-instance 'ig-list :dH (list ige1 ige2)))  ;задаем список порядка расположения грунтов
    (z grunts) ; расчитываются координаты z грунтов
    (setf sv1 (make-instance 'svaya :L 9 :A 0.1225 :E 3e6)) ;задаются параметры сваи
    (setf m (layer-z ige1 sv1 (list )))
    (dolist (x m) (progn 
		    (print "ig")
		    (print "H")
		    (print (ig-H x))
		    (print "z1")
		    (print (ig-z1 x))
		    (print "z2")
		    (print (ig-z2 x)))))) 
  
(defun h (z1 z2)
  (let (hh)
    (if (<= (+ z1 1) z2) (setf hh 1))
    (if (> (+ z1 1) z2) (setf hh (- z2 z1)))
    (values hh)))

(defmacro layer-z-creater (method parameter block step block0)
  `(defmethod ,method ,parameter ; в этом методе создается список объектов класса ig
; грунт режется на маленькие слои с толщиной не более 1 м, высчитываются их координаты, дублируются свойства крупных слоев
     (let  (L z1 z2 E mu Il K  m-ig name)
       ,block0
       (setf z1 (ig-z1 obj1)   
	     z2 (ig-z2 obj1)
	     E (ig-E obj1)
	     mu (ig-mu obj1)
	     Il (ig-Il obj1)
	     K (ig-K obj1)
	     name (name obj1))  
       ;;(if (> z1 0) (setf z-min z1)(setf z-min 0))
       ,block       
       (loop 
	  (if (>= z1 z2) (return))
	  (setf m-ig (append m-ig (list (make-instance 'ig :H (h z1 z2)
						       :name name :E E :mu mu :Il Il :K K :Z1 z1 :z2 (+ z1 (h z1 z2))))))
	  (setf z1 (+ z1 ,step)))       
       (values m-ig))))

(layer-z-creater layer-z ((obj1 ig) (obj2 svaya) m-ig)  (if (< z2 L) ()(setf z2 L)) 1 (setf L (dlina-L obj2)))

(defmethod layer-z-list (m-ig)
  (let ((m-z (list 0)) (z 0))
    (dolist (x m-ig) (setf z (ig-z2 x)
                           m-z (append m-z (list z))))
    (values m-z)))

(defmacro layer-method-small-creater (name-method parameter layer)  ;;  ((obj1 svaya) (obj2 ig-list))
  `(defmethod ,name-method ,parameter ; дробит список ИГЭ на слои поменьше (через layer-z), автоматизирует ввод
     (let (m-ig)
       (dolist (x (ig-list obj2)) (setf m-ig (append m-ig ,layer)))
       (values m-ig))))

(layer-method-small-creater layer-small ((obj1 svaya) (obj2 ig-list)) (layer-z x obj1 m-ig))
