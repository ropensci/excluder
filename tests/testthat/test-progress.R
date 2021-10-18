# Test mark_progress()

test_that("Output class is same as input class", {
  expect_s3_class(
    mark_progress(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(mark_progress(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(mark_progress(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_progress(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_progress(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_progress(qualtrics_numeric, min_progress = 98)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_progress(qualtrics_numeric, min_progress = 98)) == 17
  ))
})

# Test check_progress()

test_that("Output class is same as input class", {
  expect_s3_class(
    check_progress(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_progress(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_progress(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_progress(qualtrics_numeric)) == 6
  ))
  suppressMessages(expect_true(
    ncol(check_progress(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_progress(qualtrics_numeric, min_progress = 98)) == 5
  ))
  suppressMessages(expect_true(
    ncol(check_progress(qualtrics_numeric, min_progress = 98)) == 16
  ))
})

# Test exclude_progress()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_progress(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_progress(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE and silent = TRUE", {
  expect_message(
    exclude_progress(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(exclude_progress(qualtrics_numeric)) == 94
  ))
  suppressMessages(expect_true(
    ncol(exclude_progress(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_progress(qualtrics_numeric, min_progress = 98)) == 95
  ))
  suppressMessages(expect_true(
    ncol(exclude_progress(qualtrics_numeric, min_progress = 98)) == 16
  ))
})
