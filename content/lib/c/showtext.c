#include <SDL/SDL.h>
#include <SDL/SDL_ttf.h>

#define SCREEN_W 600
#define SCREEN_H 480
#define FONT_SIZE 100
#define FONT_PATH "font.ttf"

void printText(SDL_Surface *screen, TTF_Font *font, char *text) {
  SDL_Rect zero = {0, 0, 0, 0};
  SDL_Rect bgrect = {0, 0, SCREEN_W, SCREEN_H};
  SDL_Color white = {-1, -1, -1, 0};
  SDL_Color black = {0, 0, 0, 0};

  SDL_Surface *line = TTF_RenderUTF8(font, text, black, white);

  SDL_FillRect(screen, &bgrect, -1);
  SDL_UpdateRect(screen, 0, 0, SCREEN_W, SCREEN_H);
  SDL_BlitSurface(line, NULL, screen, &zero);
  SDL_Flip(screen);
}
int waitEvent() {
  SDL_Event event;
  while(1) {
    SDL_Delay(10);
    if(SDL_PollEvent(&event)==0) {
      continue;
    }
    else if(event.type != SDL_KEYDOWN) {
      continue;
    }
    switch(event.key.keysym.sym) {
      case SDLK_ESCAPE:
      case SDLK_q:
        puts("quit");
        return 0;
      default:
        break;
    }
  }
  return -1;
}
int showText(char *text) {
  SDL_Init(SDL_INIT_VIDEO);
  TTF_Init();
  TTF_Font *font = TTF_OpenFont(FONT_PATH, FONT_SIZE);
  SDL_Surface *screen;
  if(font == NULL) {
    printf("cannot open %s\n", FONT_PATH);
    return -1;
  }
  screen = SDL_SetVideoMode(SCREEN_W, SCREEN_H, 16, SDL_HWSURFACE);
  printText(screen, font, text);
  waitEvent();
  TTF_Quit();
  SDL_Quit();
  return 0;
}
int main(int argc, char *argv[]) {
  if(argc<2) {
    printf("%s text\n", argv[0]);
    return 0;
  }
  return showText(argv[1]);
}
