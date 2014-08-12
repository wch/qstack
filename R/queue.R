#' @export
Queue <- function() {
  self <- environment()

  # A pairlist that represents the queue
  q <- NULL
  # A pairlist that points to last element in q. This is the most recent item
  # added. This eliminates the need to traverse pairlist q each time we want
  # to add an item.
  last <- NULL

  add <- function(..., .list = NULL) {
    if (is.null(q)) {
      q <<- as.pairlist(c(list(...), .list))
      last <<- .Call(C_last, q)

    } else {
      last <<- .Call(C_append_list, last, list(...))
      last <<- .Call(C_append_list, last, .list)
    }
    invisible(self)
  }

  remove <- function() {
    val <- .Call(C_car, q)
    q <<- .Call(C_cdr, q)
    val
  }

  peek <- function() .Call(C_car, q)

  empty <- function() is.null(q)

  reset <- function() {
    q <<- NULL
    last <<- NULL
    invisible(self)
  }

  size <- function() length(q)

  # Return the entire queue as a list, where the first item is the next to be
  # removed (and oldest in the queue).
  as_list <- function() as.list(q)

  self
}
