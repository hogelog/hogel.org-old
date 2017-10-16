/* 

Copyright 1985, 1986, 1987, 1991, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall not be
used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from The Open Group.

*/

public import Xlib_define;
extern (C):
alias uint size_t;

const int X_PROTOCOL = 11;
const int X_PROTOCOL_REVISION = 0;
alias uint XID;

alias uint Mask;

alias uint Atom;

alias uint VisualID;
alias uint Time;
alias XID Window;
alias XID Drawable;

alias XID Font;

alias XID Pixmap;
alias XID Cursor;
alias XID Colormap;
alias XID GContext;
alias XID KeySym;

alias ubyte KeyCode;

alias int Bool;
alias int Status;

alias int wchar_t;
extern int
_Xmblen(
    byte *str,
    int len
    );

alias byte *XPointer;

uint BlackPixel(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).black_pixel;
}

uint WhitePixel(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).white_pixel;
}

int ConnectionNumber(Display *display){
  return (*cast(_XPrivDisplay)display).fd;
}

Colormap DefaultColormap(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).cmap;
}

int DefaultDepth(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).root_depth;
}

GC DefaultGC(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).default_gc;
}

Window DefaultRootWindow(Display *display){
  return (*ScreenOfDisplay(display, DefaultScreen(display))).root;
}

Screen *DefaultScreenOfDisplay(Display *display){
  return ScreenOfDisplay(display, DefaultScreen(display));
}

int DefaultScreen(Display *display){
  return (*cast(_XPrivDisplay)display).default_screen;
}

Visual *DefaultVisual(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).root_visual;
}

int DisplayCells(Display *display, int screen_number){
  return (*DefaultVisual(display, screen_number)).map_entries;
}

int DisplayPlanes(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).root_depth;
}

byte *DisplayString(Display *display){
  return (*cast(_XPrivDisplay)display).display_name;
}
uint LastKnownRequestProcessed(Display *display){
  return (*cast(_XPrivDisplay)display).last_request_read;
}

uint NextRequest(Display *display){
  return (*cast(_XPrivDisplay)display).request + 1;
}

int ProtocolVersion(Display *display){
  return (*cast(_XPrivDisplay)display).proto_major_version;
}

int ProtocolRevision(Display *display){
  return (*cast(_XPrivDisplay)display).proto_minor_version;
}

int QLength(Display *display){
  return (*cast(_XPrivDisplay)display).qlen;
} 

Window RootWindow(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).root;
}

int ScreenCount(Display *display){
  return (*cast(_XPrivDisplay)display).nscreens;
}

Screen *ScreenOfDisplay(Display *display, int screen_number){
  return &(*cast(_XPrivDisplay)display).screens[screen_number];
}

byte *ServerVendor(Display *display){
  return (*cast(_XPrivDisplay)display).vendor;
}

int VendorRelease(Display *display){
  return (*cast(_XPrivDisplay)display).release;
}

int ImageByteOrder(Display *display){
  return (*cast(_XPrivDisplay)display).byte_order;
}

int BitmapBitOrder(Display *display){
  return (*cast(_XPrivDisplay)display).bitmap_bit_order;
}

int BitmapPad(Display *display){
  return (*cast(_XPrivDisplay)display).bitmap_pad;
}

int BitmapUnit(Display *display){
  return (*cast(_XPrivDisplay)display).bitmap_unit;
}

int DisplayHeight(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).height;
}

int DisplayHeightMM(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).mheight;
}

int DisplayWidth(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).width;
}

int DisplayWidthMM(Display *display, int screen_number){
  return (*ScreenOfDisplay(display, screen_number)).mwidth;
}

uint BlackPixelOfScreen(Screen *screen){
  return (*screen).black_pixel;
}

uint WhitePixelOfScreen(Screen *screen){
  return (*screen).white_pixel;
}

int CellsOfScreen(Screen *screen){
  return (*DefaultVisualOfScreen(screen)).map_entries;
}

Colormap DefaultColormapOfScreen(Screen *screen){
  return (*screen).cmap;
}

int DefaultDepthOfScreen(Screen *screen){
  return (*screen).root_depth;
}

GC DefaultGCOfScreen(Screen *screen){
  return (*screen).default_gc;
}

Visual *DefaultVisualOfScreen(Screen *screen){
  return (*screen).root_visual;
}

int DoesBackingStore(Screen *screen){
  return (*screen).backing_store;
}

Bool DoesSaveUnders(Screen *screen){
  return (*screen).save_unders;
}

Display *DisplayOfScreen(Screen *screen){
  return (*screen).display;
}long EventMaskOfScreen(Screen *screen){
  return (*screen).root_input_mask;
}

int HeightOfScreen(Screen *screen){
  return (*screen).height;
}

int HeightMMOfScreen(Screen *screen){
  return (*screen).mheight;
}

int MaxCmapsOfScreen(Screen *screen){
  return (*screen).max_maps;
}

int MinCmapsOfScreen(Screen *screen){
  return (*screen).min_maps;
}

int PlanesOfScreen(Screen *screen){
  return (*screen).root_depth;
}

Window RootWindowOfScreen(Screen *screen){
  return (*screen).root;
}

int WidthOfScreen(Screen *screen){
  return (*screen).width;
}

int WidthMMOfScreen(Screen *screen){
  return (*screen).mwidth;
}

XID XAllocID(Display* display){
  return (*((*cast(_XPrivDisplay)display).resource_alloc))(display);
}
struct XExtData {
  int number;
  _XExtData *next;
  int (*free_private)(
      _XExtData *extension
      );
  XPointer private_data;
}

struct XExtCodes{
  int extension;
  int major_opcode;
  int first_event;
  int first_error;
}
struct XPixmapFormatValues{
  int depth;
  int bits_per_pixel;
  int scanline_pad;
}
struct XGCValues{
  //int function;
  int Cfunction;
  uint plane_mask;
  uint foreground;
  uint background;
  int line_width;
  int line_style;
  int cap_style;

  int join_style;
  int fill_style;

  int fill_rule;
  int arc_mode;
  Pixmap tile;
  Pixmap stipple;
  int ts_x_origin;
  int ts_y_origin;
  Font font;
  int subwindow_mode;
  int graphics_exposures;
  int clip_x_origin;
  int clip_y_origin;
  Pixmap clip_mask;
  int dash_offset;
  byte dashes;
}
alias _XGC* GC;

extern struct _XGC;
extern struct _XExtData;
extern struct _XOM;
extern struct _XOC;
extern struct _XIM;
extern struct _XIC;

struct Visual{
  XExtData *ext_data;
  VisualID visualid;
  //int class;
  int Cclass;

  uint red_mask, green_mask, blue_mask;
  int bits_per_rgb;
  int map_entries;
}

struct Depth{
  int depth;
  int nvisuals;
  Visual *visuals;
}

struct _XDisplay;

struct Screen{
  XExtData *ext_data;
  _XDisplay *display;
  Window root;
  int width, height;
  int mwidth, mheight;
  int ndepths;
  Depth *depths;
  int root_depth;
  Visual *root_visual;
  GC default_gc;
  Colormap cmap;
  uint white_pixel;
  uint black_pixel;
  int max_maps, min_maps;
  int backing_store;
  int save_unders;
  int root_input_mask;
}

struct ScreenFormat{
  XExtData *ext_data;
  int depth;
  int bits_per_pixel;
  int scanline_pad;
}

struct XSetWindowAttributes{
  Pixmap background_pixmap;
  uint background_pixel;
  Pixmap border_pixmap;
  uint border_pixel;
  int bit_gravity;
  int win_gravity;
  int backing_store;
  uint backing_planes;
  uint backing_pixel;
  int save_under;
  int event_mask;
  int do_not_propagate_mask;
  int override_redirect;
  Colormap colormap;
  Cursor cursor;
}

struct XWindowAttributes{
  int x, y;
  int width, height;
  int border_width;
  int depth;
  Visual *visual;
  Window root;
  //int class;
  int Cclass;

  int bit_gravity;
  int win_gravity;
  int backing_store;
  uint backing_planes;
  uint backing_pixel;
  int save_under;
  Colormap colormap;
  int map_installed;
  int map_state;
  int all_event_masks;
  int your_event_mask;
  int do_not_propagate_mask;
  int override_redirect;
  Screen *screen;
}
struct XHostAddress{
  int family;
  int length;
  byte *address;
}

struct XServerInterpretedAddress{
  int typelength;
  int valuelength;
  byte *type;
  byte *value;
}

struct _XImage {
  int width, height;
  int xoffset;
  int format;
  byte *data;
  int byte_order;
  int bitmap_unit;
  int bitmap_bit_order;
  int bitmap_pad;
  int depth;
  int bytes_per_line;
  int bits_per_pixel;
  uint red_mask;
  uint green_mask;
  uint blue_mask;
  XPointer obdata;
  struct funcs {
    _XImage *(*create_image)(
        _XDisplay* ,
        Visual* ,
        uint ,
        int ,
        int ,
        byte* ,
        uint ,
        uint ,
        int ,
        int );
    int (*destroy_image) (_XImage *);
    uint (*get_pixel) (_XImage *, int, int);
    int (*put_pixel) (_XImage *, int, int, uint);
    _XImage *(*sub_image)(_XImage *, int, int, uint, uint);
    int (*add_pixel) (_XImage *, int);
  }
  funcs f;
}
alias _XImage XImage;

struct XWindowChanges{
  int x, y;
  int width, height;
  int border_width;
  Window sibling;
  int stack_mode;
}

struct XColor{
  uint pixel;
  ushort red, green, blue;
  byte flags;
  byte pad;
} ;
struct XSegment{
  short x1, y1, x2, y2;
} ;

struct XPoint{
  short x, y;
} ;

struct XRectangle{
  short x, y;
  ushort width, height;
} ;

struct XArc{
  short x, y;
  ushort width, height;
  short angle1, angle2;
} ;

struct XKeyboardControl{
  int key_click_percent;
  int bell_percent;
  int bell_pitch;
  int bell_duration;
  int led;
  int led_mode;
  int key;
  int auto_repeat_mode;
} ;
struct XKeyboardState{
  int key_click_percent;
  int bell_percent;
  uint bell_pitch, bell_duration;
  uint led_mask;
  int global_auto_repeat;
  byte auto_repeats[32];
} ;
struct XTimeCoord{
  Time time;
  short x, y;
} ;
struct XModifierKeymap{
  int max_keypermod;
  KeyCode *modifiermap;
} ;
alias _XDisplay Display;
struct _XPrivate;
struct _XrmHashBucketRec;

struct __XPrivDisplay{
  XExtData *ext_data;
  _XPrivate *private1;
  int fd;
  int private2;
  int proto_major_version;
  int proto_minor_version;
  byte *vendor;
  XID private3;
  XID private4;
  XID private5;
  int private6;
  XID (*resource_alloc)(
      _XDisplay*
      );
  int byte_order;
  int bitmap_unit;
  int bitmap_pad;
  int bitmap_bit_order;
  int nformats;
  ScreenFormat *pixmap_format;
  int private8;
  int release;
  _XPrivate* private9, private10;
  int qlen;
  uint last_request_read;
  uint request;
  XPointer private11;
  XPointer private12;
  XPointer private13;
  XPointer private14;
  uint max_request_size;
  _XrmHashBucketRec *db;
  int (*private15)(
      _XDisplay*
      );
  byte *display_name;
  int default_screen;
  int nscreens;
  Screen *screens;
  uint motion_buffer;
  uint private16;
  int min_keycode;
  int max_keycode;
  XPointer private17;
  XPointer private18;
  int private19;
  byte *xdefaults;
};
alias __XPrivDisplay* _XPrivDisplay;

struct XKeyEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Window root;
  Window subwindow;
  Time time;
  int x, y;
  int x_root, y_root;
  uint state;
  uint keycode;
  int same_screen;
} ;
alias XKeyEvent XKeyPressedEvent;
alias XKeyEvent XKeyReleasedEvent;

struct XButtonEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Window root;
  Window subwindow;
  Time time;
  int x, y;
  int x_root, y_root;
  uint state;
  uint button;
  int same_screen;
} ;
alias XButtonEvent XButtonPressedEvent;
alias XButtonEvent XButtonReleasedEvent;

struct XMotionEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Window root;
  Window subwindow;
  Time time;
  int x, y;
  int x_root, y_root;
  uint state;
  byte is_hint;
  int same_screen;
} ;
alias XMotionEvent XPointerMovedEvent;

struct XCrossingEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Window root;
  Window subwindow;
  Time time;
  int x, y;
  int x_root, y_root;
  int mode;
  int detail;

  int same_screen;
  int focus;
  uint state;
} ;
alias XCrossingEvent XEnterWindowEvent;
alias XCrossingEvent XLeaveWindowEvent;

struct XFocusChangeEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  int mode;

  int detail;
} ;
alias XFocusChangeEvent XFocusInEvent;
alias XFocusChangeEvent XFocusOutEvent;

struct XKeymapEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  byte key_vector[32];
} ;

struct XExposeEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  int x, y;
  int width, height;
  int count;
} ;

struct XGraphicsExposeEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Drawable drawable;
  int x, y;
  int width, height;
  int count;
  int major_code;
  int minor_code;
} ;

struct XNoExposeEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Drawable drawable;
  int major_code;
  int minor_code;
} ;

struct XVisibilityEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  int state;
} ;

struct XCreateWindowEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window parent;
  Window window;
  int x, y;
  int width, height;
  int border_width;
  int override_redirect;
} ;

struct XDestroyWindowEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
} ;

struct XUnmapEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  int from_configure;
} ;

struct XMapEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  int override_redirect;
} ;

struct XMapRequestEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window parent;
  Window window;
} ;

struct XReparentEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  Window parent;
  int x, y;
  int override_redirect;
} ;

struct XConfigureEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  int x, y;
  int width, height;
  int border_width;
  Window above;
  int override_redirect;
} ;

struct XGravityEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  int x, y;
} ;

struct XResizeRequestEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  int width, height;
} ;

struct XConfigureRequestEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window parent;
  Window window;
  int x, y;
  int width, height;
  int border_width;
  Window above;
  int detail;
  uint value_mask;
} ;

struct XCirculateEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window event;
  Window window;
  int place;
} ;

struct XCirculateRequestEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window parent;
  Window window;
  int place;
} ;

struct XPropertyEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Atom atom;
  Time time;
  int state;
} ;

struct XSelectionClearEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Atom selection;
  Time time;
} ;

struct XSelectionRequestEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window owner;
  Window requestor;
  Atom selection;
  Atom target;
  Atom property;
  Time time;
}

struct XSelectionEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window requestor;
  Atom selection;
  Atom target;
  Atom property;
  Time time;
}

struct XColormapEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Colormap colormap;
  //int new;
  int Cnew;

  int state;
}

struct XClientMessageEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  Atom message_type;
  int format;
  union {
    byte b[20];
    short s[10];
    int l[5];
  }
}

struct XMappingEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
  int request;

  int first_keycode;
  int count;
} ;

struct XErrorEvent{
  int type;
  Display *display;
  XID resourceid;
  uint serial;
  ubyte error_code;
  ubyte request_code;
  ubyte minor_code;
} ;

struct XAnyEvent{
  int type;
  uint serial;
  int send_event;
  Display *display;
  Window window;
} ;
union _XEvent {
  int type;
  XAnyEvent xany;
  XKeyEvent xkey;
  XButtonEvent xbutton;
  XMotionEvent xmotion;
  XCrossingEvent xcrossing;
  XFocusChangeEvent xfocus;
  XExposeEvent xexpose;
  XGraphicsExposeEvent xgraphicsexpose;
  XNoExposeEvent xnoexpose;
  XVisibilityEvent xvisibility;
  XCreateWindowEvent xcreatewindow;
  XDestroyWindowEvent xdestroywindow;
  XUnmapEvent xunmap;
  XMapEvent xmap;
  XMapRequestEvent xmaprequest;
  XReparentEvent xreparent;
  XConfigureEvent xconfigure;
  XGravityEvent xgravity;
  XResizeRequestEvent xresizerequest;
  XConfigureRequestEvent xconfigurerequest;
  XCirculateEvent xcirculate;
  XCirculateRequestEvent xcirculaterequest;
  XPropertyEvent xproperty;
  XSelectionClearEvent xselectionclear;
  XSelectionRequestEvent xselectionrequest;
  XSelectionEvent xselection;
  XColormapEvent xcolormap;
  XClientMessageEvent xclient;
  XMappingEvent xmapping;
  XErrorEvent xerror;
  XKeymapEvent xkeymap;
  int pad[24];
};
alias _XEvent XEvent;

struct XCharStruct{
  short lbearing;
  short rbearing;
  short width;
  short ascent;
  short descent;
  ushort attributes;
} ;

struct XFontProp{
  Atom name;
  uint card32;
} ;

struct XFontStruct{
  XExtData *ext_data;
  Font fid;
  uint direction;
  uint min_char_or_byte2;
  uint max_char_or_byte2;
  uint min_byte1;
  uint max_byte1;
  int all_chars_exist;
  uint default_char;
  int n_properties;
  XFontProp *properties;
  XCharStruct min_bounds;
  XCharStruct max_bounds;
  XCharStruct *per_char;
  int ascent;
  int descent;
} ;

struct XTextItem{
  byte *chars;
  int nchars;
  int delta;
  Font font;
} ;

struct XChar2b{
  ubyte byte1;
  ubyte byte2;
} ;

struct XTextItem16{
  XChar2b *chars;
  int nchars;
  int delta;
  Font font;
} ;
union XEDataObject{
  Display *display;
  GC gc;
  Visual *visual;
  Screen *screen;
  ScreenFormat *pixmap_format;
  XFontStruct *font; 
} ;

struct XFontSetExtents{
  XRectangle max_ink_extent;
  XRectangle max_logical_extent;
} ;
alias _XOM* XOM;
alias _XOC* XOC, XFontSet;

struct XmbTextItem{
  byte *chars;
  int nchars;
  int delta;
  XFontSet font_set;
} ;

struct XwcTextItem{
  wchar_t *chars;
  int nchars;
  int delta;
  XFontSet font_set;
} ;
struct XOMCharSetList{
  int byteset_count;
  byte **charset_list;
} ;

enum XOrientation{
  XOMOrientation_LTR_TTB,
  XOMOrientation_RTL_TTB,
  XOMOrientation_TTB_LTR,
  XOMOrientation_TTB_RTL,
  XOMOrientation_Context
} ;

struct XOMOrientation{
  int num_orientation;
  XOrientation *orientation;
} ;

struct XOMFontInfo{
  int num_font;
  XFontStruct **font_struct_list;
  byte **font_name_list;
} ;

alias _XIM* XIM;
alias _XIC* XIC;

alias void (*XIMProc)(
    XIM,
    XPointer,
    XPointer
    );

alias int (*XICProc)(
    XIC,
    XPointer,
    XPointer
    );

alias void (*XIDProc)(
    Display*,
    XPointer,
    XPointer
    );

alias uint XIMStyle;

struct XIMStyles{
  ushort count_styles;
  XIMStyle *supported_styles;
} ;

alias void *XVaNestedList;

struct XIMCallback{
  XPointer client_data;
  XIMProc callback;
} ;

struct XICCallback{
  XPointer client_data;
  XICProc callback;
} ;

alias uint XIMFeedback;
struct _XIMText {
  ushort length;
  XIMFeedback *feedback;
  int encoding_is_wchar;
  union {
    byte *multi_byte;
    wchar_t *wide_char;
  } ;
};
alias _XIMText XIMText;

alias uint XIMPreeditState;
struct _XIMPreeditStateNotifyCallbackStruct {
  XIMPreeditState state;
} ;
alias _XIMPreeditStateNotifyCallbackStruct XIMPreeditStateNotifyCallbackStruct;

alias uint XIMResetState;
alias uint XIMStringConversionFeedback;
struct _XIMStringConversionText {
  ushort length;
  XIMStringConversionFeedback *feedback;
  int encoding_is_wchar;
  union {
    byte *mbs;
    wchar_t *wcs;
  } 
}
alias _XIMStringConversionText XIMStringConversionText;

alias ushort XIMStringConversionPosition;

alias ushort XIMStringConversionType;
alias ushort XIMStringConversionOperation;
enum XIMCaretDirection{
  XIMForwardChar, XIMBackwardChar,
  XIMForwardWord, XIMBackwardWord,
  XIMCaretUp, XIMCaretDown,
  XIMNextLine, XIMPreviousLine,
  XIMLineStart, XIMLineEnd,
  XIMAbsolutePosition,
  XIMDontChange
} ;

struct _XIMStringConversionCallbackStruct {
  XIMStringConversionPosition position;
  XIMCaretDirection direction;
  XIMStringConversionOperation operation;
  ushort factor;
  XIMStringConversionText *text;
} ;
alias _XIMStringConversionCallbackStruct XIMStringConversionCallbackStruct;

struct _XIMPreeditDrawCallbackStruct {
  int caret;
  int chg_first;
  int chg_length;
  XIMText *text;
} ;
alias _XIMPreeditDrawCallbackStruct XIMPreeditDrawCallbackStruct;

enum XIMCaretStyle{
  XIMIsInvisible,
  XIMIsPrimary,
  XIMIsSecondary
} ;

struct _XIMPreeditCaretCallbackStruct {
  int position;
  XIMCaretDirection direction;
  XIMCaretStyle style;
};
alias _XIMPreeditCaretCallbackStruct XIMPreeditCaretCallbackStruct;

enum XIMStatusDataType{
  XIMTextType,
  XIMBitmapType
} ;

struct _XIMStatusDrawCallbackStruct {
  XIMStatusDataType type;
  union {
    XIMText *text;
    Pixmap bitmap;
  } ;
} ;
alias _XIMStatusDrawCallbackStruct XIMStatusDrawCallbackStruct;
struct _XIMHotKeyTrigger {
  KeySym keysym;
  int modifier;
  int modifier_mask;
};
alias _XIMHotKeyTrigger XIMHotKeyTrigger;

struct _XIMHotKeyTriggers {
  int num_hot_key;
  XIMHotKeyTrigger *key;
} ;
alias _XIMHotKeyTriggers XIMHotKeyTriggers;

alias uint XIMHotKeyState;
struct XIMValuesList{
  ushort count_values;
  byte **supported_values;
}

extern int _Xdebug;

extern XFontStruct *XLoadQueryFont(
    Display* ,
    byte*
    );

extern XFontStruct *XQueryFont(
    Display* ,
    XID
    );
extern XTimeCoord *XGetMotionEvents(
    Display* ,
    Window ,
    Time ,
    Time ,
    int*
    );

extern XModifierKeymap *XDeleteModifiermapEntry(
    XModifierKeymap* ,

    uint ,
    int
    );

extern XModifierKeymap *XGetModifierMapping(
    Display*
    );

extern XModifierKeymap *XInsertModifiermapEntry(
    XModifierKeymap* ,

    uint ,
    int
    );

extern XModifierKeymap *XNewModifiermap(
    int
    );

extern XImage *XCreateImage(
    Display* ,
    Visual* ,
    uint ,
    int ,
    int ,
    byte* ,
    uint ,
    uint ,
    int ,
    int
    );
extern int XInitImage(
    XImage*
    );
extern XImage *XGetImage(
    Display* ,
    Drawable ,
    int ,
    int ,
    uint ,
    uint ,
    uint ,
    int
    );
extern XImage *XGetSubImage(
    Display* ,
    Drawable ,
    int ,
    int ,
    uint ,
    uint ,
    uint ,
    int ,
    XImage* ,
    int ,
    int
    );

extern Display *XOpenDisplay(
    byte*
    );

extern void XrmInitialize(
    );

extern byte *XFetchBytes(
    Display* ,
    int*
    );
extern byte *XFetchBuffer(
    Display* ,
    int* ,
    int
    );
extern byte *XGetAtomName(
    Display* ,
    Atom
    );
extern int XGetAtomNames(
    Display* ,
    Atom* ,
    int ,
    byte**
    );
extern byte *XGetDefault(
    Display* ,
    byte* ,
    byte*
    );
extern byte *XDisplayName(
    byte*
    );
extern byte *XKeysymToString(
    KeySym
    );

extern int (*XSynchronize(
      Display* ,
      int
      ))(
      Display*
      );
extern int (*XSetAfterFunction(
      Display* ,
      int (*) (
        Display*
        )
      ))(
      Display*
      );
extern Atom XInternAtom(
          Display* ,
          byte* ,
          int
    );
extern int XInternAtoms(
    Display* ,
    byte** ,
    int ,
    int ,
    Atom*
    );
extern Colormap XCopyColormapAndFree(
    Display* ,
    Colormap
    );
extern Colormap XCreateColormap(
    Display* ,
    Window ,
    Visual* ,
    int
    );
extern Cursor XCreatePixmapCursor(
    Display* ,
    Pixmap ,
    Pixmap ,
    XColor* ,
    XColor* ,
    uint ,
    uint
    );
extern Cursor XCreateGlyphCursor(
    Display* ,
    Font ,
    Font ,
    uint ,
    uint ,
    XColor * ,
    XColor *
    );
extern Cursor XCreateFontCursor(
    Display* ,
    uint
    );
extern Font XLoadFont(
    Display* ,
    byte*
    );
extern GC XCreateGC(
    Display* ,
    Drawable ,
    uint ,
    XGCValues*
    );
extern GContext XGContextFromGC(
    GC
    );
extern void XFlushGC(
    Display* ,
    GC
    );
extern Pixmap XCreatePixmap(
    Display* ,
    Drawable ,
    uint ,
    uint ,
    uint
    );
extern Pixmap XCreateBitmapFromData(
    Display* ,
    Drawable ,
    byte* ,
    uint ,
    uint
    );
extern Pixmap XCreatePixmapFromBitmapData(
    Display* ,
    Drawable ,
    byte* ,
    uint ,
    uint ,
    uint ,
    uint ,
    uint
    );
extern Window XCreateSimpleWindow(
    Display* ,
    Window ,
    int ,
    int ,
    uint ,
    uint ,
    uint ,
    uint ,
    uint
    );
extern Window XGetSelectionOwner(
    Display* ,
    Atom
    );
extern Window XCreateWindow(
    Display* ,
    Window ,
    int ,
    int ,
    uint ,
    uint ,
    uint ,
    int ,
    uint ,
    Visual* ,
    uint ,
    XSetWindowAttributes*
    );
extern Colormap *XListInstalledColormaps(
    Display* ,
    Window ,
    int*
    );
extern byte **XListFonts(
    Display* ,
    byte* ,
    int ,
    int*
    );
extern byte **XListFontsWithInfo(
    Display* ,
    byte* ,
    int ,
    int* ,
    XFontStruct**
    );
extern byte **XGetFontPath(
    Display* ,
    int*
    );
extern byte **XListExtensions(
    Display* ,
    int*
    );
extern Atom *XListProperties(
    Display* ,
    Window ,
    int*
    );
extern XHostAddress *XListHosts(
    Display* ,
    int* ,
    int*
    );
extern KeySym XKeycodeToKeysym(
    Display* ,

    uint ,
    int
    );
extern KeySym XLookupKeysym(
    XKeyEvent* ,
    int
    );
extern KeySym *XGetKeyboardMapping(
    Display* ,

    uint ,
    int ,
    int*
    );
extern KeySym XStringToKeysym(
    byte*
    );
extern int XMaxRequestSize(
    Display*
    );
extern int XExtendedMaxRequestSize(
    Display*
    );
extern byte *XResourceManagerString(
    Display*
    );
extern byte *XScreenResourceString(
    Screen*
    );
extern uint XDisplayMotionBufferSize(
    Display*
    );
extern VisualID XVisualIDFromVisual(
    Visual*
    );
extern int XInitThreads(
    );

extern void XLockDisplay(
    Display*
    );

extern void XUnlockDisplay(
    Display*
    );
extern XExtCodes *XInitExtension(
    Display* ,
    byte*
    );

extern XExtCodes *XAddExtension(
    Display*
    );
extern XExtData *XFindOnExtensionList(
    XExtData** ,
    int
    );
extern XExtData **XEHeadOfExtensionList(
    XEDataObject
    );
extern Window XRootWindow(
      Display* ,
      int
    );
extern Window XDefaultRootWindow(
    Display*
    );
extern Window XRootWindowOfScreen(
    Screen*
    );
extern Visual *XDefaultVisual(
    Display* ,
    int
    );
extern Visual *XDefaultVisualOfScreen(
    Screen*
    );
extern GC XDefaultGC(
    Display* ,
    int
    );
extern GC XDefaultGCOfScreen(
    Screen*
    );
extern uint XBlackPixel(
    Display* ,
    int
    );
extern uint XWhitePixel(
    Display* ,
    int
    );
extern uint XAllPlanes(
    );
extern uint XBlackPixelOfScreen(
    Screen*
    );
extern uint XWhitePixelOfScreen(
    Screen*
    );
extern uint XNextRequest(
    Display*
    );
extern uint XLastKnownRequestProcessed(
    Display*
    );
extern byte *XServerVendor(
    Display*
    );
extern byte *XDisplayString(
    Display*
    );
extern Colormap XDefaultColormap(
    Display* ,
    int
    );
extern Colormap XDefaultColormapOfScreen(
    Screen*
    );
extern Display *XDisplayOfScreen(
    Screen*
    );
extern Screen *XScreenOfDisplay(
    Display* ,
    int
    );
extern Screen *XDefaultScreenOfDisplay(
    Display*
    );
extern int XEventMaskOfScreen(
    Screen*
    );

extern int XScreenNumberOfScreen(
    Screen*
    );

alias int (*XErrorHandler) (
    Display* ,
    XErrorEvent*
    );

extern XErrorHandler XSetErrorHandler (
    XErrorHandler
    );

alias int (*XIOErrorHandler) (
    Display*
    );

extern XIOErrorHandler XSetIOErrorHandler (
    XIOErrorHandler
    );
extern XPixmapFormatValues *XListPixmapFormats(
      Display* ,
      int*
    );
extern int *XListDepths(
    Display* ,
    int ,
    int*
    );
extern int XReconfigureWMWindow(
    Display* ,
    Window ,
    int ,
    uint ,
    XWindowChanges*
    );

extern int XGetWMProtocols(
    Display* ,
    Window ,
    Atom** ,
    int*
    );
extern int XSetWMProtocols(
    Display* ,
    Window ,
    Atom* ,
    int
    );
extern int XIconifyWindow(
    Display* ,
    Window ,
    int
    );
extern int XWithdrawWindow(
    Display* ,
    Window ,
    int
    );
extern int XGetCommand(
    Display* ,
    Window ,
    byte*** ,
    int*
    );
extern int XGetWMColormapWindows(
    Display* ,
    Window ,
    Window** ,
    int*
    );
extern int XSetWMColormapWindows(
    Display* ,
    Window ,
    Window* ,
    int
    );
extern void XFreeStringList(
    byte**
    );
extern int XSetTransientForHint(
    Display* ,
    Window ,
    Window
    );
extern int XActivateScreenSaver(
    Display*
    );

extern int XAddHost(
    Display* ,
    XHostAddress*
    );

extern int XAddHosts(
    Display* ,
    XHostAddress* ,
    int
    );

extern int XAddToExtensionList(
    _XExtData** ,
    XExtData*
    );

extern int XAddToSaveSet(
    Display* ,
    Window
    );

extern int XAllocColor(
    Display* ,
    Colormap ,
    XColor*
    );

extern int XAllocColorCells(
    Display* ,
    Colormap ,
    int ,
    uint* ,
    uint ,
    uint* ,
    uint
    );

extern int XAllocColorPlanes(
    Display* ,
    Colormap ,
    int ,
    uint* ,
    int ,
    int ,
    int ,
    int ,
    uint* ,
    uint* ,
    uint*
    );

extern int XAllocNamedColor(
    Display* ,
    Colormap ,
    byte* ,
    XColor* ,
    XColor*
    );

extern int XAllowEvents(
    Display* ,
    int ,
    Time
    );

extern int XAutoRepeatOff(
    Display*
    );

extern int XAutoRepeatOn(
    Display*
    );

extern int XBell(
    Display* ,
    int
    );

extern int XBitmapBitOrder(
    Display*
    );

extern int XBitmapPad(
    Display*
    );

extern int XBitmapUnit(
    Display*
    );

extern int XCellsOfScreen(
    Screen*
    );

extern int XChangeActivePointerGrab(
    Display* ,
    uint ,
    Cursor ,
    Time
    );

extern int XChangeGC(
    Display* ,
    GC ,
    uint ,
    XGCValues*
    );

extern int XChangeKeyboardControl(
    Display* ,
    uint ,
    XKeyboardControl*
    );

extern int XChangeKeyboardMapping(
    Display* ,
    int ,
    int ,
    KeySym* ,
    int
    );

extern int XChangePointerControl(
    Display* ,
    int ,
    int ,
    int ,
    int ,
    int
    );

extern int XChangeProperty(
    Display* ,
    Window ,
    Atom ,
    Atom ,
    int ,
    int ,
    ubyte* ,
    int
    );

extern int XChangeSaveSet(
    Display* ,
    Window ,
    int
    );

extern int XChangeWindowAttributes(
    Display* ,
    Window ,
    uint ,
    XSetWindowAttributes*
    );

extern int XCheckIfEvent(
    Display* ,
    XEvent* ,
    int (*) (
      Display* ,
      XEvent* ,
      XPointer
      ) ,
    XPointer
    );

extern int XCheckMaskEvent(
    Display* ,
    int ,
    XEvent*
    );

extern int XCheckTypedEvent(
    Display* ,
    int ,
    XEvent*
    );

extern int XCheckTypedWindowEvent(
    Display* ,
    Window ,
    int ,
    XEvent*
    );

extern int XCheckWindowEvent(
    Display* ,
    Window ,
    int ,
    XEvent*
    );

extern int XCirculateSubwindows(
    Display* ,
    Window ,
    int
    );

extern int XCirculateSubwindowsDown(
    Display* ,
    Window
    );

extern int XCirculateSubwindowsUp(
    Display* ,
    Window
    );

extern int XClearArea(
    Display* ,
    Window ,
    int ,
    int ,
    uint ,
    uint ,
    int
    );

extern int XClearWindow(
    Display* ,
    Window
    );

extern int XCloseDisplay(
    Display*
    );

extern int XConfigureWindow(
    Display* ,
    Window ,
    uint ,
    XWindowChanges*
    );

extern int XConnectionNumber(
    Display*
    );

extern int XConvertSelection(
    Display* ,
    Atom ,
    Atom ,
    Atom ,
    Window ,
    Time
    );

extern int XCopyArea(
    Display* ,
    Drawable ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint ,
    int ,
    int
    );

extern int XCopyGC(
    Display* ,
    GC ,
    uint ,
    GC
    );

extern int XCopyPlane(
    Display* ,
    Drawable ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint ,
    int ,
    int ,
    uint
    );

extern int XDefaultDepth(
    Display* ,
    int
    );

extern int XDefaultDepthOfScreen(
    Screen*
    );

extern int XDefaultScreen(
    Display*
    );

extern int XDefineCursor(
    Display* ,
    Window ,
    Cursor
    );

extern int XDeleteProperty(
    Display* ,
    Window ,
    Atom
    );

extern int XDestroyWindow(
    Display* ,
    Window
    );

extern int XDestroySubwindows(
    Display* ,
    Window
    );

extern int XDoesBackingStore(
    Screen*
    );

extern int XDoesSaveUnders(
    Screen*
    );

extern int XDisableAccessControl(
    Display*
    );
extern int XDisplayCells(
      Display* ,
      int
    );

extern int XDisplayHeight(
    Display* ,
    int
    );

extern int XDisplayHeightMM(
    Display* ,
    int
    );

extern int XDisplayKeycodes(
    Display* ,
    int* ,
    int*
    );

extern int XDisplayPlanes(
    Display* ,
    int
    );

extern int XDisplayWidth(
    Display* ,
    int
    );

extern int XDisplayWidthMM(
    Display* ,
    int
    );

extern int XDrawArc(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint ,
    int ,
    int
    );

extern int XDrawArcs(
    Display* ,
    Drawable ,
    GC ,
    XArc* ,
    int
    );

extern int XDrawImageString(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern int XDrawImageString16(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XChar2b* ,
    int
    );

extern int XDrawLine(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    int ,
    int
    );

extern int XDrawLines(
    Display* ,
    Drawable ,
    GC ,
    XPoint* ,
    int ,
    int
    );

extern int XDrawPoint(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int
    );

extern int XDrawPoints(
    Display* ,
    Drawable ,
    GC ,
    XPoint* ,
    int ,
    int
    );

extern int XDrawRectangle(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint
    );

extern int XDrawRectangles(
    Display* ,
    Drawable ,
    GC ,
    XRectangle* ,
    int
    );

extern int XDrawSegments(
    Display* ,
    Drawable ,
    GC ,
    XSegment* ,
    int
    );

extern int XDrawString(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern int XDrawString16(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XChar2b* ,
    int
    );

extern int XDrawText(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XTextItem* ,
    int
    );

extern int XDrawText16(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XTextItem16* ,
    int
    );

extern int XEnableAccessControl(
    Display*
    );

extern int XEventsQueued(
    Display* ,
    int
    );

extern int XFetchName(
    Display* ,
    Window ,
    byte**
    );

extern int XFillArc(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint ,
    int ,
    int
    );

extern int XFillArcs(
    Display* ,
    Drawable ,
    GC ,
    XArc* ,
    int
    );

extern int XFillPolygon(
    Display* ,
    Drawable ,
    GC ,
    XPoint* ,
    int ,
    int ,
    int
    );

extern int XFillRectangle(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    uint ,
    uint
    );

extern int XFillRectangles(
    Display* ,
    Drawable ,
    GC ,
    XRectangle* ,
    int
    );

extern int XFlush(
    Display*
    );

extern int XForceScreenSaver(
    Display* ,
    int
    );

extern int XFree(
    void*
    );

extern int XFreeColormap(
    Display* ,
    Colormap
    );

extern int XFreeColors(
    Display* ,
    Colormap ,
    uint* ,
    int ,
    uint
    );

extern int XFreeCursor(
    Display* ,
    Cursor
    );

extern int XFreeExtensionList(
    byte**
    );

extern int XFreeFont(
    Display* ,
    XFontStruct*
    );

extern int XFreeFontInfo(
    byte** ,
    XFontStruct* ,
    int
    );

extern int XFreeFontNames(
    byte**
    );

extern int XFreeFontPath(
    byte**
    );

extern int XFreeGC(
    Display* ,
    GC
    );

extern int XFreeModifiermap(
    XModifierKeymap*
    );

extern int XFreePixmap(
    Display* ,
    Pixmap
    );

extern int XGeometry(
    Display* ,
    int ,
    byte* ,
    byte* ,
    uint ,
    uint ,
    uint ,
    int ,
    int ,
    int* ,
    int* ,
    int* ,
    int*
    );

extern int XGetErrorDatabaseText(
    Display* ,
    byte* ,
    byte* ,
    byte* ,
    byte* ,
    int
    );

extern int XGetErrorText(
    Display* ,
    int ,
    byte* ,
    int
    );

extern int XGetFontProperty(
    XFontStruct* ,
    Atom ,
    uint*
    );

extern int XGetGCValues(
    Display* ,
    GC ,
    uint ,
    XGCValues*
    );

extern int XGetGeometry(
    Display* ,
    Drawable ,
    Window* ,
    int* ,
    int* ,
    uint* ,
    uint* ,
    uint* ,
    uint*
    );

extern int XGetIconName(
    Display* ,
    Window ,
    byte**
    );

extern int XGetInputFocus(
    Display* ,
    Window* ,
    int*
    );

extern int XGetKeyboardControl(
    Display* ,
    XKeyboardState*
    );

extern int XGetPointerControl(
    Display* ,
    int* ,
    int* ,
    int*
    );

extern int XGetPointerMapping(
    Display* ,
    ubyte* ,
    int
    );

extern int XGetScreenSaver(
    Display* ,
    int* ,
    int* ,
    int* ,
    int*
    );

extern int XGetTransientForHint(
    Display* ,
    Window ,
    Window*
    );

extern int XGetWindowProperty(
    Display* ,
    Window ,
    Atom ,
    int ,
    int ,
    int ,
    Atom ,
    Atom* ,
    int* ,
    uint* ,
    uint* ,
    ubyte**
    );

extern int XGetWindowAttributes(
    Display* ,
    Window ,
    XWindowAttributes*
    );

extern int XGrabButton(
    Display* ,
    uint ,
    uint ,
    Window ,
    int ,
    uint ,
    int ,
    int ,
    Window ,
    Cursor
    );

extern int XGrabKey(
    Display* ,
    int ,
    uint ,
    Window ,
    int ,
    int ,
    int
    );

extern int XGrabKeyboard(
    Display* ,
    Window ,
    int ,
    int ,
    int ,
    Time
    );

extern int XGrabPointer(
    Display* ,
    Window ,
    int ,
    uint ,
    int ,
    int ,
    Window ,
    Cursor ,
    Time
    );

extern int XGrabServer(
    Display*
    );

extern int XHeightMMOfScreen(
    Screen*
    );

extern int XHeightOfScreen(
    Screen*
    );

extern int XIfEvent(
    Display* ,
    XEvent* ,
    int (*) (
      Display* ,
      XEvent* ,
      XPointer
      ) ,
    XPointer
    );

extern int XImageByteOrder(
    Display*
    );

extern int XInstallColormap(
    Display* ,
    Colormap
    );

extern KeyCode XKeysymToKeycode(
    Display* ,
    KeySym
    );

extern int XKillClient(
    Display* ,
    XID
    );

extern int XLookupColor(
    Display* ,
    Colormap ,
    byte* ,
    XColor* ,
    XColor*
    );

extern int XLowerWindow(
    Display* ,
    Window
    );

extern int XMapRaised(
    Display* ,
    Window
    );

extern int XMapSubwindows(
    Display* ,
    Window
    );

extern int XMapWindow(
    Display* ,
    Window
    );

extern int XMaskEvent(
    Display* ,
    int ,
    XEvent*
    );

extern int XMaxCmapsOfScreen(
    Screen*
    );

extern int XMinCmapsOfScreen(
    Screen*
    );

extern int XMoveResizeWindow(
    Display* ,
    Window ,
    int ,
    int ,
    uint ,
    uint
    );

extern int XMoveWindow(
    Display* ,
    Window ,
    int ,
    int
    );

extern int XNextEvent(
    Display* ,
    XEvent*
    );

extern int XNoOp(
    Display*
    );

extern int XParseColor(
    Display* ,
    Colormap ,
    byte* ,
    XColor*
    );

extern int XParseGeometry(
    byte* ,
    int* ,
    int* ,
    uint* ,
    uint*
    );

extern int XPeekEvent(
    Display* ,
    XEvent*
    );

extern int XPeekIfEvent(
    Display* ,
    XEvent* ,
    int (*) (
      Display* ,
      XEvent* ,
      XPointer
      ) ,
    XPointer
    );

extern int XPending(
    Display*
    );

extern int XPlanesOfScreen(
    Screen*
    );

extern int XProtocolRevision(
    Display*
    );

extern int XProtocolVersion(
    Display*
    );
extern int XPutBackEvent(
      Display* ,
      XEvent*
    );

extern int XPutImage(
    Display* ,
    Drawable ,
    GC ,
    XImage* ,
    int ,
    int ,
    int ,
    int ,
    uint ,
    uint
    );

extern int XQLength(
    Display*
    );

extern int XQueryBestCursor(
    Display* ,
    Drawable ,
    uint ,
    uint ,
    uint* ,
    uint*
    );

extern int XQueryBestSize(
    Display* ,
    int ,
    Drawable ,
    uint ,
    uint ,
    uint* ,
    uint*
    );

extern int XQueryBestStipple(
    Display* ,
    Drawable ,
    uint ,
    uint ,
    uint* ,
    uint*
    );

extern int XQueryBestTile(
    Display* ,
    Drawable ,
    uint ,
    uint ,
    uint* ,
    uint*
    );

extern int XQueryColor(
    Display* ,
    Colormap ,
    XColor*
    );

extern int XQueryColors(
    Display* ,
    Colormap ,
    XColor* ,
    int
    );

extern int XQueryExtension(
    Display* ,
    byte* ,
    int* ,
    int* ,
    int*
    );

extern int XQueryKeymap(
    Display* ,
    byte [32]
    );

extern int XQueryPointer(
    Display* ,
    Window ,
    Window* ,
    Window* ,
    int* ,
    int* ,
    int* ,
    int* ,
    uint*
    );

extern int XQueryTextExtents(
    Display* ,
    XID ,
    byte* ,
    int ,
    int* ,
    int* ,
    int* ,
    XCharStruct*
    );

extern int XQueryTextExtents16(
    Display* ,
    XID ,
    XChar2b* ,
    int ,
    int* ,
    int* ,
    int* ,
    XCharStruct*
    );

extern int XQueryTree(
    Display* ,
    Window ,
    Window* ,
    Window* ,
    Window** ,
    uint*
    );

extern int XRaiseWindow(
    Display* ,
    Window
    );

extern int XReadBitmapFile(
    Display* ,
    Drawable ,
    byte* ,
    uint* ,
    uint* ,
    Pixmap* ,
    int* ,
    int*
    );

extern int XReadBitmapFileData(
    byte* ,
    uint* ,
    uint* ,
    ubyte** ,
    int* ,
    int*
    );

extern int XRebindKeysym(
    Display* ,
    KeySym ,
    KeySym* ,
    int ,
    ubyte* ,
    int
    );

extern int XRecolorCursor(
    Display* ,
    Cursor ,
    XColor* ,
    XColor*
    );

extern int XRefreshKeyboardMapping(
    XMappingEvent*
    );

extern int XRemoveFromSaveSet(
    Display* ,
    Window
    );

extern int XRemoveHost(
    Display* ,
    XHostAddress*
    );

extern int XRemoveHosts(
    Display* ,
    XHostAddress* ,
    int
    );

extern int XReparentWindow(
    Display* ,
    Window ,
    Window ,
    int ,
    int
    );

extern int XResetScreenSaver(
    Display*
    );

extern int XResizeWindow(
    Display* ,
    Window ,
    uint ,
    uint
    );

extern int XRestackWindows(
    Display* ,
    Window* ,
    int
    );

extern int XRotateBuffers(
    Display* ,
    int
    );

extern int XRotateWindowProperties(
    Display* ,
    Window ,
    Atom* ,
    int ,
    int
    );

extern int XScreenCount(
    Display*
    );

extern int XSelectInput(
    Display* ,
    Window ,
    int
    );

extern int XSendEvent(
    Display* ,
    Window ,
    int ,
    int ,
    XEvent*
    );

extern int XSetAccessControl(
    Display* ,
    int
    );

extern int XSetArcMode(
    Display* ,
    GC ,
    int
    );

extern int XSetBackground(
    Display* ,
    GC ,
    uint
    );

extern int XSetClipMask(
    Display* ,
    GC ,
    Pixmap
    );

extern int XSetClipOrigin(
    Display* ,
    GC ,
    int ,
    int
    );

extern int XSetClipRectangles(
    Display* ,
    GC ,
    int ,
    int ,
    XRectangle* ,
    int ,
    int
    );

extern int XSetCloseDownMode(
    Display* ,
    int
    );

extern int XSetCommand(
    Display* ,
    Window ,
    byte** ,
    int
    );

extern int XSetDashes(
    Display* ,
    GC ,
    int ,
    byte* ,
    int
    );

extern int XSetFillRule(
    Display* ,
    GC ,
    int
    );

extern int XSetFillStyle(
    Display* ,
    GC ,
    int
    );

extern int XSetFont(
    Display* ,
    GC ,
    Font
    );

extern int XSetFontPath(
    Display* ,
    byte** ,
    int
    );

extern int XSetForeground(
    Display* ,
    GC ,
    uint
    );

extern int XSetFunction(
    Display* ,
    GC ,
    int
    );

extern int XSetGraphicsExposures(
    Display* ,
    GC ,
    int
    );

extern int XSetIconName(
    Display* ,
    Window ,
    byte*
    );

extern int XSetInputFocus(
    Display* ,
    Window ,
    int ,
    Time
    );

extern int XSetLineAttributes(
    Display* ,
    GC ,
    uint ,
    int ,
    int ,
    int
    );

extern int XSetModifierMapping(
    Display* ,
    XModifierKeymap*
    );

extern int XSetPlaneMask(
    Display* ,
    GC ,
    uint
    );

extern int XSetPointerMapping(
    Display* ,
    ubyte* ,
    int
    );

extern int XSetScreenSaver(
    Display* ,
    int ,
    int ,
    int ,
    int
    );

extern int XSetSelectionOwner(
    Display* ,
    Atom ,
    Window ,
    Time
    );

extern int XSetState(
    Display* ,
    GC ,
    uint ,
    uint ,
    int ,
    uint
    );

extern int XSetStipple(
    Display* ,
    GC ,
    Pixmap
    );

extern int XSetSubwindowMode(
    Display* ,
    GC ,
    int
    );

extern int XSetTSOrigin(
    Display* ,
    GC ,
    int ,
    int
    );

extern int XSetTile(
    Display* ,
    GC ,
    Pixmap
    );

extern int XSetWindowBackground(
    Display* ,
    Window ,
    uint
    );

extern int XSetWindowBackgroundPixmap(
    Display* ,
    Window ,
    Pixmap
    );

extern int XSetWindowBorder(
    Display* ,
    Window ,
    uint
    );

extern int XSetWindowBorderPixmap(
    Display* ,
    Window ,
    Pixmap
    );

extern int XSetWindowBorderWidth(
    Display* ,
    Window ,
    uint
    );

extern int XSetWindowColormap(
    Display* ,
    Window ,
    Colormap
    );

extern int XStoreBuffer(
    Display* ,
    byte* ,
    int ,
    int
    );

extern int XStoreBytes(
    Display* ,
    byte* ,
    int
    );

extern int XStoreColor(
    Display* ,
    Colormap ,
    XColor*
    );

extern int XStoreColors(
    Display* ,
    Colormap ,
    XColor* ,
    int
    );

extern int XStoreName(
    Display* ,
    Window ,
    byte*
    );

extern int XStoreNamedColor(
    Display* ,
    Colormap ,
    byte* ,
    uint ,
    int
    );

extern int XSync(
    Display* ,
    int
    );

extern int XTextExtents(
    XFontStruct* ,
    byte* ,
    int ,
    int* ,
    int* ,
    int* ,
    XCharStruct*
    );

extern int XTextExtents16(
    XFontStruct* ,
    XChar2b* ,
    int ,
    int* ,
    int* ,
    int* ,
    XCharStruct*
    );

extern int XTextWidth(
    XFontStruct* ,
    byte* ,
    int
    );

extern int XTextWidth16(
    XFontStruct* ,
    XChar2b* ,
    int
    );

extern int XTranslateCoordinates(
    Display* ,
    Window ,
    Window ,
    int ,
    int ,
    int* ,
    int* ,
    Window*
    );

extern int XUndefineCursor(
    Display* ,
    Window
    );

extern int XUngrabButton(
    Display* ,
    uint ,
    uint ,
    Window
    );

extern int XUngrabKey(
    Display* ,
    int ,
    uint ,
    Window
    );

extern int XUngrabKeyboard(
    Display* ,
    Time
    );

extern int XUngrabPointer(
    Display* ,
    Time
    );

extern int XUngrabServer(
    Display*
    );

extern int XUninstallColormap(
    Display* ,
    Colormap
    );

extern int XUnloadFont(
    Display* ,
    Font
    );

extern int XUnmapSubwindows(
    Display* ,
    Window
    );

extern int XUnmapWindow(
    Display* ,
    Window
    );

extern int XVendorRelease(
    Display*
    );

extern int XWarpPointer(
    Display* ,
    Window ,
    Window ,
    int ,
    int ,
    uint ,
    uint ,
    int ,
    int
    );

extern int XWidthMMOfScreen(
    Screen*
    );

extern int XWidthOfScreen(
    Screen*
    );

extern int XWindowEvent(
    Display* ,
    Window ,
    int ,
    XEvent*
    );

extern int XWriteBitmapFile(
    Display* ,
    byte* ,
    Pixmap ,
    uint ,
    uint ,
    int ,
    int
    );

extern int XSupportsLocale ();

extern byte *XSetLocaleModifiers(
    byte*
    );

extern XOM XOpenOM(
    Display* ,
    _XrmHashBucketRec* ,
    byte* ,
    byte*
    );

extern int XCloseOM(
    XOM
    );

extern byte *XSetOMValues(
    XOM ,
    ...
    ) ;

extern byte *XGetOMValues(
    XOM ,
    ...
    ) ;

extern Display *XDisplayOfOM(
    XOM
    );

extern byte *XLocaleOfOM(
    XOM
    );

extern XOC XCreateOC(
    XOM ,
    ...
    ) ;

extern void XDestroyOC(
    XOC
    );

extern XOM XOMOfOC(
    XOC
    );

extern byte *XSetOCValues(
    XOC ,
    ...
    ) ;

extern byte *XGetOCValues(
    XOC ,
    ...
    ) ;

extern XFontSet XCreateFontSet(
    Display* ,
    byte* ,
    byte*** ,
    int* ,
    byte**
    );

extern void XFreeFontSet(
    Display* ,
    XFontSet
    );

extern int XFontsOfFontSet(
    XFontSet ,
    XFontStruct*** ,
    byte***
    );

extern byte *XBaseFontNameListOfFontSet(
    XFontSet
    );

extern byte *XLocaleOfFontSet(
    XFontSet
    );

extern int XContextDependentDrawing(
    XFontSet
    );

extern int XDirectionalDependentDrawing(
    XFontSet
    );

extern int XContextualDrawing(
    XFontSet
    );

extern XFontSetExtents *XExtentsOfFontSet(
    XFontSet
    );

extern int XmbTextEscapement(
    XFontSet ,
    byte* ,
    int
    );

extern int XwcTextEscapement(
    XFontSet ,
    wchar_t* ,
    int
    );

extern int Xutf8TextEscapement(
    XFontSet ,
    byte* ,
    int
    );

extern int XmbTextExtents(
    XFontSet ,
    byte* ,
    int ,
    XRectangle* ,
    XRectangle*
    );

extern int XwcTextExtents(
    XFontSet ,
    wchar_t* ,
    int ,
    XRectangle* ,
    XRectangle*
    );

extern int Xutf8TextExtents(
    XFontSet ,
    byte* ,
    int ,
    XRectangle* ,
    XRectangle*
    );

extern int XmbTextPerCharExtents(
    XFontSet ,
    byte* ,
    int ,
    XRectangle* ,
    XRectangle* ,
    int ,
    int* ,
    XRectangle* ,
    XRectangle*
    );

extern int XwcTextPerCharExtents(
    XFontSet ,
    wchar_t* ,
    int ,
    XRectangle* ,
    XRectangle* ,
    int ,
    int* ,
    XRectangle* ,
    XRectangle*
    );

extern int Xutf8TextPerCharExtents(
    XFontSet ,
    byte* ,
    int ,
    XRectangle* ,
    XRectangle* ,
    int ,
    int* ,
    XRectangle* ,
    XRectangle*
    );

extern void XmbDrawText(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XmbTextItem* ,
    int
    );

extern void XwcDrawText(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XwcTextItem* ,
    int
    );

extern void Xutf8DrawText(
    Display* ,
    Drawable ,
    GC ,
    int ,
    int ,
    XmbTextItem* ,
    int
    );

extern void XmbDrawString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern void XwcDrawString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    wchar_t* ,
    int
    );

extern void Xutf8DrawString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern void XmbDrawImageString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern void XwcDrawImageString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    wchar_t* ,
    int
    );

extern void Xutf8DrawImageString(
    Display* ,
    Drawable ,
    XFontSet ,
    GC ,
    int ,
    int ,
    byte* ,
    int
    );

extern XIM XOpenIM(
    Display* ,
    _XrmHashBucketRec* ,
    byte* ,
    byte*
    );

extern int XCloseIM(
    XIM
    );

extern byte *XGetIMValues(
    XIM , ...
    ) ;

extern byte *XSetIMValues(
    XIM , ...
    ) ;

extern Display *XDisplayOfIM(
    XIM
    );

extern byte *XLocaleOfIM(
    XIM
    );

extern XIC XCreateIC(
    XIM , ...
    ) ;

extern void XDestroyIC(
    XIC
    );

extern void XSetICFocus(
    XIC
    );

extern void XUnsetICFocus(
    XIC
    );

extern wchar_t *XwcResetIC(
    XIC
    );

extern byte *XmbResetIC(
    XIC
    );

extern byte *Xutf8ResetIC(
    XIC
    );

extern byte *XSetICValues(
    XIC , ...
    ) ;

extern byte *XGetICValues(
    XIC , ...
    ) ;

extern XIM XIMOfIC(
    XIC
    );

extern int XFilterEvent(
    XEvent* ,
    Window
    );

extern int XmbLookupString(
    XIC ,
    XKeyPressedEvent* ,
    byte* ,
    int ,
    KeySym* ,
    int*
    );

extern int XwcLookupString(
    XIC ,
    XKeyPressedEvent* ,
    wchar_t* ,
    int ,
    KeySym* ,
    int*
    );

extern int Xutf8LookupString(
    XIC ,
    XKeyPressedEvent* ,
    byte* ,
    int ,
    KeySym* ,
    int*
    );

extern XVaNestedList XVaCreateNestedList(
    int , ...
    ) ;
extern int XRegisterIMInstantiateCallback(
    Display* ,
    _XrmHashBucketRec* ,
    byte* ,
    byte* ,
    XIDProc ,
    XPointer
    );

extern int XUnregisterIMInstantiateCallback(
    Display* ,
    _XrmHashBucketRec* ,
    byte* ,
    byte* ,
    XIDProc ,
    XPointer
    );

alias void (*XConnectionWatchProc)(
    Display* ,
    XPointer ,
    int ,
    int ,
    XPointer*
    );
extern int XInternalConnectionNumbers(
    Display* ,
    int** ,
    int*
    );

extern void XProcessInternalConnection(
    Display* ,
    int
    );

extern int XAddConnectionWatch(
    Display* ,
    XConnectionWatchProc ,
    XPointer
    );

extern void XRemoveConnectionWatch(
    Display* ,
    XConnectionWatchProc ,
    XPointer
    );

extern void XSetAuthorization(
    byte * ,
    int ,
    byte * ,
    int
    );

extern int _Xmbtowc(
    wchar_t * ,

    byte * ,
    int

    );

extern int _Xwctomb(
    byte * ,
    wchar_t
    );


