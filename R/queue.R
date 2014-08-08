#' @export
Queue <- function() {
  self <- environment()

  # A pairlist that represents the queue
  q <- NULL
  # A pairlist that points to last element in q. This eliminates the need to
  # traverse pairlist q each time we want to add an item.
  last <- NULL

  add <- function(x) {
    if (is.null(q)) {
      q <<- as.pairlist(x)
      last <<- q
    } else {
      # This modifies the `last` pairlist in place, adding another item.
      # Because `last` points to the last element in q, this also indirectly
      # modifies q, in violation of the usual R copy-on-write behavior.
      last <<- .Call(append2, last, x)
    }
    invisible(self)
  }

  madd <- function(..., .list = NULL) {
    args <- .Call(append_pl, pairlist(...), as.pairlist(.list))

    if (is.null(q)) {
      q <<- args
      last <<- .Call(last, q)
    } else {
      # This modifies `last` in place, adding the `args` pairlist.
      last <<- .Call(append_pl, last, args)
    }
    invisible(self)
  }

  remove <- function() {
    val <- .Call(car, q)
    q <<- .Call(cdr, q)
    val
  }

  peek <- function() .Call(car, q)

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
