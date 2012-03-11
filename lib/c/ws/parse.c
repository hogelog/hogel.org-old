#include "wspace.h"

#define RETURN_ERROR(ch,stream,fname) do { \
  fprintf(stderr, "error in " fname "\n"); \
  ungetc((ch), (stream)); \
  return ERROR; \
} while(0)
#define RETURN_CODE(stream,ch,fname,code) do {\
  if(code == ERROR) RETURN_ERROR(ch, stream, fname); \
  else return code; \
} while(0)
#include "gencode.c"

int make_Number(int pow, int acc) {
  int sign = 1-2*(acc&1);
  int num = 0;
  for(pow=pow>>1, acc=acc>>1;pow!=0;pow=pow>>1, acc=acc>>1) {
    num = (num<<1)|(acc&1);
  }
  return sign*num;
}
unsigned int read_Number_AB(FILE *input, int pow, int acc) {
  int ch = getc(input);
  switch(ch) {
    case A:
      return read_Number_AB(input, pow<<1, acc);
    case B:
      return read_Number_AB(input, pow<<1, acc|pow);
    case C:
    case EOF:
      return make_Number(pow>>1, acc);
    default:
      return read_Number_AB(input, pow, acc);
  }
}
int read_Number(FILE *input) {
  int ch = getc(input);
  switch(ch) {
    case A:
    case B:
      ungetc(ch, input);
      return read_Number_AB(input, 1, 0);
    case C:
      return 0;
    case EOF:
      RETURN_ERROR(EOF, input, "read_Number");
    default:
      return read_Number(input);
  }
}
int read_String_AB(FILE *input, char *buf, int len) {
  int ch = getc(input);
  switch(ch) {
    case A:
    case B:
      if(len>=MAX_LABEL_SIZE) {
        fputs("too big label", stderr);
        exit(1);
      }
      buf[len] = ch;
      return read_String_AB(input, buf, len+1);
    case C:
      buf[len] = '\0';
      return len;
    case EOF:
      RETURN_ERROR(EOF, input, "read_String_AB");
    default:
      return read_String_AB(input, buf, len);
  }
}
char *read_String(FILE *input) {
  char buf[MAX_LABEL_SIZE] = "";
  int ch = getc(input);
  int size;
  switch(ch) {
    case A:
    case B:
      buf[0] = ch;
      size = read_String_AB(input, buf, 1);
      return strndup(buf, size);
    case C:
      return strndup(buf, 1);
    case EOF:
      fputs("error in read_String\n", stderr);
      exit(1);
    default:
      size = read_String_AB(input, buf, 0);
      return strndup(buf, size);
  }
}
Program* read_Program(Program *program, FILE *input) {
  int ch, chCount = 0, opCount = 0;
  Operation op;
  while(PROGRAM_FULL(program) || (ch=getc(input))!=EOF) {
    ++chCount;
    switch(ch) {
      case A:
        op = read_A(input);
        break;
      case B:
        op = read_B(input);
        break;
      case C:
        op = read_C(input);
        break;
      default:
        op = COMMENT;
        break;
    }
    switch(op) {
      case ERROR:
        fprintf(stderr, "error at %d byte\n", chCount);
        exit(1);
      case PUSH:
      case REF:
      case SLIDE:
        PROGRAM_PUSH_OP(program, op);
        ++opCount;
        PROGRAM_PUSH_NUM(program, read_Number(input));
        break;
      case LABEL:
      case CALL:
      case JUMP:
      case IZ_JUMP:
      case IN_JUMP:
        PROGRAM_PUSH_OP(program, op);
        ++opCount;
        PROGRAM_PUSH_STRING(program, read_String(input));
        break;
      case COMMENT:
        break;
      default:
        PROGRAM_PUSH_OP(program, op);
        ++opCount;
        break;
    }
  }
  return program;
}
