(in-package :asdf)

(defsystem :grunt-piles
  :name "grunt-piles"
  :author "Vdovik Yuriy <babah.yuriy06@gmail.com>"
  :version "0.02"
  :maintainer "Vdovik Yuriy <babah.yuriy06@gmail.com>"
  :licence "MIT License"
  :description "generation computer model of piles for lira-sapr program"
  :depends-on (:cl-ppcre :parse-float :cl-svg)

  :components ((:file "package")
				(:file "short-utils")
               (:file "obj-svaya")
               (:file "ig-layer")
               (:file "alfa-c")
               (:file "point-last")
               (:file "data-svaya")
			   )
  :serial t)
  
