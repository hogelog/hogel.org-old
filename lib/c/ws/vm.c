#include "wspace.h"

void plabel(char *label) {
  switch(*label) {
    case '\0':
      putchar('\n');
      return;
    case ' ':
      putchar('A');
      break;
    case '\t':
      putchar('B');
      break;
    case '\n':
      putchar('C');
      break;
  }
  return plabel(label+1);
}
void push_Stack(Stack *stack, int val) {
  if(stack->top == stack->size) {
    fprintf(stderr, "stack overflow\n");
    exit(1);
  }
  stack->data[stack->top++] = val;
}
int pop_Stack(Stack *stack) {
  if(stack->top == 0) {
    fprintf(stderr, "stack underflow\n");
    exit(1);
  }
  return stack->data[--stack->top];
}
int ref_Stack(Stack *stack, int ref) {
  int index = stack->top - ref -1;
  if(index < 0) {
    fprintf(stderr, "out of stack\n");
    exit(1);
  }
  return stack->data[index];
}
int find_Program(Program *program, char *target) {
  int iter = 0;
  char *label;
  for(;iter<program->size;++iter) {
    Instruction inst = program->data[iter];
    switch(inst.operation) {
      case PUSH:
      case REF:
      case SLIDE:
      case CALL:
      case JUMP:
      case IZ_JUMP:
      case IN_JUMP:
        ++iter;
        break;
      case LABEL:
        label = program->data[++iter].string;
        if(strncmp(target, label, MAX_LABEL_SIZE)==0) {
          return iter;
        }
        break;
      default:
        break;
    }
  }
  fprintf(stderr, "undefined label %s", target);
  exit(1);
}
void print_Operation(Operation op) {
  switch(op) {
    case PUSH:
      puts("PUSH");break;
    case DUP:
      puts("DUP");break;
    case REF:
      puts("REF");break;
    case SWAP:
      puts("SWAP");break;
    case DISCARD:
      puts("DISCARD");break;
    case SLIDE:
      puts("SLIDE");break;
    case PLUS:
      puts("PLUS");break;
    case MINUS:
      puts("MINUS");break;
    case TIMES:
      puts("TIMES");break;
    case DIVIDE:
      puts("DIVIDE");break;
    case MODULO:
      puts("MODULO");break;
    case STORE:
      puts("STORE");break;
    case RETRIEVE:
      puts("RETRIEVE");break;
    case LABEL:
      puts("LABEL");break;
    case CALL:
      puts("CALL");break;
    case JUMP:
      puts("JUMP");break;
    case IZ_JUMP:
      puts("IZ_JUMP");break;
    case IN_JUMP:
      puts("IN_JUMP");break;
    case RETURN:
      puts("RETURN");break;
    case END:
      puts("END");break;
    case OUTPUTC:
      puts("OUTPUTC");break;
    case OUTPUTN:
      puts("OUTPUTN");break;
    case READC:
      puts("READC");break;
    case READN:
      puts("READN");break;
    case ERROR:
      puts("ERROR");break;
    case COMMENT:
      puts("COMMENT");break;
  }
}
int next_Number(VM *vm) {
  int num = vm->program.data[++vm->pc].number;
#ifdef DEBUG
  printf("%d\n", num);
#endif
  return num;
}
char *next_String(VM *vm) {
  char *label = vm->program.data[++vm->pc].string;
#ifdef DEBUG
  plabel(label);
#endif
  return label;
}
void exec_Program(VM *vm) {
  Program *program = &(vm->program);
  int x, y;
  char *label;
  char linebuf[LINE_BUF];
  for(vm->pc=0;vm->pc<program->size;++vm->pc) {
    Instruction inst = program->data[vm->pc];
#ifdef DEBUG
    printf("top:%d\n", vm->valstack.top);
    print_Operation(inst.operation);
#endif
    switch(inst.operation) {
      case PUSH:
        push_Stack(&vm->valstack, next_Number(vm));
        break;
      case DUP:
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x);
        push_Stack(&vm->valstack, x);
        break;
      case REF:
        x = next_Number(vm);
        push_Stack(&vm->valstack, ref_Stack(&vm->valstack, x));
        break;
      case SWAP:
        x = pop_Stack(&vm->valstack);
        y = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, y);
        push_Stack(&vm->valstack, x);
        break;
      case DISCARD:
        pop_Stack(&vm->valstack);
        break;
      case SLIDE:
        x = pop_Stack(&vm->valstack);
        y = next_Number(vm);
        while(y) {
          pop_Stack(&vm->valstack);
          --y;
        }
        push_Stack(&vm->valstack, x);
        break;
      case PLUS:
        y = pop_Stack(&vm->valstack);
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x + y);
        break;
      case MINUS:
        y = pop_Stack(&vm->valstack);
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x - y);
        break;
      case TIMES:
        y = pop_Stack(&vm->valstack);
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x * y);
        break;
      case DIVIDE:
        y = pop_Stack(&vm->valstack);
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x / y);
        break;
      case MODULO:
        y = pop_Stack(&vm->valstack);
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, x % y);
        break;
      case STORE:
        x = pop_Stack(&vm->valstack);
        y = pop_Stack(&vm->valstack);
        HEAP_STORE(&vm->memory, x, y);
        break;
      case RETRIEVE:
        x = pop_Stack(&vm->valstack);
        push_Stack(&vm->valstack, HEAP_RETRIEVE(&vm->memory, x));
        break;
      case LABEL:
        label = next_String(vm);
        break;
      case CALL:
        push_Stack(&vm->callstack, vm->pc);
        label = next_String(vm);
        vm->pc = find_Program(program, label);
        break;
      case JUMP:
        label = next_String(vm);
        vm->pc = find_Program(program, label);
        break;
      case IZ_JUMP:
        x = pop_Stack(&vm->valstack);
        label = next_String(vm);
        if(x==0) {
          vm->pc = find_Program(program, label);
        }
        break;
      case IN_JUMP:
        x = pop_Stack(&vm->valstack);
        label = next_String(vm);
        if(x<0) {
          vm->pc = find_Program(program, label);
        }
        break;
      case RETURN:
        x = pop_Stack(&vm->callstack)+1;
        vm->pc = x;
        break;
      case END:
        return;
      case OUTPUTC:
        putchar(pop_Stack(&vm->valstack));
        break;
      case OUTPUTN:
        printf("%d", pop_Stack(&vm->valstack));
        break;
      case READC:
        x = pop_Stack(&vm->valstack);
        HEAP_STORE(&vm->memory, getchar(), x);
        break;
      case READN:
        x = pop_Stack(&vm->valstack);
        fgets(linebuf, LINE_BUF, stdin);
        sscanf(linebuf, "%d", &y);
        HEAP_STORE(&vm->memory, y, x);
        break;
      default:
        puts("ERROR");
        break;
    }
  }
}
