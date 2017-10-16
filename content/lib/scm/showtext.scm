#!/usr/bin/env gosh
(use c-wrapper)
;; cwcompile はここを読む
(c-load '("SDL.h" "SDL_ttf.h" "stdio.h" "stdlib.h" "sdl_helper.c")
        :cppflags-cmd "sdl-config --cflags"
        :libs-cmd "sdl-config --libs; echo '-lSDL_ttf'"
        :import (list (lambda (header sym)
                        (#/\/SDL\/.*\.h$/ header))
                      'NULL
                      'run_sdl_main)
        :compiled-lib "sdllib")

;; 適当に決め打ち
(define *screen-w* 600)
(define *screen-h* 480)
(define *font-path* "font.ttf") ; SDL_ttfはTTFフォント以外も開けたかも
(define *font-size* 100)

(define (make-rect x y w h)
  (let ((rect (make <SDL_Rect>)))
    (set! (ref rect 'x) x)
    (set! (ref rect 'y) y)
    (set! (ref rect 'w) w)
    (set! (ref rect 'h) h)
    rect))

(define (make-color r g b)
  (let ((color (make <SDL_Color>)))
    (set! (ref color 'r) r)
    (set! (ref color 'g) g)
    (set! (ref color 'b) b)
    color))

(define COLOR_BLACK (make-color 0 0 0))
(define COLOR_WHITE (make-color 255 255 255))

(define (wait-event)
  (define event (make <SDL_Event>))
  (define (run-event)
    (let ((sym (ref* event 'key 'keysym 'sym)))
      (cond
        ((or (= sym SDLK_ESCAPE) (= sym SDLK_q)) #t)
        (else #f))))
  (let poll-event ()
    (SDL_Delay 10)
    (if
      (and
        (> (SDL_PollEvent (ptr event)) 0)
        (= SDL_KEYDOWN (ref event 'type))
        (run-event))
      #t
      (poll-event))))

(define (make-printer font-path font-size)
  (let
    ((bgrect (make-rect 0 0 *screen-w* *screen-h*))
     (font (TTF_OpenFont font-path font-size)))
    (if (null-ptr? font) ; ちゃんとしたフォント開けてるかチェック
      ;; 開けてなかったらエラーメッセージ表示するクロージャを返す
      (lambda (text)
        (print (format "cannot open ~s" font-path)))
      ;; 開けてたらSDL画面を開く。
      ;; そして開いたフォントを使って画面にテキストを書きこみ、
      ;; イベント待ちループにはいるクロージャを返す
      (let
        ((screen (SDL_SetVideoMode *screen-w* *screen-h* 16 SDL_HWSURFACE)))
        (lambda (text)
          (let
            ((line (TTF_RenderUTF8 font text COLOR_BLACK COLOR_WHITE)))
            (SDL_FillRect screen (ptr bgrect) -1)
            (SDL_UpdateRect screen 0 0 *screen-w* *screen-h*)
            (SDL_BlitSurface line NULL screen (ptr (make-rect 0 0 0 0)))
            (SDL_Flip screen))
          (wait-event))))))

(define (show-text text)
  (SDL_Init SDL_INIT_VIDEO)
  (TTF_Init)
  ;; テキスト表示するクロージャを作成し、そのクロージャにtextを渡して実行
  (let ((printer (make-printer *font-path* *font-size*)))
    (printer text))
  (TTF_Quit)
  (SDL_Quit))

(define (sdl-main argc argv)
  ;; 1つ目の引数をshow-textに渡す
  (show-text (cast <string> (ref argv 1)))
  0)

(define (main args)
  ;; 引数があればrun_sdl_mainに渡す
  ;; run_sdl_mainはsdl_helperの方で定義したもの。内部でsdl-mainを呼ぶ
  (unless (null? (cdr args))
          (run_sdl_main (length args) args sdl-main)))

; (main '("spres.scm" "show text"))
