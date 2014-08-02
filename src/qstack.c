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
// Returned pairlist is NOT a copy; it is part of the original x.
SEXP cdr(SEXP x) {
  if (x == R_NilValue)
    return R_NilValue;
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");
  return CDR(x);
}


// Given a pairlist, traverse to the end and return a pairlist pointing to
// the last element.
// Returned pairlist is NOT a copy; it is part of the original x.
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
// Returned pairlist is NOT a copy; it includes the original x.
SEXP push(SEXP x, SEXP value) {
  if (x != R_NilValue && TYPEOF(x) != LISTSXP)
    error("x must be a pairlist");
  return CONS(value, x);
}


// Given a pairlist, return a pairlist with reversed order.
// Returned pairlist is a copy.
SEXP rev_pl(SEXP x) {
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


// Tack on an item to the end of a pairlist, and then return a pairlist that
// points to the last item.
// This modifies pairlist x in place. The returned pairlist is part of pairlist
// x; it is the last node in the linked list.
SEXP append2(SEXP x, SEXP value) {
  if (x == R_NilValue)
    return CONS(value, R_NilValue);
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
// This modifies pairlist x in place, and the returned pairlist includes the
// original x and y.
SEXP append_pl(SEXP x, SEXP y) {
  if (x == R_NilValue)
    return y;
  if (y == R_NilValue)
    return x;
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
