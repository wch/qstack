#' @export
Stack <- function() {
  self <- environment()

  # A pairlist that represents the stack
  s <- NULL

  push <- function(..., .list = NULL) {
    s <<- .Call(C_push_list, s, list(...))
    s <<- .Call(C_push_list, s, .list)
    invisible(self)
  }

  pop <- function(n) {
    val <- .Call(C_car, s)
    s <<- .Call(C_cdr, s)
    val
  }

  peek <- function() .Call(C_car, s)

  isempty <- function() is.null(s)

  reset <- function() {
    s <<- NULL
    invisible(self)
  }

  size <- function() length(s)

  # Return the entire queue as a list, where the first item is the next to be
  # removed (and the most recently added).
  as_list <- function() as.list(s)

  self
}
