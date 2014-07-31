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
      # For the first item, make a pairlist with the item
      q <<- pairlist(x)
      last <<- q
    } else {
      # This modifies `last` in place, adding another item to the pairlist.
      # Because `last` points to the last element in q, this also indirectly
      # modifies `q`, in violation of the usual R copy-on-write behavior.
      last <<- append_(last, x)
    }
    invisible(self)
  }

  add_many <- function(..., .list = NULL) {
    args <- concat_(pairlist(...), as.pairlist(.list))

    if (is.null(q)) {
      q <<- args
      last <<- last_(q)
    } else {
      # This modifies `last` in place, adding the `args` pairlist.
      last <<- append_pl_(last, args)
    }
    invisible(self)
  }

  remove <- function() {
    val <- car_(q)
    q <<- cdr_(q)
    val
  }

  peek <- function() car_(q)

  empty <- function() is.null(q)

  reset <- function() {
    q <<- NULL
    last <<- NULL
  }

  size <- function() length(q)

  # This forces a copy of q, so that the outside world doesn't get exposed
  # to our in-place modification of q.
  show <- function() duplicate_(q)

  self
}
