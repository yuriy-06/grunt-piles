;;examples of usage
(data-svaya
 :poz-func-name 3915-1-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 5.8 :E 660 :mu 0.37 :K 1800)     ;ИГЭ  1
                                         (make-instance 'ig :H 1.4 :E 890 :mu 0.37 :K 1576)     ;ИГЭ  2
                                         (make-instance 'ig :H 3.8 :E 600 :mu 0.37 :K 1200)     ;ИГЭ  2a
                                         (make-instance 'ig :H 6.2  :E 1200 :mu 0.31 :K 1800)   ;ИГЭ  3
                                         (make-instance 'ig :H 8.6 :E 2450 :mu 0.3 :K 1800)))   ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
 ;(3915-1-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 1.5)
 (data-svaya
 :poz-func-name 3915-5-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 3.25 :E 660 :mu 0.37 :K 1800)     ;ИГЭ  1
                                         (make-instance 'ig :H 3.8 :E 890 :mu 0.37 :K 1576)     ;ИГЭ  2
                                         (make-instance 'ig :H 2.6 :E 600 :mu 0.37 :K 1200)     ;ИГЭ  2a
                                         (make-instance 'ig :H 1.9  :E 1200 :mu 0.31 :K 1800)   ;ИГЭ  3
                                         (make-instance 'ig :H 20 :E 2450 :mu 0.3 :K 1800)))   ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
;(3915-5-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 1.5)

(data-svaya
 :poz-func-name 3915-23-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 1.8 :E 660 :mu 0.37 :K 1800)    ;ИГЭ  1
                                         (make-instance 'ig :H 5.3 :E 890 :mu 0.37 :K 1576)     ;ИГЭ  2
                                         (make-instance 'ig :H 5.8  :E 1200 :mu 0.31 :K 1800)   ;ИГЭ  3
                                         (make-instance 'ig :H 15 :E 2450 :mu 0.3 :K 1800)))    ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
;(3915-23-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 3)

(data-svaya
 :poz-func-name 3915-10-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 5 :E 660 :mu 0.37 :K 1800)    ;ИГЭ  1
                                         (make-instance 'ig :H 3.7 :E 600 :mu 0.37 :K 1200)     ;ИГЭ  2a
                                         (make-instance 'ig :H 5.4  :E 1200 :mu 0.31 :K 1800)   ;ИГЭ  3
                                         (make-instance 'ig :H 15 :E 2450 :mu 0.3 :K 1800)))    ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
;(3915-10-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2)
(data-svaya
 :poz-func-name 3915-25
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 4.61 :E 660 :mu 0.37 :K 1800)    ;ИГЭ  1
                                         (make-instance 'ig :H 3.1 :E 890 :mu 0.37 :K 1576)     ;ИГЭ  2
                                         (make-instance 'ig :H 6.31  :E 1200 :mu 0.31 :K 1800)  ;ИГЭ  3
                                         (make-instance 'ig :H 15 :E 2450 :mu 0.3 :K 1800)))    ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15.2 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
;(3915-25 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 1.1)
(data-svaya
 :poz-func-name 3915-2-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 5.05 :E 660 :mu 0.37 :K 1800)     ;ИГЭ  1
                                         (make-instance 'ig :H 2.6 :E 890 :mu 0.37 :K 1576)      ;ИГЭ  2
                                         (make-instance 'ig :H 2.75 :E 600 :mu 0.37 :K 1200)     ;ИГЭ  2a
                                         (make-instance 'ig :H 25  :E 1200 :mu 0.31 :K 1800)    ;ИГЭ  3
                                         ))   ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
;(3915-2-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2.11)

(data-svaya
 :poz-func-name 3915-70-16m
 :ig-grunt-list (make-instance 'ig-list 
                               :dH (list (make-instance 'ig :H 2.65 :E 660 :mu 0.37 :K 1800)    ;ИГЭ  1
                                         (make-instance 'ig :H 4.3 :E 600 :mu 0.37 :K 1200)     ;ИГЭ  2a
                                         (make-instance 'ig :H 5.8  :E 1200 :mu 0.31 :K 1800)   ;ИГЭ  3
                                         (make-instance 'ig :H 15 :E 2450 :mu 0.3 :K 1800)))    ;ИГЭ  4
 :svaya (make-instance 'svaya :L 15 :A 0.1225 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2
 )
					;(3915-70-16m :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 5.1)
(data-svaya
 :poz-func-name yah-11-skv
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 3 :E 2500 :mu 0.35 :K 1728) ;;ИГЭ  302 полутвердый суглинок ≈ (тс/м2)   (тс/м4)
					 ))
 :svaya (make-instance 'svaya :L 15.5 :A 0.15 :E 3e6)
 :tip-sv "S0"
 :gamma-c-bok 1.2 ;; дл¤ забивных свай сплошного сечени¤
 )
					;(yah-11-skv :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 3)
(data-svaya
 :poz-func-name portovaya-9-500
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 15 :E 2910 :mu 0.25 :K 1800) ;;ИГЭ  2 глина ≈ (тс/м2)   (тс/м4)
					 ))
 :svaya (make-instance 'svaya :L 9 :A 0.159 :E 3e6)
 :tip-sv "S6"
 :gamma-c-bok 1.2 ;; дл¤ забивных свай сплошного сечени¤
 )
 ;(portovaya-9-500 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2.5)
 
 
 (data-svaya
 :poz-func-name portovaya-8-300
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 15 :E 2910 :mu 0.25 :K 1800) ;;ИГЭ  2 глина ≈ (тс/м2)   (тс/м4)
					 ))
 :svaya (make-instance 'svaya :L 8 :A 0.0707 :E 3e6 :d 0.3)  ;; дл¤ круглых свай сейчас об¤зательно диаметр задавать
 :tip-sv "S6"
 :gamma-c-bok 1
 )
;;(portovaya-8-300 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2.5)

(data-svaya
 :poz-func-name hram
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 4 :E 3000 :mu 0.27 :K 5000 ) ;;щебенистый грунт 1
;;;скальный грунт, под концом сваи св¤зь по z, ≈ не вли¤ет на расчет к-тов постели по боковой поверхности        
					 (make-instance 'ig :H 4.2 :E 3000 :mu 0.27 :K 5000 ) ;; дресв¤ной грунт 2
					 (make-instance 'ig :H 4.2 :E 500000 :mu 0.25 :K 5000 ) ;;известн¤к        3
					 (make-instance 'ig :H 1.7 :E 3000 :mu 0.35 :K 700 )  ;;песок пылеватый плотный  4
					 (make-instance 'ig :H 6.5 :E 3000 :mu 0.37 :K 1760 ) ;;√лина полутверда¤        5
					 (make-instance 'ig :H 5 :E 3000 :mu 0.35 :K 700 )    ;;песок пылеватый плотный  6
					 ))
 :svaya (make-instance 'svaya :L 10 :A 0.1256 :E 3e6 :d 0.4) ;; выводить тип сваи в отчет
 :tip-sv "S6"
 :gamma-c-bok 1.2
 )
 ;; (hram :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 5.7 )				 

 (data-svaya ;; буроинъекционные длиной 24м
 :poz-func-name taman-skv12
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 5 :E 1350 :mu 0.25 :K 1760) ;;ИГЭ  2 глина полутверда¤ ≈ (тс/м2)   (тс/м4)
					 (make-instance 'ig :H 3.8 :E 1880 :mu 0.38 :K 1680);; ИГЭ  3 глина полутверда¤, слабонабухающа¤
					 (make-instance 'ig :H 30 :E 2390 :mu 0.3 :K 1752);; ИГЭ  4 полутверда¤ слабо набухающа¤ 
					 ))
 :svaya (make-instance 'svaya :L 23 :A 0.0962 :E 1.95e6 :d 0.35)  ;; дл¤ круглых свай сейчас об¤зательно диаметр задавать
 :tip-sv "S6"
 :gamma-c-bok 1
 )

;;(taman-skv12 :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2)

 (data-svaya ;; забивные  длиной 12м (круглые металлические трубы)
 :poz-func-name taman-skv12-z
 :ig-grunt-list (make-instance 'ig-list
			       :dH (list (make-instance 'ig :H 5 :E 1350 :mu 0.25 :K 1760) ;;ИГЭ  2 глина полутверда¤ ≈ (тс/м2)   (тс/м4)
					 (make-instance 'ig :H 3.8 :E 1880 :mu 0.38 :K 1680);; ИГЭ  3 глина полутверда¤, слабонабухающа¤
					 (make-instance 'ig :H 30 :E 2390 :mu 0.3 :K 1752);; ИГЭ  4 полутверда¤ слабо набухающа¤ 
					 ))
 :svaya (make-instance 'svaya :L 11 :A 0.0962 :E 3e6 :d 0.35)  ;; дл¤ круглых свай сейчас об¤зательно диаметр задавать
 :tip-sv "S6"
 :gamma-c-bok 1 ;;забивна¤ сва¤ несплошного сечени¤
 )

;;(taman-skv12-z :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 2)
;; (taman-skv12-z :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 1.6)  -- после удвоени¤ р¤да свай
;; (taman-skv12-z :nodes-file "c:/lisp/grunt/nodes.csv" :limit-r 0.8) -- после переделки
