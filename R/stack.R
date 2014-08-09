#' @export
Stack <- function() {
  self <- environment()

  # A pairlist that represents the stack
  s <- NULL

  push1 <- function(value) {
    s <<- .Call(pushC, s, value)
    invisible(self)
  }

  push <- function(..., .list = NULL) {
    dots <- list(...)

    if (length(dots) == 1L && is.null(.list)) {
      s <<- .Call(pushC, s, dots[[1]])
      return(invisible(self))
    }

    args <- .Call(rev_plC,
              .Call(append_plC, pairlist(...), as.pairlist(.list)))
    .Call(append_plC, args, s)
    s <<- args
    invisible(self)
  }

  mpush <- function(..., .list = NULL) {
    args <- .Call(rev_plC,
              .Call(append_plC, pairlist(...), as.pairlist(.list)))
    .Call(append_plC, args, s)
    s <<- args
    invisible(self)
  }

  pop <- function(n) {
    val <- .Call(carC, s)
    s <<- .Call(cdrC, s)
    val
  }

  peek <- function() .Call(carC, s)

  isempty <- function() is.null(s)

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
