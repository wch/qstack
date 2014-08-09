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

#' @useDynLib qstack push_listC
push_list_ <- function(x, lst) {
  .Call(push_listC, x, lst)
}

#' @useDynLib qstack appendC
append_ <- function(x, value) .Call(appendC, x, value)

#' @useDynLib qstack append_listC
append_list_ <- function(x, lst) {
  .Call(append_listC, x, lst)
}
