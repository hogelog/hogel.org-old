#!/usr/bin/env gosh
(use c-wrapper)
(c-load '("SDL.h" "SDL_image.h""sdl_helper.c")
	:cppflags-cmd "sdl-config --cflags"
	:libs "-lSDL -lSDL_image"
	:import `(,(lambda (header sym)
                        (#/\/SDL\/.*\.h$/ header))
		  run_sdl_main
		  NULL)
        :compiled-lib "sdllib")

(define (make-rect x y w h)
  (let ((rect (make <SDL_Rect>)))
    (set! (ref rect 'x) x)
    (set! (ref rect 'y) y)
    (set! (ref rect 'w) w)
    (set! (ref rect 'h) h)
    rect))

(define (wait-event)
  (define event (make <SDL_Event>))
  (define (run-event quit)
    (let ((sym (ref* event 'key 'keysym 'sym)))
      (cond
       ((or (= sym SDLK_ESCAPE) (= sym SDLK_q)) (quit #t))
       (else #t))))
  (call/cc
   (lambda (quit)
     (let poll-event ()
       (SDL_Delay 100)
       (if (and (> (SDL_PollEvent (ptr event)) 0)
		(= SDL_KEYDOWN (ref event 'type)))
	   (run-event quit))
       (poll-event)))))

(define (show-image image-path)
  (and-let*
   ((image (IMG_Load image-path))
    (width (ref image 'w))
    (height (ref image 'h)))
   (SDL_Init SDL_INIT_VIDEO)
   (and-let* ((screen (SDL_SetVideoMode width height 16 SDL_HWSURFACE)))
	     (SDL_BlitSurface image NULL screen (ptr (make-rect 0 0 0 0)))
	     (SDL_Flip screen))
   (wait-event)
   (SDL_Quit)))

(define (sdl-main argc argv)
  (if (>= argc 2)
      (show-image (ref argv 1)))
  0)

(define (main args)
  (run_sdl_main (length args) args sdl-main))

; (main '("spres.scm" "hoge.png"))
