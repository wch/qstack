context("Stack")

test_that("Basic operations", {
  s <- Stack()
  expect_true(s$empty())
  expect_identical(s$size(), 0L)

  s$push(5)$push(6)$push(7)$push(list(a=1,b=2))

  expect_identical(s$pop(), list(a=1,b=2))
  expect_identical(s$peek(), 7)
  expect_identical(s$pop(), 7)
  expect_identical(s$size(), 2L)

  # show() returns in the reverse order that they were inserted
  expect_identical(s$show(), list(6, 5))

  expect_identical(s$reset(), s)
  expect_identical(s$size(), 0L)
})

test_that("Popping from empty stack", {
  s <- Stack()
  expect_null(s$pop())
  expect_null(s$pop())
  expect_true(s$empty())

  s$push(5)$push(6)
  expect_identical(s$show(), list(6, 5))
})
