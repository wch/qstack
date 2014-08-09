context("Queue")

test_that("Basic operations", {
  q <- Queue()
  expect_true(q$empty())
  expect_identical(q$size(), 0L)

  q$add(5)$add(6)$add(7)$add(list(a=1,b=2))

  expect_identical(q$remove(), 5)
  expect_identical(q$remove(), 6)
  expect_identical(q$peek(), 7)
  expect_identical(q$size(), 2L)

  # show() returns in the order inserted
  expect_identical(q$show(), list(7, list(a=1,b=2)))

  expect_identical(q$reset(), q)
  expect_identical(q$size(), 0L)
})


test_that("madd", {
  q <- Queue()
  q$add(1,2,3)
  q$add(4,5)
  q$add(6,7)
  expect_identical(q$show(), list(1,2,3,4,5,6,7))
  expect_identical(q$remove(), 1)
  expect_identical(q$remove(), 2)
})


test_that("Removing from empty queue", {
  q <- Queue()
  expect_null(q$remove())
  expect_null(q$remove())
  expect_true(q$empty())

  q$add(5)$add(6)
  expect_identical(q$show(), list(5, 6))
})
