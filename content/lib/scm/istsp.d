import std.stdio;
import std.ctype;
import std.string;

alias void delegate() opType;
enum Type
{
  T_NONE,
  T_CHAR,
  T_STRING,
  T_INTEGER,
  T_CONS,
  T_PROC,
  T_SYNTAX,
  T_SYMBOL,
  T_LAMBDA,
}
class EOFException: Exception
{
  this(char[] msg)
  {
    super(msg);
  }
}
class ParseErrorException: Exception
{
  this(char[] msg)
  {
    super(msg);
  }
}
class Cons
{
  Cell _car, _cdr;
  this(Cell a, Cell d)
  {
    _car = a;
    _cdr = d;
  }
  void setcar(Cell a)
  {
    _car = a;
  }
  void setcdr(Cell d)
  {
    _cdr = d;
  }
  Cell car()
  {
    return _car;
  }
  Cell cdr()
  {
    return _cdr;
  }
}
union CellUnion
{
  char  _char;
  char[]  _string;
  int     _integer;
  Cons    _cons;
  opType _proc;
}
class Cell
{
  Type _type;
  CellUnion _object;
  this()
  {
    _type = Type.T_NONE;
  }
  void setType(Type t)
  {
    _type = t;
  }
  Type getType()
  {
    return _type;
  }
  bool isChar()
  {
    return _type == Type.T_CHAR;
  }
  bool isString()
  {
    return _type == Type.T_STRING;
  }
  bool isInteger()
  {
    return _type == Type.T_INTEGER;
  }
  bool isCons()
  {
    return _type == Type.T_CONS;
  }
  bool isSymbol()
  {
    return _type == Type.T_SYMBOL;
  }
  bool isProc()
  {
    return _type == Type.T_PROC;
  }
  bool isSyntax()
  {
    return _type == Type.T_SYNTAX;
  }
  bool isLambda()
  {
    return _type == Type.T_LAMBDA;
  }
  void setChar(char cvalue)
  {
    _object._char = cvalue;
  }
  void setString(char[] svalue)
  {
    _object._string = svalue;
  }
  char getChar()
  {
    return _object._char;
  }
  char[] getString()
  {
    return _object._string;
  }
  void setInteger(int ivalue)
  {
    _object._integer = ivalue;
  }
  int getInteger()
  {
    return _object._integer;
  }
  Cell apply()
  {
    return this;
  }
  void setcar(Cell a)
  {
    _object._cons.setcar(a);
  }
  Cell car()
  {
    return _object._cons.car();
  }
  void setcdr(Cell d)
  {
    _object._cons.setcdr(d);
  }
  Cell cdr()
  {
    return _object._cons.cdr();
  }
  Cell caar()
  {
    return _object._cons.car().car();
  }
  Cell cadr()
  {
    return _object._cons.cdr().car();
  }
  Cell cdar()
  {
    return _object._cons.car().cdr();
  }
  Cell cddr()
  {
    return _object._cons.cdr().cdr();
  }
  Cell clone()
  {
    Cell carCell = car();
    if(carCell.isCons() || carCell.isLambda()){
      carCell = carCell.clone();
    }
    if(cdr() == NIL){
      return new ConsCell(carCell, NIL);
    }
    else{
      return new ConsCell(carCell, cdr().clone());
    }
  }
  void setProc(opType p)
  {
    _object._proc = p;
  }
  opType getProc()
  {
    return _object._proc;
  }
  void setSyntax(opType p)
  {
    _object._proc = p;
  }
  opType getSyntax()
  {
    return _object._proc;
  }
  void set(Cell dst)
  {
    if(dst.isSymbol()){
      dst = machine.getSymbol(dst);
    }
    setType(dst.getType());
    switch(getType()){
      case Type.T_CHAR:
        setChar(dst.getChar());
        break;
      case Type.T_STRING:
        setString(dst.getString());
        break;
      case Type.T_INTEGER:
        setInteger(dst.getInteger());
        break;
      case Type.T_CONS:
        setcar(dst.car());
        setcdr(dst.cdr());
        break;
      case Type.T_PROC:
        setProc(dst.getProc());
        break;
      case Type.T_SYNTAX:
        setSyntax(dst.getSyntax());
        break;
      case Type.T_LAMBDA:
        setcar(dst.car());
        setcdr(dst.cdr());
        break;
      default:
      case Type.T_SYMBOL:
        throw new ParseErrorException("in set! operation");
    }
  }
}
class CharCell : Cell
{
  this(char cvalue)
  {
    _type = Type.T_CHAR;
    _object._char = cvalue;
  }
}
class StrCell : Cell
{
  this(char[] svalue)
  {
    _type = Type.T_STRING;
    _object._string = svalue;
  }
}
class IntCell : Cell
{
  this(int ivalue)
  {
    _type = Type.T_INTEGER;
    _object._integer = ivalue;
  }
}
class ConsCell : Cell
{
  this(Cell a, Cell b)
  {
    _type = Type.T_CONS;
    _object._cons = new Cons(a, b);
  }
  Cell apply()
  {
    if(isCons){
      return evalExp(this);
    }
    else{
      return this;
    }
  }
}
class ProcCell : Cell
{
  this(opType p)
  {
    _type = Type.T_PROC;
    _object._proc = p;
  }
}
class SyntaxCell : Cell
{
  this(opType p)
  {
    _type = Type.T_SYNTAX;
    _object._proc = p;
  }
}
class SymbolCell : Cell
{
  this(char[] symbol)
  {
    _type = Type.T_SYMBOL;
    _object._string = symbol;
  }
  Cell apply()
  {
    return machine.getSymbol(getString());
  }
}
class LambdaCell : Cell
{
  this(Cell params, Cell exps)
  {
    _type = Type.T_LAMBDA;
    _object._cons = new Cons(params, exps);
  }
}

bool isdigitstr(char[] str)
{
  for(int i=0;i<str.length;++i){
    if(!isdigit(str[i])){
      if(str.length < 2 || i!=0 ||
          (str[0] != '-' && str[0] != '+')) return false;
    }
  }
  return true;
}
bool nullp(Cell c)
{
  return c==NIL?true:false;
}
bool truep(Cell c)
{
  return c==T?true:false;
}
bool notp(Cell c)
{
  return c==F?true:false;
}
bool eofp(Cell c)
{
  return c==EOFobj?true:false;
}
bool zerop(Cell c)
{
  return c.getInteger()==0?true:false;
}
int listLength(Cell ls)
{
  int length = 0;
  for(;ls!=NIL;ls=ls.cdr()){
    ++length;
  }
  return length;
}
Cell setAppendCell(Cell ls, Cell c)
{
  if(nullp(ls)){
    if(nullp(c)){
      return ls;
    }
    else{
      return new ConsCell(c, NIL);
    }
  }
  Cell cdr = ls;
  while(cdr.cdr()!=NIL){
    cdr = cdr.cdr();
  }
  cdr.setcdr(new ConsCell(c, NIL));
  return ls;
}
Cell setAppendList(Cell ls, Cell append)
{
  if(nullp(ls)){
    return append;
  }
  Cell cdr = ls;
  while(cdr.cdr()!=NIL){
    cdr = cdr.cdr();
  }
  cdr.setcdr(append);
  return ls;
}
Cell mkReverseList(Cell ls)
{
  Cell reverse = NIL;
  for(;!nullp(ls);ls=ls.cdr()){
    reverse = new ConsCell(ls.car(), reverse);
  }
  return reverse;
}
Cell applyList(Cell ls)
{
  if(nullp(ls)) return ls;
  Cell applyCar = ls.car().apply();
  return new ConsCell(applyCar, applyList(ls.cdr()));
}
void printCons(Cell c)
{
  writef("(");
  while(c.cdr().isCons()){
    printCell(c.car());
    writef(" ");
    c = c.cdr();
  }
  printCell(c.car());
  if(!nullp(c.cdr())){
    writef(" . ");
    printCell(c.cdr());
  }
  writef(")");
}
void printCell(Cell c)
{
  switch(c.getType()){
    case Type.T_NONE:
      if(c == T){
        writef("#t");
      }
      else if(c == F){
        writef("#f");
      }
      else if(c == NIL){
        writef("()");
      }
      else if(c == UNDEF){
        writef("#undef");
      }
      else if(c == EOFobj){
        writef("#<eof>");
      }
      else{
        fwritefln(stderr, "\nunknown cell");
      }
      break;
    case Type.T_CHAR:
      writef("#\\%s", c.getChar());
      break;
    case Type.T_STRING:
      writef("\"%s\"", c.getString());
      break;
    case Type.T_INTEGER:
      writef("%d", c.getInteger());
      break;
    case Type.T_PROC:
      writef("#proc");
      break;
    case Type.T_SYNTAX:
      writef("#syntax");
      break;
    case Type.T_SYMBOL:
      writef("%s", c.getString());
      break;
    case Type.T_CONS:
      printCons(c);
      break;
    case Type.T_LAMBDA:
      writef("#closure");
      break;
    default:
      fwritefln(stderr, "\nunknown cell");
      break;
  }
}
char[] readTokenInDQuot()
{
  char[] str = "\"";
  int prev = EOF;
  GETCLoop:
  while(true){
    int c = getchar();
    switch(c){
      case '"':
        if(prev!='\\'){
          str ~= c;
          break GETCLoop;
        }
        else{
          str ~= c;
          break;
        }
      case EOF:
        throw new EOFException("End Of File");
      default:
        str ~= c;
        prev = c;
        break;
    }
  }
  return str;
}
char[] readToken()
{
  char[] token = [];
  GETCLoop:
  while(true){
    int c = getchar();
    switch(c){
      case '(':
      case ')':
      case '\'':
        if(token.length > 0){
          ungetc(c, stdin);
          break GETCLoop;
        }
        return "" ~ cast(char)c;
      case '"':
        if(token.length > 0){
          ungetc(c, stdin);
          break GETCLoop;
        }
        return readTokenInDQuot();
      case ' ':
      case '\t':
      case '\n':
        if(token.length > 0){
          break GETCLoop;
        }
        break;
      case EOF:
        throw new EOFException("End Of File");
      default:
        token ~= c;
        break;
    }
  }
  return token;
}
Cell readList()
{
  Cell list = NIL;
  char c;
  while(true){
    c = getchar();
    if(c==')'){
      break;
    }
    else if(c=='.'){
      Cell cdr = readElem();
      list = setAppendList(list, cdr);
      char[] endParen = readToken();
      if(endParen!=")"){
        throw new ParseErrorException("unknown token after '.'");
      }
      break;
    }
    ungetc(c, stdin);
    Cell exp = readElem();
    list = setAppendCell(list, exp);
  }
  return list;
}
Cell readQuot()
{
  Cell quot = NIL;
  quot = setAppendCell(quot, new SymbolCell("quote"));
  quot = setAppendCell(quot, readElem());
  return quot;
}
Cell tokenToCell(char[] token)
{
  if(isdigitstr(token)){
    int digit = cast(int)atoi(token);
    return new IntCell(digit);
  }
  else if(token[0] == '"'){
    return new StrCell(token[1..$-1]);
  }
  else if(token[0] == '#'){
    if(token[1] == '\\' && token.length==3){
      return new CharCell(token[2]);
    }
    else{
      return new SymbolCell(token);
    }
  }
  else{
    return new SymbolCell(token);
  }
}
Cell readElem()
{
  try{
    char[] token = readToken();
    if(token=="("){
      Cell list = readList();
      return list;
    }
    else if(token=="'"){
      Cell quot = readQuot();
      return quot;
    }
    else{
      Cell exp = tokenToCell(token);
      return exp;
    }
  }
  catch(EOFException e){
    return EOFobj;
  }
}
Cell evalExp(Cell exp)
{
  Cell proc = exp.car().apply();
  Cell args = exp.cdr();
  opType operator;
  if(proc.isProc()){
    operator = proc.getProc();
    args = applyList(args);
  }
  else if(proc.isSyntax()){
    operator = proc.getSyntax();
  }
  else if(proc.isLambda()){
    Cell params = proc.car();
    Cell exps = proc.cdr();
    if(listLength(args) != listLength(params)){
      fwritefln(stderr, "wrong number arguments");
      return(UNDEF);
    }
    else{
      args = applyList(args);
      exps = exps.clone();
      applyLambdaExps(exps, params, args);
      while(true){
        Cell ret = exps.car().apply();
        if(nullp(exps.cdr())) return ret;
        exps = exps.cdr();
      }
    }
  }
  else{
    fwritefln(stderr, "%s is not proc", exp.car().getString());
    return(UNDEF);
  }
  machine.unshiftArg(args);
  operator();
  return machine.getReturn();
}
void applyLambdaExps(Cell exps, Cell dummyParams, Cell realParams)
{
  for(;!nullp(exps);exps=exps.cdr()){
    Cell exp = exps.car();
    if(exp.isSymbol()){
      Cell realCell = findInParams(exp.getString(), dummyParams, realParams);
      if(!(realCell is null)){
        exps.setcar(realCell);
      }
    }
    else if(exp.isCons()){
      applyLambdaExps(exp, dummyParams, realParams);
    }
  }
}
Cell findInParams(char[] key, Cell dummyParams, Cell realParams)
{
  while(!nullp(dummyParams)){
    if(key == dummyParams.car().getString()){
      return realParams.car();
    }
    dummyParams = dummyParams.cdr();
    realParams = realParams.cdr();
  }
  return null;
}

class Machine 
{
  opType[char[]] symTable;
  Cell argsReg;
  Cell retReg;
  Cell codeReg;
  Cell[char[]] env;
  //Cell[char[]] letenv;
  this()
  {
    argsReg = NIL;
    retReg = NIL;
    codeReg = NIL;

    setSymbol("nil", NIL);
    setSymbol("#t", T);
    setSymbol("#f", F);

    setSymbol("null?", new ProcCell(&op_nullp));
    setSymbol("not", new ProcCell(&op_notp));
    setSymbol("eof?", new ProcCell(&op_eofp));
    setSymbol("zero?", new ProcCell(&op_zerop));
    setSymbol("car", new ProcCell(&op_car));
    setSymbol("cdr", new ProcCell(&op_cdr));
    setSymbol("cons", new ProcCell(&op_cons));
    setSymbol("list", new ProcCell(&op_list));
    setSymbol("+", new ProcCell(&op_add));
    setSymbol("-", new ProcCell(&op_sub));
    setSymbol("*", new ProcCell(&op_mul));
    setSymbol("/", new ProcCell(&op_div));
    setSymbol("append", new ProcCell(&op_append));
    setSymbol("reverse", new ProcCell(&op_reverse));
    setSymbol("eval", new ProcCell(&op_eval));
    setSymbol("read", new ProcCell(&op_read));
    setSymbol("print", new ProcCell(&op_print));

    setSymbol("define", new SyntaxCell(&syntax_define));
    setSymbol("if", new SyntaxCell(&syntax_ifelse));
    setSymbol("lambda", new SyntaxCell(&syntax_lambda));
    setSymbol("quote", new SyntaxCell(&syntax_quote));
    setSymbol("set!", new SyntaxCell(&syntax_set));
    //setSymbol("", new ProcCell(&op_));
  }
  void setSymbol(char[] symbol, Cell c)
  {
    env[symbol] = c;
  }
  //void letSymbol(char[] symbol, Cell c)
  //{
  //  letenv[symbol] = c;
  //}
  Cell getSymbol(Cell c)
  {
    return getSymbol(c.getString());
  }
  Cell getSymbol(char[] symbol)
  {
    /*if(symbol in letenv){
      return letenv[symbol];
      }
      else*/ if(symbol in env){
        return env[symbol];
      }
      fwritefln(stderr, "%s is unbound variable", symbol);
      return UNDEF;
  }
  Cell shiftArg()
  {
    Cell c = argsReg.car();
    argsReg = argsReg.cdr();
    return c;
  }
  void unshiftArg(Cell c)
  {
    argsReg = new ConsCell(c, argsReg);
  }
  void dupArg()
  {
    Cell first = shiftArg();
    unshiftArg(first);
    unshiftArg(first);
  }
  void exchArg()
  {
    Cell first = shiftArg();
    Cell second = shiftArg();
    unshiftArg(first);
    unshiftArg(second);
  }
  void clearArgs()
  {
    argsReg = NIL;
  }
  void callProc(char[] symbol)
  {
    Cell proc = getSymbol(symbol);
    if(proc.isProc()){
      opType operator = proc.getProc();
      operator();
    }
    else{
      fwritefln(stderr, "%s is unknown proc", symbol);
    }
  }
  void setReturn(Cell c)
  {
    retReg = new ConsCell(c, NIL);
  }
  Cell getReturn()
  {
    return retReg.car();
  }

  private:
  void op_unknown()
  {
    setReturn(UNDEF);
  }
  void op_nullp()
  {
    Cell args = shiftArg();
    if(nullp(args.car())){
      setReturn(T);
    }
    else{
      setReturn(F);
    }
  }
  void op_notp()
  {
    Cell args = shiftArg();
    if(notp(args.car())){
      setReturn(T);
    }
    else{
      setReturn(F);
    }
  }
  void op_eofp()
  {
    Cell args = shiftArg();
    if(eofp(args.car())){
      setReturn(T);
    }
    else{
      setReturn(F);
    }
  }
  void op_zerop()
  {
    Cell args = shiftArg();
    if(zerop(args.car())){
      setReturn(T);
    }
    else{
      setReturn(F);
    }
  }
  void op_car()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    setReturn(first.car());
  }
  void op_cdr()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    setReturn(first.cdr());
  }
  void op_cons()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    Cell second = args.cadr();
    setReturn(new ConsCell(first, second));
  }
  void op_list()
  {
    Cell args = shiftArg();
    setReturn(args);
  }
  void op_add()
  {
    Cell args = shiftArg();
    int ans = 0;
    while(args != NIL){
      ans += args.car().getInteger();
      args = args.cdr();
    }
    setReturn(new IntCell(ans));
  }
  void op_mul()
  {
    Cell args = shiftArg();
    int ans = 1;
    while(args != NIL){
      ans *= args.car().getInteger();
      args = args.cdr();
    }
    setReturn(new IntCell(ans));
  }
  void op_sub()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    Cell list = args.cdr();
    int ans = first.getInteger();
    while(list != NIL){
      ans -= list.car().getInteger();
      list = list.cdr();
    }
    setReturn(new IntCell(ans));
  }
  void op_div()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    Cell list = args.cdr();
    int ans = first.getInteger();
    while(list != NIL){
      ans /= list.car().getInteger();
      list = list.cdr();
    }
    setReturn(new IntCell(ans));
  }
  void op_append()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    Cell second = args.cadr();
    Cell result = first.clone();
    setReturn(setAppendList(result, second));
  }
  void op_reverse()
  {
    Cell args = shiftArg();
    Cell reverse = mkReverseList(args);
    setReturn(reverse);
  }
  void op_read()
  {
    setReturn(readElem);
  }
  void op_eval()
  {
    Cell args = shiftArg();
    setReturn(args.car().apply());
  }
  void op_print()
  {
    Cell args = shiftArg();
    for(;!nullp(args);args=args.cdr()){
      Cell c = args.car();
      if(c.isString()){
        writef(c.getString());
      }
      else{
        printCell(c);
      }
    }
    writefln("");
    setReturn(UNDEF);
  }

  void syntax_define()
  {
    Cell args = shiftArg();
    Cell symbol = args.car();
    Cell obj = args.cadr();
    obj = obj.apply();
    setSymbol(symbol.getString(), obj);
    setReturn(obj);
  }
  void syntax_ifelse()
  {
    Cell args = shiftArg();
    Cell cond = args.car();
    Cell tpart = args.cadr();
    Cell fpart = args.cddr();
    cond = cond.apply();
    if(truep(cond)){
      tpart = tpart.apply();
      setReturn(tpart);
    }
    else{
      if(nullp(fpart)){
        setReturn(UNDEF);
      }
      else{
        fpart = fpart.car().apply();
        setReturn(fpart);
      }
    }
  }
  void syntax_lambda()
  {
    Cell args = shiftArg();
    Cell params = args.car();
    Cell exps = args.cdr();
    Cell lambda = new LambdaCell(params, exps);
    setReturn(lambda);
  }
  void syntax_quote()
  {
    setReturn(shiftArg().car());
  }
  void syntax_set()
  {
    Cell args = shiftArg();
    Cell first = args.car();
    Cell second = args.cadr();
    Cell source = first.apply();
    //if(source!=UNDEF){
      source.set(second);
      printCell(source);
      writefln("");
    //}
    setReturn(UNDEF);
  }
}
void init()
{
  NIL = new ConsCell(NIL, NIL);
  NIL.setType(Type.T_NONE);

  T = new ConsCell(T, T);
  T.setType(Type.T_NONE);

  F = new ConsCell(F, F);
  F.setType(Type.T_NONE);

  UNDEF = new ConsCell(UNDEF, UNDEF);
  UNDEF.setType(Type.T_NONE);

  EOFobj = new ConsCell(EOFobj, EOFobj);
  EOFobj.setType(Type.T_NONE);

  machine = new Machine;

}
int repl()
{
  while(true){
    fwritef(stderr, "> ");
    machine.clearArgs();
    machine.callProc("read");
    Cell c = machine.getReturn();
    machine.unshiftArg(new ConsCell(c, NIL));
    machine.dupArg();
    machine.callProc("eof?");
    Cell iseof = machine.getReturn();
    if(truep(iseof)) break;
    machine.callProc("eval");
    printCell(machine.getReturn());
    writefln("");
  }
  writefln("Good-bye");
  return 0;
}
Cell T, F, NIL, UNDEF, EOFobj;
Machine machine;
int main()
{
  init();
  repl();
  return 0;
}
