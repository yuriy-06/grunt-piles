(in-package :grunt-piles)

(defun filter (line)  ;функция заменяет символы из нижеследующего массива на разрешенный ";"
  (let ((list* (list "\\t+" "\\s+" "\\n+" ":" "," )))
    (dolist (x list*) 
      (setf line (regex-replace-all x line ";")))
    (setf line (regex-replace-all "-0.000" line "0.000")) ;заменяет глюк лиры "-0.000" на "0.000"
    (values line)))
	
(defmacro defun-file* (func-name  regex 'val) ;макрос генерирует функции обрабатывающие текстовые файлы (они идут как аргумент функции)
  `(defun ,func-name (file)       ;и возвращает массив строк , удовлетворяющих регулярному выражению
     (let (m v (schet 0) file*)
       ;;(declare (optimize (debug 3)))
       ;;(break)
       (setf file* (open file :if-does-not-exist nil :external-format :latin-1 ))
       (if (equal file* nil) (progn 
			       (format t "нет такого файла ~S" file) 
			       (return-from ,func-name)))
	(format t  "~%~a" "начался процесс импорта файла txt , функция --- ")
	(format t  "~a~%" (symbol-name ',func-name))
     (loop for line = (read-line file* nil)
           while line do  
           (progn (setf v (nth-value 0 (scan-to-strings ,regex (filter line))))
		  (if (equal v nil)() ( setf m (append m (list ,val)) ))
             (incf schet)))
     (close file*)
	 (format t  "~a~%" "закончился процесс импорта файла")
     (values m schet))))

(defmacro defun-file (func-name regex)
	`(defun-file* ,func-name ,regex 'v))

(defun-file nodes "\\d+;(-??\\d+\.{1}\\d+;){3}");(nodes "file")

(defmacro ocrugl-float (name-func number-float)
  `(defun ,name-func (x)
     (if (equal x nil) (values nil) (values (float (/ (round (* x ,number-float)) ,number-float))))))
(ocrugl-float ocrugl-1.00 100) ;создает функции округления (имя функции и еденицы после дроби)
(ocrugl-float ocrugl-1.000 1000)
(ocrugl-float ocrugl-1.00000 100000)

(defun ocrugl-100 (x)
  (values  (* (round (/ x 100)) 100)))

(defun min-max-list* (list);возвращает минимум и максимум из списка 
  (let ((n-max (first list)) (n-min (first list))) 
    (setq n-max 0)
    (dolist (x list)(progn (if (> x n-max) (setq n-max x))
                      (if (< x n-min)(setq n-min x))))
    (values n-min n-max)))
	
(defun min-max-list (list);возвращает минимум и максимум из списка
  (let ((n-max (first list)) (n-min (first list))) 
    (dolist (x list)(progn (if (> x n-max) (setq n-max x))
                      (if (< x n-min)(setq n-min x))))
    (values (list n-min n-max))))
					  
(defun pr-number-list (list-n)    ;(pr-number-list (list 1 1 2))   => 2
  (let ((pr 1))
    (dolist (x list-n) (setf pr (* pr x)))
    (values pr)))

(defun yc-trans (y yc)
  (let ((dy))
    (setq dy (- yc y))
    (values (+ yc dy))))
	
(defun summa-number-list (list-n)  ;(summa-number-list (list 0 1 2))   => 3
  (let ((summa 0))
    (dolist (x list-n) (setf summa (+ summa x)))
    (values summa)))