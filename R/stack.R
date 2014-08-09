#' @export
Stack <- function() {
  self <- environment()

  # A pairlist that represents the stack
  s <- NULL

  push <- function(..., .list = NULL) {
    s <<- .Call(push_listC, s, list(...))
    s <<- .Call(push_listC, s, .list)
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
