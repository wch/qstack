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
    args <- rev_pairlist_(concat_(pairlist(...), .list))
    s <<- concat_(args, s)
    invisible(self)
  }

  pop <- function() {
    val <- car_(s)
    s <<- cdr_(s)
    val
  }

  peek <- function() car_(s)

  reset <- function() s <<- NULL

  size <- function() length(s)

  show <- function() duplicate_(s)

  self
}
