context("Stack2")

test_that("Basic operations", {
  s <- Stack2()
  expect_true(s$isempty())
  expect_identical(s$size(), 0L)

  s$push(5)$push(6)$push(NULL)$push(list(a=1,b=2))

  expect_identical(s$pop(), list(a=1,b=2))
  expect_identical(s$peek(), NULL)
  expect_identical(s$pop(), NULL)
  expect_identical(s$size(), 2L)

  # as_list() returns in the reverse order that they were inserted
  expect_identical(s$as_list(), list(6, 5))

  expect_identical(s$reset(), s)
  expect_identical(s$size(), 0L)
})


test_that("Pushing multiple", {
  s <- Stack2()
  s$push(1,2,3)
  s$push(4,5, .list=list(6,list(7,8)))
  s$push(9,10)
  expect_identical(s$as_list(), list(10,9,list(7,8),6,5,4,3,2,1))
  expect_identical(s$pop(), 10)
  expect_identical(s$pop(), 9)
  expect_identical(s$pop(), list(7,8))
})


test_that("Popping from empty stack", {
  s <- Stack2()
  expect_null(s$pop())
  expect_null(s$pop())
  expect_null(s$peek())
  expect_true(s$isempty())

  s$push(5)$push(6)
  expect_identical(s$as_list(), list(6, 5))
})
