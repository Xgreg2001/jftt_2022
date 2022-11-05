#include "stack.h"

#define STACK_SIZE 1024

struct stack {
    int data[STACK_SIZE];
    size_t ptr;
    bool error_occured;
};

stack* stack_create(){
    stack* s = malloc(sizeof(stack));
    if (s == NULL) return NULL;
    s->ptr = 0;
    s->error_occured = false;
    return s;
}

void stack_destroy(stack* s){
    if (s == NULL) return;
    free(s);
}

void stack_push(stack* s, int value){
    if (s == NULL) return;
    s->data[s->ptr] = value;
    s->ptr++;
    if (s->ptr > STACK_SIZE){
        s->error_occured = true;
        fprintf(stderr, "Stack overflow!\n");
    }
}

int stack_pop(stack* s){
    if (s == NULL) return 0;
    if (s->ptr == 0){
        s->error_occured = true;
        fprintf(stderr, "Błąd: za mała liczba argumentów\n");
        return 0;
    }
    s->ptr--;
    return s->data[s->ptr];
}

int stack_top(stack* s){
    if (s == NULL) return 0;
    if (s->ptr == 0){
        s->error_occured = true;
        fprintf(stderr, "Błąd: za mała liczba operatorów\n");
        return 0;
    }
    return s->data[s->ptr-1];
}

bool stack_is_empty(stack* s){
    if (s == NULL) return true;
    return s->ptr == 0;
}

void stack_clear(stack* s){
    if (s == NULL) return;
    s->ptr = 0;
}

bool stack_error_occured(stack* s){
    if (s == NULL) return true;
    return s->error_occured;
}

void stack_clear_error(stack* s){
    if (s == NULL) return;
    s->error_occured = false;
}