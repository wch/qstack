# These functions all have trailing underscores so that their names don't
# collide with names for the objects, like `s <- Stack(); s$push()`.

#' @useDynLib qstack C_car
car_ <- function(x) .Call(C_car, x)

#' @useDynLib qstack C_cdr
cdr_ <- function(x) .Call(C_cdr, x)

#' @useDynLib qstack C_last
last_ <- function(x) .Call(C_last, x)

#' @useDynLib qstack C_push
push_ <- function(x, value) .Call(C_push, x, value)

#' @useDynLib qstack C_push_list
push_list_ <- function(x, lst) .Call(C_push_list, x, lst)

#' @useDynLib qstack C_append
append_ <- function(x, value) .Call(C_append, x, value)

#' @useDynLib qstack C_append_list
append_list_ <- function(x, lst) .Call(C_append_list, x, lst)

#' @useDynLib qstack C_duplicate
duplicate_ <- function(x) .Call(C_duplicate, x)

