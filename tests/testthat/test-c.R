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
