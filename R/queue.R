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
      last <<- append_(last, x)
    }
    invisible(self)
  }

  madd <- function(..., .list = NULL) {
    args <- append_pl_(pairlist(...), as.pairlist(.list))

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

  show <- function() as.list(q)

  self
}
