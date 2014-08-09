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
      last <<- .Call(lastC, q)

    } else {
      last <<- .Call(append_listC, last, list(...))
      last <<- .Call(append_listC, last, .list)
    }
    invisible(self)
  }

  remove <- function() {
    val <- .Call(carC, q)
    q <<- .Call(cdrC, q)
    val
  }

  peek <- function() .Call(carC, q)

  empty <- function() is.null(q)

  reset <- function() {
    q <<- NULL
    last <<- NULL
    invisible(self)
  }

  size <- function() length(q)

  # Return the entire queue as a list, where the first item is the oldest
  # in the queue.
  show <- function() as.list(q)

  self
}
