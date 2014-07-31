# These functions all have trailing underscores so that their names don't
# collide with names for the objects, like `s <- Stack(); s$push()`.

#' @useDynLib qstack car
car_ <- function(x) .Call(car, x)

#' @useDynLib qstack cdr
cdr_ <- function(x) .Call(cdr, x)

#' @useDynLib qstack last
last_ <- function(x) .Call(last, x)

#' @useDynLib qstack push
push_ <- function(x, value) .Call(push, x, value)

#' @useDynLib qstack rev_pairlist
rev_pairlist_ <- function(x) .Call(rev_pairlist, x)

#' @useDynLib qstack concat
concat_ <- function(x, y) .Call(concat, x, y)

#' @useDynLib qstack append
append_ <- function(x, value) .Call(append, x, value)

#' @useDynLib qstack append_pl
append_pl_ <- function(x, ...) .Call(append_pl, x, ...)

#' @useDynLib qstack duplicate2
duplicate_ <- function(x) .Call(duplicate2, x)
