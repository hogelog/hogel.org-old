#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define A ' '
#define B '\t'
#define C '\n'

#define PROGRAM_FULL(p) \
  ((p)->size == (p)->capacity)
#define PROGRAM_PUSH_OP(p,op) \
  ((p)->data[(p)->size++].operation = (op))
#define PROGRAM_PUSH_NUM(p,num) \
  ((p)->data[(p)->size++].number = (num))
#define PROGRAM_PUSH_STRING(p,str) \
  ((p)->data[(p)->size++].string = (str))

#define STACK_PUSH(stack, val) \
  ((stack)->data[((stack)->top)++] = (val))
#define STACK_POP(stack) \
  ((stack)->data[((stack)->top)--])

#define HEAP_STORE(heap, val, loc) \
  ((heap)->data[(loc)] = (val))
#define HEAP_RETRIEVE(heap, loc) \
  ((heap)->data[(loc)])

#define INIT_PROGRAM_SIZE 10000
#define INIT_STACK_SIZE 10000
#define INIT_HEAP_SIZE 10000
#define MAX_LABEL_SIZE 256
#define LINE_BUF 1000

typedef enum Operation {
  PUSH, DUP, REF, SWAP, DISCARD, SLIDE,
  PLUS, MINUS, TIMES, DIVIDE, MODULO,
  STORE, RETRIEVE,
  LABEL, CALL, JUMP, IZ_JUMP, IN_JUMP, RETURN, END,
  OUTPUTC, OUTPUTN, READC, READN,
  ERROR, COMMENT
} Operation;
typedef union Instruction {
    Operation operation;
    int number;
    char *string;
    double align;
} Instruction;
typedef struct Program {
  int size, capacity;
  Instruction *data;
} Program;
typedef struct Stack {
  int size, top;
  int *data;
} Stack;
typedef struct Heap {
  int size;
  int *data;
} Heap;
typedef struct VM {
  Program program;
  Stack valstack, callstack;
  Heap memory;
  int pc;
} VM;

void plabel(char *label);
Program* init_Program(Program *program, int size);
Program* read_Program(Program *program, FILE *input);
VM* init_VM(VM *vm);
void exec_Program(VM *vm);
