
typedef void (*opType)();
typedef enum type{
  T_NONE,
  T_CHAR,
  T_STRING,
  T_INTEGER,
  T_PAIR,
  T_PROC,
  T_SYNTAX,
  T_SYMBOL,
  T_LAMBDA,
} Type;
struct cell;
typedef struct cell *Cell;
typedef union cellUnion
{
  char    _char;
  char*   _string;
  int     _integer;
  struct{
    Cell  _car;
    Cell  _cdr;
  }       _cons;
  opType  _proc;
} CellUnion;
struct cell{
  Type _type;
  CellUnion _object;
};

#define type(p)         ((p)->_type)
#define car(p)          ((p)->_object._cons._car)
#define cdr(p)          ((p)->_object._cons._cdr)
#define caar(p)         car(car(p))
#define cadr(p)         car(cdr(p))
#define cdar(p)         cdr(car(p))
#define cddr(p)         cdr(cdr(p))
#define cadar(p)        car(cdr(car(p)))
#define caddr(p)        car(cdr(cdr(p)))
#define cadaar(p)       car(cdr(car(car(p))))
#define cadddr(p)       car(cdr(cdr(cdr(p))))
#define cddddr(p)       cdr(cdr(cdr(cdr(p))))

#define chvalue(p)      ((p)->_object._char)
#define strvalue(p)     ((p)->_object._string)
#define ivalue(p)       ((p)->_object._integer)
#define procvalue(p)    ((p)->_object._proc)
#define syntaxvalue(p)  ((p)->_object._proc)
#define symbolname(p)   strvalue(p)
#define lambdaparam(p)  car(p)
#define lambdaexp(p)    cdr(p)

Cell newCell(Type t);

#define isNone(p)       ((p)->_type==T_NONE)
#define isChar(p)       ((p)->_type==T_CHAR)
#define isString(p)     ((p)->_type==T_STRING)
#define isInteger(p)    ((p)->_type==T_INTEGER)
#define isPair(p)       ((p)->_type==T_PAIR)
#define isSymbol(p)     ((p)->_type==T_SYMBOL)
#define isProc(p)       ((p)->_type==T_PROC)
#define isSyntax(p)     ((p)->_type==T_SYNTAX)
#define isLambda(p)     ((p)->_type==T_LAMBDA)
void setString(Cell c, char* str);

Cell apply(Cell c);
Cell clone(Cell c);
void set(Cell src, Cell dst);

Cell charCell(char ch);
Cell stringCell(char* str);
Cell intCell(int val);
Cell pairCell(Cell a, Cell d);
Cell procCell(opType proc);
Cell syntaxCell(opType syn);
Cell symbolCell(char* name);
Cell lambdaCell(Cell param, Cell exp);

int isdigitstr(char* str);
int nullp(Cell c);
int truep(Cell c);
int notp(Cell c);
int eofp(Cell c);
int zerop(Cell c);
int eqdigitp(Cell c);
int length(Cell ls);
Cell setAppendCell(Cell ls, Cell c);
Cell setAppendList(Cell ls, Cell append);
Cell reverseList(Cell ls);
Cell applyList(Cell ls);

void printPair(Cell c);
void printCell(Cell c);
void printLineCell(Cell c);
char* readTokenInDQuot();
char* readToken();
Cell readList();
Cell readQuot();
Cell tokenToCell();
Cell readElem();

Cell evalExp(Cell exp);
void letParam(Cell exp, Cell dummyParams, Cell realParams);
Cell findParam(Cell exp, Cell dummyParams, Cell realParams);

Cell T, F, NIL, UNDEF, EOFobj;

Cell argsReg;
Cell retReg;
#define ENVSIZE 30000
Cell env[ENVSIZE];
#define LINESIZE 1024
char errorString[LINESIZE];
int errorNo = 0;
enum ErrorNo{
  NONE_ERR,
  PARSE_ERR,
  EOF_ERR,
};
//Cell[char[]] env;
//Cell[char[]] letenv;

void init();
int hash(char* key);
Cell getVar(char* name);
void setVar(char* name, Cell c);
Cell popArg();
void pushArg(Cell c);
void dupArg();
void exchArg();
void clearArgs();
void callProc(char* name);
Cell getReturn();
void setReturn(Cell c);
void setParseError(char* errorStr);
void setEOFException(char* str);
void clearError();

void op_nullp();
void op_notp();
void op_eofp();
void op_zerop();
void op_eqdigitp();
void op_car();
void op_cdr();
void op_cons();
void op_list();
void op_add();
void op_sub();
void op_mul();
void op_div();
void op_append();
void op_reverse();
void op_eval();
void op_read();
void op_print();
void syntax_define();
void syntax_ifelse();
void syntax_lambda();
void syntax_quote();
void syntax_set();
void syntax_begin();

int repl();
