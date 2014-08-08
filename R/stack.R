#' @export
Stack <- function() {
  self <- environment()

  # A pairlist that represents the stack
  s <- NULL

  push <- function(value) {
    s <<- .Call(push2, s, value)
    invisible(self)
  }

  mpush <- function(..., .list = NULL) {
    args <- .Call(rev_pl,
                  .Call(append_pl, pairlist(...), as.pairlist(.list)))
    .Call(append_pl, args, s)
    s <<- args
    invisible(self)
  }

  pop <- function() {
    val <- .Call(car, s)
    s <<- .Call(cdr, s)
    val
  }

  peek <- function() .Call(car, s)

  empty <- function() is.null(s)

  reset <- function() {
    s <<- NULL
    invisible(self)
  }

  size <- function() length(s)

  # Return the entire stack as a list, where the first item is the most
  # recently added.
  show <- function() as.list(s)

  self
}
