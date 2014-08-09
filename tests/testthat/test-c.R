context("C code")
library(pryr)

test_that("cdr_", {
  expect_identical(cdr_(NULL), NULL)
  expect_error(cdr_(NA))
  expect_error(cdr_(1))
  expect_error(cdr_(list()))
  expect_identical(cdr_(pairlist()), NULL)
  expect_identical(cdr_(pairlist(1)), NULL)
  expect_identical(cdr_(pairlist(1,2,b=3)), pairlist(2,b=3))

  # Make sure we're not making copies
  p <- pairlist(1,2,3)
  expect_identical(address(cdr_(p)), address(cdr_(p)))
})


test_that("last_", {
  p <- pairlist()
  expect_identical(last_(p), NULL)
  p <- pairlist(1)
  expect_identical(address(last_(p)), address(p))
  p <- pairlist(1,2,3)
  expect_identical(address(cdr_(cdr_(p))), address(last_(p)))
})


test_that("push_", {
  expect_identical(push_(pairlist(), 1), pairlist(1))
  expect_identical(push_(pairlist(1), 2), pairlist(2,1))
  expect_identical(push_(pairlist(1,2), 3), pairlist(3,1,2))
  expect_identical(push_(pairlist(), NULL), pairlist(NULL))

  p <- pairlist(1)
  expect_identical(address(cdr_(push_(p, 2))), address(p))
  p <- pairlist(1,2)
  expect_identical(address(cdr_(push_(p, 3))), address(p))
})


test_that("push_list_", {
  # Error if lst isn't a list
  expect_error(push_list_(NULL, 1))
  expect_error(push_list_(pairlist(1), 2))
  expect_error(push_list_(pairlist(1, 2), pairlist(1,2)))

  # Starting with empty pairlist
  expect_identical(push_list_(NULL, NULL), NULL)
  expect_identical(push_list_(NULL, list()), NULL)
  expect_identical(push_list_(NULL, list(1)), pairlist(1))
  expect_identical(push_list_(NULL, list(1,2)), pairlist(2,1))

  # Starting with a real pairlist
  p <- pairlist(1)
  expect_identical(push_list_(p, NULL), p)
  new_p <- push_list_(p, list(2,3))
  expect_identical(new_p, pairlist(3,2,1))
  expect_identical(address(cdr_(cdr_(new_p))), address(p))

  p <- pairlist(2,1)
  expect_identical(push_list_(p, NULL), p)
  new_p <- push_list_(p, list(3,4))
  expect_identical(new_p, pairlist(4,3,2,1))
  expect_identical(address(cdr_(cdr_(new_p))), address(p))
})


test_that("append_", {
  expect_identical(append_(NULL, NULL), pairlist(NULL))

  p <- pairlist(1)
  expect_identical(append_(p, NULL), pairlist(NULL))  # Modifies in place and returns last
  expect_identical(p, pairlist(1,NULL))               # p is modified in place

  p <- pairlist(1)
  expect_identical(append_(p, 2), pairlist(2))  # Modifies in place and returns last
  expect_identical(p, pairlist(1,2))            # p is modified in place

  p <- pairlist(1,2)
  expect_identical(append_(p, NULL), pairlist(NULL))  # Modifies in place and returns last
  expect_identical(p, pairlist(1,2,NULL))             # p is modified in place

  p <- pairlist(1,2)
  expect_identical(append_(p, 3), pairlist(3))  # Modifies in place and returns last
  expect_identical(p, pairlist(1,2,3))          # p is modified in place
})


test_that("append_list_", {
  # Error if x is empty pairlist
  expect_error(append_list_(NULL, NULL))
  expect_error(append_list_(NULL, 1))
  expect_error(append_list_(NULL, list(1)))

  # Error if lst isn't a list
  expect_error(append_list_(NULL, 1))
  expect_error(append_list_(pairlist(1), 2))
  expect_error(append_list_(pairlist(1, 2), pairlist(1,2)))


  # Starting with a real pairlist
  p <- pairlist(1)
  expect_identical(append_list_(p, NULL), p)
  last_p <- append_list_(p, list(2,3))
  expect_identical(p, pairlist(1,2,3))
  expect_identical(address(cdr_(cdr_(p))), address(last_p))

  p <- pairlist(1,2)
  expect_identical(append_list_(p, NULL), cdr_(p))
  last_p <- append_list_(p, list(3,4))
  expect_identical(p, pairlist(1,2,3,4))
  expect_identical(address(cdr_(cdr_(cdr_(p)))), address(last_p))
})