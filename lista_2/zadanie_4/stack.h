#ifndef STACK_H
#define STACK_H

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

typedef struct stack stack;

stack* stack_create();
void stack_destroy(stack* s);
void stack_push(stack* s, int value);
int stack_pop(stack* s);
int stack_top(stack* s);
bool stack_is_empty(stack* s);
void stack_clear(stack* s);
bool stack_error_occured(stack* s);
void stack_clear_error(stack* s);

#endif // STACK_H