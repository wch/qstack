#' @export
Stack <- function() {
  self <- environment()

  # A pairlist that represents the stack
  s <- NULL

  push <- function(value) {
    s <<- push_(s, value)
    invisible(self)
  }

  push_many <- function(..., .list = NULL) {
    args <- rev_pl_(append_pl_(pairlist(...), as.pairlist(.list)))
    s <<- append_pl_(args, s)
    invisible(self)
  }

  pop <- function() {
    val <- car_(s)
    s <<- cdr_(s)
    val
  }

  peek <- function() car_(s)

  empty <- function() is.null(s)

  reset <- function() s <<- NULL

  size <- function() length(s)

  show <- function() as.list(s)

  self
}
