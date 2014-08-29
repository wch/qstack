#' A stack
#'
#' A Stack object is backed by a pairlist and calls out to compiled C code to
#' manipulate the pairlist.
#'
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

  # Return the entire stack as a list, where the first item in the list is the
  # oldest item in the stack, and the last item is the most recently added.
  as_list <- function() rev(as.list(s))

  self
}


#' A stack implemented entirely in R
#'
#' A Stack2 object is backed by a list. All manipulation is done in R, without
#' calling out to any compiled code. The backing list will grow or shrink as the
#' stack changes in size.
#'
#' @param init Initial size of the list that backs the stack. This is also used
#'   as the minimum size of the list; it will not shrink any smaller.
#' @export
Stack2 <- function(init = 20) {
  self <- environment()

  # A list that represents the stack
  s <- vector("list", init)
  # Current size of the stack
  count <- 0L

  push <- function(..., .list = NULL) {
    args <- c(list(...), .list)
    new_size <- count + length(args)

    # Grow if needed
    while (new_size > length(s)) {
      s[length(s) * 2] <<- list(NULL)
    }
    s[count + seq_along(args)] <<- args
    count <<- new_size

    invisible(self)
  }

  spush <- function(value) {
    count <<- count + 1L

    # Grow if needed
    if (count > length(s)) {
      s[ceiling(length(s) * 2)] <<- list(NULL)
    }
    s[[count]] <<- value

    invisible(self)
  }

  pop <- function() {
    if (count == 0L)
      return(NULL)

    value <- s[[count]]
    s[count] <<- list(NULL)
    count <<- count - 1L

    # Shrink list if < 1/4 of the list is used, down to a minimum size of `init`
    len <- length(s)
    if (len > init && count < len/4) {
      new_len <- max(init, ceiling(len/2))
      s <<- s[seq_len(new_len)]
    }

    value
  }

  peek <- function() {
    if (count == 0L)
      return(NULL)
    s[[count]]
  }

  isempty <- function() count == 0L

  reset <- function() {
    s <<- vector("list", init)
    count <<- 0L
    invisible(self)
  }

  size <- function() count

  # Return the entire stack as a list, where the first item in the list is the
  # oldest item in the stack, and the last item is the most recently added.
  as_list <- function() s[seq_len(count)]

  self
}
