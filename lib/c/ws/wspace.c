#include "wspace.h"

Program* init_Program(Program *program, int size) {
  program->size = 0;
  program->capacity = size;
  program->data = malloc(sizeof(Instruction)*size);
  return program;
}
Stack* init_Stack(Stack *stack, int size) {
  stack->size = size;
  stack->top = 0;
  stack->data = malloc(sizeof(int)*size);
  return stack;
}
Heap* init_Heap(Heap *heap, int size) {
  heap->size = size;
  heap->data = calloc(size, sizeof(int));
  return heap;
}
VM* init_VM(VM *vm) {
  init_Program(&(vm->program), INIT_PROGRAM_SIZE);
  init_Stack(&(vm->valstack), INIT_STACK_SIZE);
  init_Stack(&(vm->callstack), INIT_STACK_SIZE);
  init_Heap(&(vm->memory), INIT_HEAP_SIZE);
  vm->pc = 0;
  return vm;
}
int main(int argc, char *argv[]) {
  VM vm;
  FILE *input;
  if(argc<2) {
    printf("%s wscode\n", argv[0]);
    return 0;
  }

  if(init_VM(&vm)==NULL) {
    puts("fail init VM");
    return 1;
  }
  if((input = fopen(argv[1], "r"))==NULL) {
    printf("cannot open %s\n", argv[1]);
    return 1;
  }
  init_Program(&(vm.program), INIT_PROGRAM_SIZE);
  read_Program(&(vm.program), input);
  exec_Program(&(vm));
  return 0;
}
