#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define array(value_type) \
    typedef struct value_type ## Array { \
        value_type *x; \
        uint64_t len; \
        uint64_t cap; \
    } value_type ## Array; \
    value_type ## Array value_type ## Array_construct(uint64_t cap) { \
        return (value_type ## Array){.x = calloc(cap, sizeof(value_type)), .len = 0, .cap = cap}; \
    } \
    bool value_type ## Array_push_back(value_type ## Array *arr, value_type x) { \
        if (arr->len == arr->cap) return false; \
        arr->x[arr->len++] = x; \
        return true; \
    } \
    void value_type ## Array_destruct(value_type ## Array *arr) { \
        free(arr->x); \
    }

#define push_back(container, ...) _Generic(typeof_unqual(container), \
                                           intArray: intArray_push_back, \
                                           floatArray: floatArray_push_back)(&(container), __VA_ARGS__)
#define destruct(container) _Generic(typeof_unqual(container), \
                                          intArray: intArray_destruct, \
                                          floatArray: floatArray_destruct)(&(container))

auto pb = _Generic(typeof_unqual(container), 
                                           intArray: intArray_push_back, 
                                           floatArray: floatArray_push_back)

array(int);
array(float);

int main() {
    __auto_type ints = intArray_construct(32);
    __auto_type floats = floatArray_construct(64);

    printf("%lu %lu\n", ints.len, ints.cap);
    printf("%lu %lu\n", floats.len, floats.cap);

    for (int i = 0; i < ints.cap; ++i) {
        push_back(ints, i+1);
        push_back(floats, i * 3.1415f);
        push_back(floats, i * 6.283f);
    }

    printf("%lu %lu\n", ints.len, ints.cap);
    printf("%lu %lu\n", floats.len, floats.cap);

    for (int i = 0; i < ints.cap; ++i) {
        printf("%d ", ints.x[i]);
    }
    puts("");
    for (int i = 0; i < floats.cap; ++i) {
        printf("%.2f ", floats.x[i]);
    }

    destruct(ints);
    destruct(floats);

    return 0;
}
