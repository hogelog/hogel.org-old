#include <X11/Xlib.h>
#include <SDL/SDL.h>
#include <SDL/SDL_ttf.h>

Display *DEFAULT_DISPLAY;

#define DEFAULT_SCREEN DefaultScreen(DEFAULT_DISPLAY)

const SDL_Color COLOR_WHITE = {-1, -1, -1, 0};
const SDL_Color COLOR_BLACK = {0, 0, 0, 0};

#define FONT_SIZE_LOW 0
#define FONT_SIZE_UPP \
  (DisplayHeight(DEFAULT_DISPLAY, DEFAULT_SCREEN) + \
   DisplayHeightMM(DEFAULT_DISPLAY, DEFAULT_SCREEN) * 5 / 254.0)

#define FONT_PATH "font.ttf"

#define UNIT 5
#define ABOUT_EQ(a,b) \
  ((a) <= b+UNIT && (a) >= (b)-UNIT)

/* 二分探索で適切なサイズを探す */
TTF_Font *OpenFitFont(const char *text) {
  int screen_w = DisplayWidth(DEFAULT_DISPLAY, DEFAULT_SCREEN);
  int screen_h = DisplayHeight(DEFAULT_DISPLAY, DEFAULT_SCREEN);
  int text_w, text_h;
  TTF_Font *font;
  int low = FONT_SIZE_LOW, upp = FONT_SIZE_UPP;
  int mid;
  while(1) {
    mid = (low + upp) / 2;
    printf("%d\n", mid);
    font = TTF_OpenFont(FONT_PATH, mid);
    TTF_SizeUTF8(font, text, &text_w, &text_h);
    if((ABOUT_EQ(text_w, screen_w) && text_h < screen_h) ||
        (ABOUT_EQ(text_h, screen_h) && text_w < screen_w)) {
      return font;
    }

    if(text_w >= screen_w || text_h >= screen_h) {
      upp = mid;
    }
    else {
      low = mid;
    }
  }

  return font;
}
void printText(SDL_Surface *screen, TTF_Font *font, char *text) {
  SDL_Rect zero = {0, 0, 0, 0};
  SDL_Rect bgrect = {0, 0, screen->w, screen->h};

  SDL_Surface *line = TTF_RenderUTF8(font, text, COLOR_BLACK, COLOR_WHITE);

  SDL_FillRect(screen, &bgrect, -1);
  SDL_UpdateRect(screen, 0, 0, screen->w, screen->h);
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
  DEFAULT_DISPLAY = XOpenDisplay(NULL);
  if(DEFAULT_DISPLAY==NULL) {
    return -1;
  }
  SDL_Init(SDL_INIT_VIDEO);
  TTF_Init();
  TTF_Font *font = OpenFitFont(text);
  // TTF_Font *font = TTF_OpenFont(FONT_PATH, FONT_SIZE());
  SDL_Surface *screen;
  if(font == NULL) { 
    printf("cannot open %s\n", FONT_PATH);
    return -1;
  }
  screen = SDL_SetVideoMode(DisplayWidth(DEFAULT_DISPLAY, DEFAULT_SCREEN),
      DisplayHeight(DEFAULT_DISPLAY, DEFAULT_SCREEN), 16, SDL_HWSURFACE);
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
