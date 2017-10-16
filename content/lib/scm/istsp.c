#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "istsp.h"

Cell newCell(Type t)
{
  Cell new = (Cell)malloc(sizeof(struct cell));
  new->_type = t;
  return new;
}
Cell charCell(char ch)
{
  Cell c = newCell(T_CHAR);
  chvalue(c) = ch;
  return c;
}
Cell stringCell(char* str)
{
  Cell c = newCell(T_STRING);
  strvalue(c) = (char*)malloc(sizeof(char)*strlen(str));
  strcpy(strvalue(c), str);
  return c;
}
Cell intCell(int val)
{
  Cell c = newCell(T_INTEGER);
  ivalue(c) = val;
  return c;
}
Cell pairCell(Cell a, Cell d)
{
  Cell cons = newCell(T_PAIR);
  car(cons) = a;
  cdr(cons) = d;
  return cons;
}
Cell procCell(opType proc)
{
  Cell c = newCell(T_PROC);
  procvalue(c) = proc;
  return c;
}
Cell syntaxCell(opType syntax)
{
  Cell c = newCell(T_SYNTAX);
  procvalue(c) = syntax;
  return c;
}
Cell symbolCell(char* symbol)
{
  Cell c = newCell(T_SYMBOL);
  symbolname(c) = (char*)malloc(sizeof(char)*strlen(symbol));
  strcpy(symbolname(c), symbol);
  return c;
}
Cell lambdaCell(Cell param, Cell exp)
{
  Cell c = newCell(T_LAMBDA);
  lambdaparam(c) = param;
  lambdaexp(c) = exp;
  return c;
}
void setString(Cell c, char* str)
{
  strvalue(c) = (char*)malloc(sizeof(char)*strlen(str));
  strcpy(strvalue(c), str);
}

Cell apply(Cell c)
{
  switch(type(c)){
    case T_SYMBOL:
      return getVar(symbolname(c));
    case T_PAIR:
      return evalExp(c);
    default:
      return c;
  }
  return c;
}
Cell clone(Cell src)
{
  Cell new = newCell(type(src));
  set(new, src);
  return new;
}
Cell cloneTree(Cell src)
{
  if(isPair(src)){
    return pairCell(cloneTree(car(src)), cloneTree(cdr(src)));
  }
  else if(isNone(src)){
    return src;
  }
  else{
    Cell new = newCell(type(src));
    set(new, src);
    return new;
  }
}
Cell cloneSymbolTree(Cell src)
{
  if(isPair(src)){
    return pairCell(cloneSymbolTree(car(src)), cloneSymbolTree(cdr(src)));
  }
  else if(isSymbol(src)){
    Cell new = newCell(type(src));
    set(new, src);
    return new;
  }
  else{
    return src;
  }
}
void set(Cell src, Cell dst)
{
  type(src) = type(dst);
  switch(type(src)){
    case T_CHAR:
      chvalue(src) = chvalue(dst);
      break;
    case T_STRING:
      setString(src, strvalue(dst));
      break;
    case T_INTEGER:
      ivalue(src) = ivalue(dst);
      break;
    case T_PAIR:
      car(src) = car(dst);
      cdr(src) = cdr(dst);
      break;
    case T_PROC:
      procvalue(src) = procvalue(dst);
      break;
    case T_SYNTAX:
      procvalue(src) = procvalue(dst);
      break;
    case T_LAMBDA:
      car(src) = car(dst);
      cdr(src) = cdr(dst);
      break;
    case T_SYMBOL:
      setString(src, strvalue(dst));
      break;
    default:
      setParseError("in set operation");
      break;
  }
}

Cell evalExp(Cell exp)
{
  Cell params, exps;
  Cell proc = apply(car(exp));
  Cell args = cdr(exp);
  opType operator;
  switch(type(proc)){
    case T_PROC:
      operator = procvalue(proc);
      args = applyList(args);
      break;
    case T_SYNTAX:
      operator = syntaxvalue(proc);
      break;
    case T_LAMBDA:
      params = lambdaparam(proc);
      exps = lambdaexp(proc);
      if(length(args) != length(params)){
        setParseError("wrong number arguments");
        return UNDEF;
      }
      args = applyList(args);
      args = cloneTree(args);
      exps = cloneSymbolTree(exps);
      letParam(exps, params, args);
      exps = pairCell(symbolCell("begin"), exps);
      set(exp, exps);
      return evalExp(exp);
    default:
      setParseError("not proc");
      return UNDEF;
  }
  pushArg(args);
  operator();
  return getReturn();
}
void letParam(Cell exp, Cell dummyParams, Cell realParams)
{
  if(nullp(exp)) return;
  else if(isPair(exp)){
    Cell carCell = car(exp);
    Cell cdrCell = cdr(exp);
    if(isPair(carCell)){
      letParam(carCell, dummyParams, realParams);
    }
    else if(isSymbol(carCell)){
      Cell find = findParam(carCell, dummyParams, realParams);
      if(find!=UNDEF){
        car(exp) = find;
      }
    }
    if(isPair(cdrCell)){
      letParam(cdrCell, dummyParams, realParams);
    }
    else if(isSymbol(cdrCell)){
      Cell find = findParam(cdrCell, dummyParams, realParams);
      if(find!=UNDEF){
        cdr(exp) = find;
      }
    }
  }
}
Cell findParam(Cell exp, Cell dummyParams, Cell realParams)
{
  char *var = symbolname(exp);
  while(!nullp(dummyParams)){
    char *key = strvalue(car(dummyParams));
    if(strcmp(var, key)==0){
      return car(realParams);
    }
    dummyParams = cdr(dummyParams);
    realParams = cdr(realParams);
  }
  return UNDEF;
}

int isdigitstr(char* str)
{
  int i;
  for(i=0;i<strlen(str);++i){
    if(!isdigit(str[i])){
      if(strlen(str) < 2 || i!=0 ||
          (str[0] != '-' && str[0] != '+')) return 0;
    }
  }
  return 1;
}
int nullp(Cell c)
{
  return c==NIL?1:0;
}
int truep(Cell c)
{
  return c==T?1:0;
}
int notp(Cell c)
{
  return c==F?1:0;
}
int eofp(Cell c)
{
  return c==EOFobj?1:0;
}
int zerop(Cell c)
{
  return ivalue(c)==0?1:0;
}
int length(Cell ls)
{
  int length = 0;
  for(;!nullp(ls);ls=cdr(ls)){
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
      return pairCell(c, NIL);
    }
  }
  Cell cdr = ls;
  while(!nullp(cdr(cdr))){
    cdr = cdr(cdr);
  }
  cdr(cdr) = pairCell(c, NIL);
  return ls;
}
Cell setAppendList(Cell ls, Cell append)
{
  if(nullp(ls)){
    return append;
  }
  Cell cdr = ls;
  while(!nullp(cdr(cdr))){
    cdr = cdr(cdr);
  }
  cdr(cdr) = append;
  return ls;
}
Cell reverseList(Cell ls)
{
  Cell reverse = NIL;
  for(;!nullp(ls);ls=cdr(ls)){
    reverse = pairCell(car(ls), reverse);
  }
  return reverse;
}
Cell applyList(Cell ls)
{
  if(nullp(ls)) return ls;
  Cell applyCar = apply(car(ls));
  return pairCell(applyCar, applyList(cdr(ls)));
}
void printCons(Cell c)
{
  printf("(");
  while(isPair(cdr(c))){
    printCell(car(c));
    printf(" ");
    c = cdr(c);
  }
  printCell(car(c));
  if(!nullp(cdr(c))){
    printf(" . ");
    printCell(cdr(c));
  }
  printf(")");
}
void printLineCell(Cell c)
{
  printCell(c);
  putchar('\n');
}
void printCell(Cell c)
{
  switch(type(c)){
    case T_NONE:
      if(c==T){
        printf("#t");
      }
      else if(c==F){
        printf("#f");
      }
      else if(c==NIL){
        printf("()");
      }
      else if(c==UNDEF){
        printf("#undef");
      }
      else if(c==EOFobj){
        printf("#<eof>");
      }
      else{
        setParseError("unknown cell");
      }
      break;
    case T_CHAR:
      printf("#\\%c", chvalue(c));
      break;
    case T_STRING:
      printf("\"%s\"", strvalue(c));
      break;
    case T_INTEGER:
      printf("%d", ivalue(c));
      break;
    case T_PROC:
      printf("#proc");
      break;
    case T_SYNTAX:
      printf("#syntax");
      break;
    case T_SYMBOL:
      printf("%s", symbolname(c));
      break;
    case T_PAIR:
      printCons(c);
      break;
    case T_LAMBDA:
      printf("#closure");
      break;
    default:
      fputs("\nunknown cell", stderr);
      break;
  }
#ifdef DEBUG
  printf("<%p>", c);
#endif
}
char* readTokenInDQuot(char* buf, int len)
{
  int prev = EOF;
  char *strp = buf;
  *strp = '"';
  for(++strp;(strp-buf)<len-1;++strp){
    int c = getchar();
    switch(c){
      case '"':
        if(prev!='\\'){
          *strp = c;
          goto BreakLoop;
        }
        else{
          *strp = c;
          break;
        }
      case EOF:
        setEOFException("End Of File");
        return NULL;
      default:
        *strp = c;
        prev = c;
        break;
    }
  }
BreakLoop:
  *strp = '\0';
  return buf;
}
char* readToken(char *buf, int len)
{
  char *token = buf;
  for(;(token-buf)<len-1;){
    int c = getchar();
    switch(c){
      case '(':
      case ')':
      case '\'':
        if(token-buf > 0){
          ungetc(c, stdin);
        }
        else{
          *token = c;
          ++token;
        }
        *token = '\0';
        return buf;
      case '"':
        if(token-buf > 0){
          ungetc(c, stdin);
          *token = '\0';
          return buf;
        }
        return readTokenInDQuot(buf, len);
      case ' ':
      case '\t':
      case '\n':
        if(token-buf > 0){
          *token = '\0';
          return buf;
        }
        break;
      case EOF:
        setEOFException("Enf Of File");
        return NULL;
      default:
        *token = c;
        ++token;
        break;
    }
  }
  *token = '\0';
  return buf;
}
Cell readList()
{
  Cell list = NIL;
  char c;
  char buf[LINESIZE];
  while(1){
    Cell exp;
    c = getchar();
    switch(c){
      case ')':
        return list;
      case '.':
        exp = readElem();
        list = setAppendList(list, exp);
        readToken(buf, sizeof(buf));
        if(strcmp(buf, ")")!=0){
          setParseError("unknown token after '.'");
          return NULL;
        }
        return list;
      case EOF:
        setEOFException("EOF");
        return NULL;
      default:
        ungetc(c, stdin);
        exp = readElem();
        list = setAppendCell(list, exp);
        break;
    }
  }
  return list;
}
Cell readQuot()
{
  Cell quot = NIL;
  quot = setAppendCell(quot, symbolCell("quote"));
  quot = setAppendCell(quot, readElem());
  return quot;
}
Cell tokenToCell(char* token)
{
  if(isdigitstr(token)){
    int digit = atoi(token);
    return intCell(digit);
  }
  else if(token[0] == '"'){
    return stringCell(token+1);
  }
  else if(token[0] == '#'){
    if(token[1] == '\\' && strlen(token)==3){
      return charCell(token[2]);
    }
    else{
      return symbolCell(token);
    }
  }
  else{
    return symbolCell(token);
  }
}
Cell readElem()
{
  Cell elem;
  char buf[LINESIZE];
  char* token = readToken(buf, sizeof(buf));
  if(token==NULL){
    elem = NULL;
  }
  else if(token[0]=='('){
    elem = readList();
  }
  else if(token[0]=='\''){
    elem = readQuot();
  }
  else{
    elem = tokenToCell(token);
  }

  if(elem==NULL){
    int err = errorNo;
    clearError();
    if(err==EOF_ERR){
      return EOFobj;
    }
    else{
      return NULL;
    }
  }
  return elem;
}

int hash(char* key)
{
  int val = 0;
  for(;*key!='\0';++key){
    val = val*256 + *key;
  }
  return val;
}
Cell getVar(char* name)
{
  int key = hash(name)%ENVSIZE;
  Cell chain = env[key];
  if(chain==NULL || nullp(chain)) return UNDEF;
  while(strcmp(name, strvalue(caar(chain)))!=0){
    if(nullp(cdr(chain))){
      return UNDEF;
    }
    chain = cdr(chain);
  }
  return cdar(chain);
}
void setVar(char* name, Cell c)
{
  int key = hash(name)%ENVSIZE;
  Cell nameCell = stringCell(name);
  Cell chain = env[key], entry;
  if(env[key]==NULL){
    chain = env[key] = NIL;
  }
  while(!nullp(chain) && strcmp(name, strvalue(caar(chain)))!=0){
    chain = cdr(chain);
  }
  entry = pairCell(nameCell, c);
  if(!nullp(chain)){
    car(chain) = entry;
  }
  else{
    env[key] = pairCell(entry, env[key]);
  }
}
Cell popArg()
{
  Cell c = car(argsReg);
  argsReg = cdr(argsReg);
  return c;
}
void pushArg(Cell c)
{
  argsReg = pairCell(c, argsReg);
}
void dupArg()
{
  Cell c = popArg();
  pushArg(c);
  pushArg(c);
}
void exchArg()
{
  Cell c1 = popArg();
  Cell c2 = popArg();
  pushArg(c1);
  pushArg(c2);
}
void clearArgs()
{
  argsReg = NIL;
}
void callProc(char* name)
{
  Cell proc = getVar(name);
  if(isProc(proc)){
    opType op = procvalue(proc);
    op();
  }
  else{
    setParseError("unknown proc");
  }
}
Cell getReturn()
{
  return car(retReg);
}
void setReturn(Cell c)
{
  retReg = pairCell(c, NIL);
}
void setParseError(char* str)
{
  errorNo = PARSE_ERR;
  strcpy(errorString, str);
}
void setEOFException(char* str)
{
  errorNo = EOF_ERR;
  strcpy(errorString, str);
}
int getErrorNo()
{
  return errorNo;
}
void clearError()
{
  errorNo = NONE_ERR;
  errorString[0] = '\0';
}

void init()
{
  NIL = pairCell(NIL, NIL);
  type(NIL) = T_NONE;

  T = pairCell(T, T);
  type(T) = T_NONE;

  F = pairCell(F, F);
  type(F) = T_NONE;

  UNDEF = pairCell(UNDEF, UNDEF);
  type(UNDEF) = T_NONE;

  EOFobj = pairCell(EOFobj, EOFobj);
  EOFobj = T_NONE;

  argsReg = retReg = NIL;

  memset(env, 0, ENVSIZE);


  setVar("nil", NIL);
  setVar("#t", T);
  setVar("#f", F);

  setVar("null?",   procCell(op_nullp));
  setVar("not",     procCell(op_notp));
  setVar("eof?",    procCell(op_eofp));
  setVar("zero?",   procCell(op_zerop));
  setVar("=",       procCell(op_eqdigitp));
  setVar("car",     procCell(op_car));
  setVar("cdr",     procCell(op_cdr));
  setVar("cons",    procCell(op_cons));
  setVar("list",    procCell(op_list));
  setVar("+",       procCell(op_add));
  setVar("-",       procCell(op_sub));
  setVar("*",       procCell(op_mul));
  setVar("/",       procCell(op_div));
  setVar("append",  procCell(op_append));
  setVar("reverse", procCell(op_reverse));
  setVar("eval",    procCell(op_eval));
  setVar("read",    procCell(op_read));
  setVar("print",   procCell(op_print));

  setVar("define",  syntaxCell(syntax_define));
  setVar("if",      syntaxCell(syntax_ifelse));
  setVar("lambda",  syntaxCell(syntax_lambda));
  setVar("quote",   syntaxCell(syntax_quote));
  setVar("set!",    syntaxCell(syntax_set));
  setVar("begin",   syntaxCell(syntax_begin));
}
void op_unknown()
{
  setReturn(UNDEF);
}
void op_nullp()
{
  Cell args = popArg();
  if(nullp(car(args))){
    setReturn(T);
  }
  else{
    setReturn(F);
  }
}
void op_notp()
{
  Cell args = popArg();
  if(notp(car(args))){
    setReturn(T);
  }
  else{
    setReturn(F);
  }
}
void op_eofp()
{
  Cell args = popArg();
  if(eofp(car(args))){
    setReturn(T);
  }
  else{
    setReturn(F);
  }
}
void op_zerop()
{
  Cell args = popArg();
  if(zerop(car(args))){
    setReturn(T);
  }
  else{
    setReturn(F);
  }
}
void op_eqdigitp()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell c2 = cadr(args);
  int i1 = ivalue(apply(c1));
  int i2 = ivalue(apply(c2));
  if(i1==i2){
    setReturn(T);
  }
  else{
    setReturn(F);
  }
}
void op_car()
{
  Cell args = popArg();
  Cell c1 = car(args);
  setReturn(car(c1));
}
void op_cdr()
{
  Cell args = popArg();
  Cell c1 = car(args);
  setReturn(cdr(c1));
}
void op_cons()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell c2 = cadr(args);
  setReturn(pairCell(c1, c2));
}
void op_list()
{
  Cell args = popArg();
  setReturn(args);
}
void op_add()
{
  Cell args = popArg();
  int ans = 0;
  while(args != NIL){
    ans += ivalue(car(args));
    args = cdr(args);
  }
  setReturn(intCell(ans));
}
void op_mul()
{
  Cell args = popArg();
  int ans = 1;
  while(args != NIL){
    ans *= ivalue(car(args));
    args = cdr(args);
  }
  setReturn(intCell(ans));
}
void op_sub()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell list = cdr(args);
  int ans = ivalue(c1);
  while(list != NIL){
    ans -= ivalue(car(list));
    list = cdr(list);
  }
  setReturn(intCell(ans));
}
void op_div()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell list = cdr(args);
  int ans = ivalue(c1);
  while(list != NIL){
    ans /= ivalue(car(list));
    list = cdr(list);
  }
  setReturn(intCell(ans));
}
void op_append()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell c2 = cadr(args);
  Cell result = clone(c1);
  setReturn(setAppendList(result, c2));
}
void op_reverse()
{
  Cell args = popArg();
  Cell reverse = reverseList(args);
  setReturn(reverse);
}
void op_read()
{
  setReturn(readElem());
}
void op_eval()
{
  Cell args = popArg();
  setReturn(apply(car(args)));
  if(errorNo==PARSE_ERR){
    fprintf(stderr, "%s\n", errorString);
    setReturn(UNDEF);
  }
}
void op_print()
{
  Cell args = popArg();
  for(;!nullp(args);args=cdr(args)){
    Cell c = car(args);
    if(isString(c)){
      fputs(strvalue(c), stdout);
    }
    else{
      printCell(c);
    }
  }
  puts("");
  setReturn(UNDEF);
}

void syntax_define()
{
  Cell args = popArg();
  Cell symbol = car(args);
  Cell obj = cadr(args);
  obj = apply(obj);
  setVar(symbolname(symbol), obj);
  setReturn(obj);
}
void syntax_ifelse()
{
  Cell args = popArg();
  Cell cond = car(args);
  Cell tpart = cadr(args);
  Cell fpart = cddr(args);
  cond = apply(cond);
  if(truep(cond)){
    tpart = apply(tpart);
    setReturn(tpart);
  }
  else{
    if(nullp(fpart)){
      setReturn(UNDEF);
    }
    else{
      fpart = apply(car(fpart));
      setReturn(fpart);
    }
  }
}
void syntax_lambda()
{
  Cell args = popArg();
  Cell params = car(args);
  Cell exps = cdr(args);
  Cell lambda = lambdaCell(params, exps);
  setReturn(lambda);
}
void syntax_quote()
{
  setReturn(car(popArg()));
}
void syntax_set()
{
  Cell args = popArg();
  Cell c1 = car(args);
  Cell c2 = cadr(args);
  Cell src = apply(c1);
  set(src, apply(c2));
  setReturn(src);
}
void syntax_begin()
{
  Cell args = popArg();
  for(;!nullp(cdr(args));args=cdr(args)){
    apply(car(args));
  }
  setReturn(apply(car(args)));
}

int repl()
{
  while(1){
    Cell ret;
    fputs("> ", stderr);
    clearArgs();
    callProc("read");
    ret = getReturn();
    if(ret==EOFobj) break;
    pushArg(pairCell(ret, NIL));
    dupArg();
    callProc("eof?");
    ret = getReturn();
    if(truep(ret)) break;
    callProc("eval");
    printLineCell(getReturn());
  }
  fputs("Good-bye\n", stdout);
  return 0;
}
int main(int argc, char *argv[])
{
  init();
  repl();
  return 0;
}
