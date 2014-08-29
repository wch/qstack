context("Queue2")

test_that("Basic operations", {
  q <- Queue2(3)
  q$add(1)$add(2)$add(3)
  expect_identical(q$as_list(), list(1,2,3))
  expect_identical(q$remove(), 1)
  expect_identical(q$as_list(), list(2,3))
  q$add(4)
  expect_identical(q$as_list(), list(2,3,4))
  q$add(5)$add(list(6,7))
  expect_identical(q$as_list(), list(2,3,4,5,list(6,7)))
  # Grow again
  q$add(8)$add(9)
  expect_identical(q$remove(), 2)
})


test_that("Removing from empty queue", {
  q <- Queue2()
  expect_null(q$remove())
  expect_null(q$remove())
  expect_true(q$empty())
  expect_identical(q$as_list(), list())

  q$add(5)$add(6)
  expect_identical(q$as_list(), list(5, 6))
})


test_that("Resizing", {
  # Starting index 1, grow
  q <- Queue2(3)
  q$add(1)$add(2)$add(3)
  q$.resize(5)
  expect_identical(q$q, list(1,2,3,NULL,NULL))
  expect_identical(q$as_list(), list(1,2,3))

  # Starting index 2, grow
  q <- Queue2(3)
  q$add(1)$add(2)$add(3)
  expect_identical(q$remove(), 1)
  q$.resize(4)
  expect_identical(q$q, list(2,3,NULL,NULL))
  expect_identical(q$as_list(), list(2,3))

  # Starting index 3, wrap around, grow
  q <- Queue2(3)
  q$add(1)$add(2)$add(3)
  expect_identical(q$remove(), 1)
  expect_identical(q$remove(), 2)
  q$add(4)
  q$add(5)
  q$.resize(5)
  expect_identical(q$q, list(3,4,5,NULL,NULL))
  expect_identical(q$as_list(), list(3,4,5))

  # Starting index 1, shrink
  q <- Queue2(4)
  q$add(1)$add(2)
  q$.resize(2)
  expect_identical(q$as_list(), list(1,2))
  expect_identical(q$q, list(1,2))

  # Starting index 2, shrink
  q <- Queue2(4)
  q$add(1)$add(2)$add(3)
  expect_identical(q$remove(), 1)
  q$.resize(2)
  expect_identical(q$q, list(2,3))
  expect_identical(q$as_list(), list(2,3))

  # Starting index 3, wrap around, shrink
  q <- Queue2(4)
  q$add(1)$add(2)$add(3)$add(4)
  expect_identical(q$remove(), 1)
  expect_identical(q$remove(), 2)
  q$add(5)
  q$.resize(3)
  expect_identical(q$q, list(3,4,5))
  expect_identical(q$as_list(), list(3,4,5))

  # Can't shrink smaller than number of items
  q <- Queue2(4)
  q$add(1)$add(2)$add(3)
  expect_error(q$.resize(2))
})


test_that("Operations on size 1 queue", {


})


test_that("torture test comparing Queue and Queue2", {
  q <- Queue()
  q2 <- Queue2(3)

  set.seed(1332)
  npos <- 1e4
  nneg <- 8e3
  ops <- sample(c(rep(1, npos), rep(-1, nneg)))
  ops[ops == 1] <- seq_len(npos)

  # Compare the two queues
  for (i in seq_along(ops)) {
    op <- ops[i]

    if (op < 0) {
      v1 <- q$remove()
      v2 <- q2$remove()
      if ( !identical(v1, v2) ) {
        stop("Queue and Queue2 have different result: ",
             paste(i, format(v1), format(v2)) )
      }

    } else {
      q$add(op)
      q2$add(op)
    }
  }
})
