# These functions all have trailing underscores so that their names don't
# collide with names for the objects, like `s <- Stack(); s$push()`.

#' @useDynLib qstack carC
car_ <- function(x) .Call(carC, x)

#' @useDynLib qstack cdrC
cdr_ <- function(x) .Call(cdrC, x)

#' @useDynLib qstack lastC
last_ <- function(x) .Call(lastC, x)

#' @useDynLib qstack pushC
push_ <- function(x, value) .Call(pushC, x, value)

#' @useDynLib qstack rev_plC
rev_pl_ <- function(x) .Call(rev_plC, x)

#' @useDynLib qstack appendC
append_ <- function(x, value) .Call(appendC, x, value)

#' @useDynLib qstack append_plC
append_pl_ <- function(x, ...) .Call(append_plC, x, ...)

#' @useDynLib qstack duplicateC
duplicate_ <- function(x) .Call(duplicateC, x)
