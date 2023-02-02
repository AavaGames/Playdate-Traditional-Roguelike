#ifndef LIST_UTILS_H_
#define LIST_UTILS_H_

/**
 * @brief list_for_each_in - for header to iterate over list each element's address
 * @param it - iterator of type pointer to list element
 * @param list - the list
 * @return void
 */
#define list_for_each_in(it, list) \
    for (it = list_begin(list); it < list_end(list); it++)

/**
 * @brief list_for_each - call function func on each element of the list
 * @param list - the list
 * @param func - function to be called on each element that takes each element as argument
 * @return void
 */
#define list_for_each(list, func)                   \
    do {                                              \
        if ((list) && (func) != NULL) {                \
            size_t i;                                 \
            for (i = 0; i < list_size(list); i++) { \
                func((list)[i]);                       \
            }                                         \
        }                                             \
    } while (0)

/**
 * @brief list_free_each_and_free - calls `free_func` on each element
 * contained in the list and then destroys the list itself
 * @param list - the list
 * @param free_func - function used to free each element in the list with
 * one parameter which is the element to be freed)
 * @return void
 */
#define list_free_each_and_free(list, free_func) \
    do {                                           \
        list_for_each((list), (free_func));      \
        list_free(list);                         \
    } while (0)

#endif /* LIST_UTILS_H_ */
