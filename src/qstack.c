#include <R.h>
#include <Rdefines.h>


// Given a pairlist, return the first item
SEXP carC(SEXP x) {
  if (!isList(x))
    error("x must be a pairlist");
  return CAR(x);
}


// Given a pairlist, return a pairlist with all except the first item
// Returned pairlist is NOT a copy; it is part of the original x.
SEXP cdrC(SEXP x) {
  if (!isList(x))
    error("x must be a pairlist");
  return CDR(x);
}


// Given a pairlist, traverse to the end and return a pairlist pointing to
// the last element.
// Returned pairlist is NOT a copy; it is part of the original x.
SEXP lastC(SEXP x) {
  if (!isList(x))
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
SEXP pushC(SEXP x, SEXP value) {
  if (!isList(x))
    error("x must be a pairlist");
  return CONS(value, x);
}


// Add the items from a list `lst` to the head of a pairlist `x`.
// The pushing happens in the order of the list, so the result is in reverse
// order.
// Returned pairlist is NOT a copy; it includes the original x.
SEXP push_listC(SEXP x, SEXP lst) {
  if (!isList(x))
    error("x must be a pairlist");
  if (!isNewList(lst))
    error("lst must be a list");

  int len = length(lst);
  for (int i = 0; i < len; i++) {
    x = CONS(VECTOR_ELT(lst, i), x);
  }
  return x;
}


// Tack on an item to the end of a pairlist, and then return a pairlist that
// points to the last item.
// This modifies pairlist x in place. The returned pairlist is part of pairlist
// x; it is the last node in the linked list.
SEXP appendC(SEXP x, SEXP value) {
  if (x == R_NilValue)
    return CONS(value, R_NilValue);
  if (TYPEOF(x) != LISTSXP)
    error("x must be a pairlist of length 1.");

  // Traverse to end
  x = lastC(x);

  // Make a pairlist containing the value and add it to the end
  SETCDR(x, CONS(value, R_NilValue));
  return CDR(x);
}


// Add the items from a list `lst` to the tail of a pairlist `x`, and return
// a pairlist pointing to the last element.
// This modifies pairlist x in place.
// Returned pairlist is NOT a copy; it includes the original x.
SEXP append_listC(SEXP x, SEXP lst) {
  if (x == R_NilValue)
    error("x must be a pairlist of length >= 1");
  if (!isList(x))
    error("x must be a pairlist");
  if (!isNewList(lst))
    error("lst must be a list");

  x = lastC(x);
  int len = length(lst);
  for (int i = 0; i < len; i++) {
    SETCDR(x, CONS(VECTOR_ELT(lst, i), R_NilValue));
    x = CDR(x);
  }

  return x;
}
