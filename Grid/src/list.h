/*
 * Copyright (c) 2015 Evan Teran
 * 
 * License: The MIT License (MIT)
 * 
 * Originally VECTOR_H
 * 
 */

#ifndef LIST_H_
#define LIST_H_

#include <assert.h> /* for assert */
#include <stdlib.h> /* for malloc/realloc/free */
#include <string.h> /* for memcpy/memmove */

/* list heap implemented using C library malloc() */

/* in case C library malloc() needs extra protection,
 * allow these defines to be overridden.
 */
#ifndef list_clib_free
#define list_clib_free free
#endif
#ifndef list_clib_malloc
#define list_clib_malloc malloc
#endif
#ifndef list_clib_calloc
#define list_clib_calloc calloc
#endif
#ifndef list_clib_realloc
#define list_clib_realloc realloc
#endif

typedef void (*list_elem_destructor_t)(void *elem);

/**
 * @brief list_type - The list type used in this library
 */
#define list_type(type) type *

/**
 * @brief list_to_base - For internal use, converts a list pointer to a metadata pointer
 * @param list - the list
 * @return the metadata pointer of the list
 */
#define list_to_base(list) \
    (void *)(&(((list_elem_destructor_t *)&(((size_t *)(list))[-2]))[-1]))

/**
 * @brief list_base_to_list - For internal use, converts a metadata pointer to a list pointer
 * @param ptr - pointer to the metadata
 * @return the list
 */
#define list_base_to_list(ptr) \
    (void *)&((size_t *)&((list_elem_destructor_t *)(ptr))[1])[2]

/**
 * @brief list_capacity - gets the current capacity of the list
 * @param list - the list
 * @return the capacity as a size_t
 */
#define list_capacity(list) \
    ((list) ? ((size_t *)(list))[-1] : (size_t)0)

/**
 * @brief list_size - gets the current size of the list
 * @param list - the list
 * @return the size as a size_t
 */
#define list_size(list) \
    ((list) ? ((size_t *)(list))[-2] : (size_t)0)

/**
 * @brief list_elem_destructor - get the element destructor function used
 * to clean up elements
 * @param list - the list
 * @return the function pointer as list_elem_destructor_t
 */
#define list_elem_destructor(list) \
    ((list) ? (((list_elem_destructor_t *)&(((size_t *)(list))[-2]))[-1]) : NULL)

/**
 * @brief list_empty - returns non-zero if the list is empty
 * @param list - the list
 * @return non-zero if empty, zero if non-empty
 */
#define list_empty(list) \
    (list_size(list) == 0)

/**
 * @brief list_reserve - Requests that the list capacity be at least enough
 * to contain n elements. If n is greater than the current list capacity, the
 * function causes the container to reallocate its storage increasing its
 * capacity to n (or greater).
 * @param list - the list
 * @param n - Minimum capacity for the list.
 * @return void
 */
#define list_reserve(list, capacity)           \
    do {                                         \
        size_t li_cap__ = list_capacity(list); \
        if (li_cap__ < (capacity)) {             \
            list_grow((list), (capacity));     \
        }                                        \
    } while (0)

/**
 * @brief list_erase - removes the element at index i from the list
 * @param list - the list
 * @param i - index of element to remove
 * @return void
 */
#define list_erase(list, i)                                                               \
    do {                                                                                    \
        if (list) {                                                                          \
            const size_t li_sz__ = list_size(list);                                       \
            if ((i) < li_sz__) {                                                            \
                list_elem_destructor_t elem_destructor__ = list_elem_destructor(list); \
                if (elem_destructor__) {                                                    \
                    elem_destructor__(&list[i]);                                             \
                }                                                                           \
                list_set_size((list), li_sz__ - 1);                                       \
                memmove(                                                                    \
                    (list) + (i),                                                            \
                    (list) + (i) + 1,                                                        \
                    sizeof(*(list)) * (li_sz__ - 1 - (i)));                                  \
            }                                                                               \
        }                                                                                   \
    } while (0)

/**
 * @brief list_free - frees all memory associated with the list
 * @param list - the list
 * @return void
 */
#define list_free(list)                                                               \
    do {                                                                                \
        if (list) {                                                                      \
            void *p1__                                  = list_to_base(list);     \
            list_elem_destructor_t elem_destructor__ = list_elem_destructor(list); \
            if (elem_destructor__) {                                                    \
                size_t i__;                                                             \
                for (i__ = 0; i__ < list_size(list); ++i__) {                         \
                    elem_destructor__(&list[i__]);                                       \
                }                                                                       \
            }                                                                           \
            list_clib_free(p1__);                                                    \
        }                                                                               \
    } while (0)

/**
 * @brief list_begin - returns an iterator to first element of the list
 * @param list - the list
 * @return a pointer to the first element (or NULL)
 */
#define list_begin(list) \
    (list)

/**
 * @brief list_end - returns an iterator to one past the last element of the list
 * @param list - the list
 * @return a pointer to one past the last element (or NULL)
 */
#define list_end(list) \
    ((list) ? &((list)[list_size(list)]) : NULL)

/* user request to use logarithmic growth algorithm */
#ifdef LIST_LOGARITHMIC_GROWTH

/**
 * @brief list_compute_next_grow - returns an the computed size in next list grow
 * size is increased by multiplication of 2
 * @param size - current size
 * @return size after next list grow
 */
#define list_compute_next_grow(size) \
    ((size) ? ((size) << 1) : 1)

#else

/**
 * @brief list_compute_next_grow - returns an the computed size in next list grow
 * size is increased by 1
 * @param size - current size
 * @return size after next list grow
 */
#define list_compute_next_grow(size) \
    ((size) + 1)

#endif /* LIST_LOGARITHMIC_GROWTH */

/**
 * @brief list_push_back - adds an element to the end of the list
 * @param list - the list
 * @param value - the value to add
 * @return void
 */
#define list_push_back(list, value)                                 \
    do {                                                              \
        size_t li_cap__ = list_capacity(list);                      \
        if (li_cap__ <= list_size(list)) {                          \
            list_grow((list), list_compute_next_grow(li_cap__)); \
        }                                                             \
        (list)[list_size(list)] = (value);                           \
        list_set_size((list), list_size(list) + 1);               \
    } while (0)

/**
 * @brief list_insert - insert element at position pos to the list
 * @param list - the list
 * @param pos - position in the list where the new elements are inserted.
 * @param val - value to be copied (or moved) to the inserted elements.
 * @return void
 */
#define list_insert(list, pos, val)                                 \
    do {                                                              \
        size_t li_cap__ = list_capacity(list);                      \
        if (li_cap__ <= list_size(list)) {                          \
            list_grow((list), list_compute_next_grow(li_cap__)); \
        }                                                             \
        if ((pos) < list_size(list)) {                              \
            memmove(                                                  \
                (list) + (pos) + 1,                                    \
                (list) + (pos),                                        \
                sizeof(*(list)) * ((list_size(list)) - (pos)));      \
        }                                                             \
        (list)[(pos)] = (val);                                         \
        list_set_size((list), list_size(list) + 1);               \
    } while (0)

/**
 * @brief list_pop_back - removes the last element from the list
 * @param list - the list
 * @return void
 */
#define list_pop_back(list)                                                       \
    do {                                                                            \
        list_elem_destructor_t elem_destructor__ = list_elem_destructor(list); \
        if (elem_destructor__) {                                                    \
            elem_destructor__(&(list)[list_size(list) - 1]);                       \
        }                                                                           \
        list_set_size((list), list_size(list) - 1);                             \
    } while (0)

/**
 * @brief list_copy - copy a list
 * @param from - the original list
 * @param to - destination to which the function copy to
 * @return void
 */
#define list_copy(from, to)                                          \
    do {                                                                \
        if ((from)) {                                                   \
            list_grow(to, list_size(from));                       \
            list_set_size(to, list_size(from));                   \
            memcpy((to), (from), list_size(from) * sizeof(*(from))); \
        }                                                               \
    } while (0)

/**
 * @brief list_set_capacity - For internal use, sets the capacity variable of the list
 * @param list - the list
 * @param size - the new capacity to set
 * @return void
 */
#define list_set_capacity(list, size)     \
    do {                                    \
        if (list) {                          \
            ((size_t *)(list))[-1] = (size); \
        }                                   \
    } while (0)

/**
 * @brief list_set_size - For internal use, sets the size variable of the list
 * @param list - the list
 * @param size - the new capacity to set
 * @return void
 */
#define list_set_size(list, size)         \
    do {                                    \
        if (list) {                          \
            ((size_t *)(list))[-2] = (size); \
        }                                   \
    } while (0)

/**
 * @brief list_set_elem_destructor - set the element destructor function
 * used to clean up removed elements
 * @param list - the list
 * @param elem_destructor_fn - function pointer of type list_elem_destructor_t used to destroy elements
 * @return void
 */
#define list_set_elem_destructor(list, elem_destructor_fn)                                    \
    do {                                                                                        \
        if (list) {                                                                              \
            ((list_elem_destructor_t *)&(((size_t *)(list))[-2]))[-1] = (elem_destructor_fn); \
        }                                                                                       \
    } while (0)

/**
 * @brief list_grow - For internal use, ensures that the list is at least <count> elements big
 * @param list - the list
 * @param count - the new capacity to set
 * @return void
 */
#define list_grow(list, count)                                                                                  \
    do {                                                                                                          \
        const size_t li_sz__ = (count) * sizeof(*(list)) + sizeof(size_t) * 2 + sizeof(list_elem_destructor_t); \
        if (list) {                                                                                                \
            void *li_p1__ = list_to_base(list);                                                             \
            void *li_p2__ = list_clib_realloc(li_p1__, li_sz__);                                               \
            assert(li_p2__);                                                                                      \
            (list) = list_base_to_list(li_p2__);                                                                 \
        } else {                                                                                                  \
            void *li_p__ = list_clib_malloc(li_sz__);                                                          \
            assert(li_p__);                                                                                       \
            (list) = list_base_to_list(li_p__);                                                                  \
            list_set_size((list), 0);                                                                           \
            list_set_elem_destructor((list), NULL);                                                             \
        }                                                                                                         \
        list_set_capacity((list), (count));                                                                     \
    } while (0)

#endif /* LIST_H_ */
