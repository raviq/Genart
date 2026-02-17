;;;; Drawing of repeated random walks using random colors for each walk.
;;;; Ooutputs a PNG file (via PPM intermediate).

;;;; No external CL libraries needed. Uses ImageMagick `convert` for PPM --> PNG.

(defpackage :artist
  (:use :cl))

(in-package :artist)

;;; ================= Parameters =================

(defparameter *width* 1000)
(defparameter *height* 1000)
(defparameter *steps* 5000)
(defparameter *max-distance* 5)
(defparameter *num-walks* 20)

;;; ================= framebuffer =================

(defparameter *pixels* nil
  "A (height x width x 3) array of bytes representing the image.")

(defun make-framebuffer ()
  "Create a black framebuffer."
  (make-array (list *height* *width* 3)
              :element-type '(unsigned-byte 8)
              :initial-element 0))

(defun set-pixel (x y r g b)
  "Set pixel at (x,y) with color (r,g,b). Origin is center of image."
  (let ((px (+ x (floor *width* 2)))
        (py (+ y (floor *height* 2))))
    (when (and (>= px 0) (< px *width*)
               (>= py 0) (< py *height*))
      (setf (aref *pixels* py px 0) r
            (aref *pixels* py px 1) g
            (aref *pixels* py px 2) b))))

(defun draw-line (x1 y1 x2 y2 r g b)
  "Draw a line using Bresenham's algorithm."
  (let* ((ix1 (round x1)) (iy1 (round y1))
         (ix2 (round x2)) (iy2 (round y2))
         (dx (abs (- ix2 ix1)))
         (dy (- (abs (- iy2 iy1))))
         (sx (if (< ix1 ix2) 1 -1))
         (sy (if (< iy1 iy2) 1 -1))
         (err (+ dx dy)))
    (loop
      (set-pixel ix1 iy1 r g b)
      (when (and (= ix1 ix2) (= iy1 iy2)) (return))
      (let ((e2 (* 2 err)))
        (when (>= e2 dy)
          (incf err dy)
          (incf ix1 sx))
        (when (<= e2 dx)
          (incf err dx)
          (incf iy1 sy))))))

;;; ================= turtle state =================

(defstruct turtle
  (x 0.0d0 :type double-float)
  (y 0.0d0 :type double-float)
  (heading 0.0d0 :type double-float))  ; degrees, 0 = up (north)

;;; ================= utilities =================

(defun deg->rad (deg)
  (* deg (/ pi 180.0d0)))

(defun random-range (lo hi)
  "Return a random double-float in [lo, hi)."
  (+ lo (* (- hi lo) (random 1.0d0))))

;;; ================= core drawing logic =================

(defun random-move (turtle)
  "Turn turtle through a random angle, move forward, and draw the line."
  (let* ((angle (random-range -90.0d0 90.0d0))
         (d     (random-range 0.0d0 (coerce *max-distance* 'double-float)))
         (new-heading (+ (turtle-heading turtle) angle))
         (rad   (deg->rad new-heading))
         (dx    (* d (sin rad)))
         (dy    (- (* d (cos rad))))  ; negate: y increases downward in image
         (x1    (turtle-x turtle))
         (y1    (turtle-y turtle))
         (x2    (+ x1 dx))
         (y2    (+ y1 dy))
         (r (random 256)) (g (random 256)) (b (random 256)))
    (draw-line x1 y1 x2 y2 r g b)
    (make-turtle :x x2 :y y2 :heading new-heading)))

(defun random-walk (turtle steps)
  "Perform a random walk of STEPS moves, drawing directly to the framebuffer."
  (loop :with current = turtle
        :repeat steps
        :do (setf current (random-move current))))

;;; ================= PPM output =================

(defun write-ppm (filename)
  "Write the framebuffer as a binary PPM (P6) file."
  (with-open-file (out filename :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create
                                :element-type '(unsigned-byte 8))
    ;; Write header as bytes
    (let ((header (format nil "P6~%~D ~D~%255~%" *width* *height*)))
      (loop :for ch :across header
            :do (write-byte (char-code ch) out)))
    ;; Write pixel data
    (dotimes (y *height*)
      (dotimes (x *width*)
        (write-byte (aref *pixels* y x 0) out)
        (write-byte (aref *pixels* y x 1) out)
        (write-byte (aref *pixels* y x 2) out)))))

;;; ================= main part =================

(defun main (&optional (num-walks *num-walks*) (output-file "artist.png"))
  (setf *pixels* (make-framebuffer))
  ;; Red dot at center
  (set-pixel 0 0 255 0 0)
  (set-pixel 1 0 255 0 0)
  (set-pixel 0 1 255 0 0)
  (set-pixel -1 0 255 0 0)
  (set-pixel 0 -1 255 0 0)

  (format t "Drawing ~D random walks of ~D steps each on ~Dx~D canvas...~%"
          num-walks *steps* *width* *height*)
  (dotimes (i num-walks)
    (format t "  Walk ~D/~D~%" (1+ i) num-walks)
    (let ((home (make-turtle :x 0.0d0 :y 0.0d0 :heading 0.0d0)))
      (random-walk home *steps*)))

  ;; Write PPM, then convert to PNG if possible
  (let ((ppm-file "artist.ppm"))
    (write-ppm ppm-file)
    (format t "Written ~A~%" ppm-file)
    ;; Try converting to PNG via ImageMagick or GraphicsMagick
    (let ((process (sb-ext:run-program "convert"
                                        (list ppm-file output-file)
                                        :search t
                                        :wait t)))
      (if (zerop (sb-ext:process-exit-code process))
          (progn
            (delete-file ppm-file)
            (format t "Done. Output written to ~A~%" output-file))
          ;; Fallback: keep PPM
          (format t "ImageMagick not found. Output written to ~A (open with GIMP/IrfanView)~%"
                  ppm-file)))))

;; finally, run
(main 20 "artist.png")
