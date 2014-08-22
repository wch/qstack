context("Queue")

test_that("Basic operations", {
  q <- Queue()
  expect_true(q$empty())
  expect_identical(q$size(), 0L)

  q$add(5)$add(6)$add(NULL)$add(list(a=1,b=2))

  expect_identical(q$remove(), 5)
  expect_identical(q$remove(), 6)
  expect_identical(q$peek(), NULL)
  expect_identical(q$size(), 2L)

  # as_list() returns in the order inserted
  expect_identical(q$as_list(), list(NULL, list(a=1,b=2)))

  expect_identical(q$reset(), q)
  expect_identical(q$size(), 0L)
})


test_that("Addding multiple", {
  q <- Queue()
  q$add(1,2,3)
  q$add(4,5, .list=list(6,list(7,8)))
  q$add(9,10)
  expect_identical(q$as_list(), list(1,2,3,4,5,6,list(7,8),9,10))
  expect_identical(q$remove(), 1)
  expect_identical(q$remove(), 2)
})


test_that("Removing from empty queue", {
  q <- Queue()
  expect_null(q$remove())
  expect_null(q$remove())
  expect_true(q$empty())
  expect_identical(q$as_list(), list())

  q$add(5)$add(6)
  expect_identical(q$as_list(), list(5, 6))
})
