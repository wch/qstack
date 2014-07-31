#include <R.h>
#include <Rdefines.h>


// Given a pairlist, return the first item
SEXP car(SEXP x) {
  if (x == R_NilValue)
    return R_NilValue;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");
  return CAR(x);
}


// Given a pairlist, return a pairlist with all except the first item
SEXP cdr(SEXP x) {
  if (x == R_NilValue)
    return R_NilValue;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");
  return CDR(x);
}


// Given a pairlist, traverse to the end and return a pairlist pointing to
// the last element. Note that this doesn't make a copy of x.
SEXP last(SEXP x) {
  if (x == R_NilValue)
    return R_NilValue;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");

  SEXP next = x;
  while (next != R_NilValue) {
    x = next;
    next = CDR(next);
  }
  return x;
}

// Add an item to the head of a pairlist (position 1).
// Note that this does not duplicate the entire pairlist and so is potentially
// unsafe to use with functions that modify pairlists in place.
SEXP push(SEXP x, SEXP value) {
  if (x != R_NilValue && TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");
  return CONS(value, x);
}


// Given a pairlist, return a pairlist with reversed order.
SEXP rev_pairlist (SEXP x) {
  if (x == R_NilValue)
    return R_NilValue;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist.");

  // How can we keep the PROTECT out of the loop and move the rest of the
  // code into the loop?
  SEXP new_x = PROTECT(CONS(CAR(x), R_NilValue));
  x = CDR(x);

  while (x != R_NilValue) {
    new_x = CONS(CAR(x), new_x);
    x = CDR(x);
  }
  UNPROTECT(1);
  return new_x;
}


// Concatenate two pairlists together. Pairlist x will be duplicated, but
// pairlist y will be part of pairlist x. This is potentially dangerous if you
// use functions that aren't copy-on-write.
SEXP concat(SEXP x, SEXP y) {
  if (x == R_NilValue)
    return y;
  if (y == R_NilValue)
    return x;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist.");
  if (TYPEOF(y) != LISTSXP)
    error("y must be a pairlist.");

  // Copy x so we dont alter it
  SEXP new_x = PROTECT(duplicate(x));
  SEXP pl = new_x;

  // Traverse to end of the pairlist
  SEXP next = CDR(pl);
  while (next != R_NilValue) {
    pl = next;
    next = CDR(next);
  }
  SETCDR(pl, y);

  UNPROTECT(1);
  return new_x;
}


// Tack on an item to the end of a pairlist, and then return a pairlist that
// points to the last item. This does two unusual things (for R): it modifies x
// in-place, and the returned pairlist is actually part of the modified x
// pairlist. If you repeatedly run x <- cdr(x), you'll eventually get a
// pairlist that has the same memory address as the returned pairlist.
SEXP append(SEXP x, SEXP value) {
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist of length 1.");

  // Traverse to end
  x = last(x);

  // Make a pairlist containing the value and add it to the end
  SETCDR(x, CONS(value, R_NilValue));
  return CDR(x);
}


// Similar to append, except this takes two pairlists, x and y, and appends y to
// the end of x.
SEXP append_pl(SEXP x, SEXP y) {
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist.");
  if (TYPEOF(y) != LISTSXP)
    error("y must be a pairlist.");

  // Traverse to end
  x = last(x);

  // Copy y so that we dont make the original y part of x
  SEXP new_y = PROTECT(duplicate(y));
  SETCDR(x, new_y);
  UNPROTECT(1);
  // Go to the end and return last element
  return last(x);
}

// Force the creation of a duplicate of an object
SEXP duplicate2(SEXP x) {
  return duplicate(x);
}
