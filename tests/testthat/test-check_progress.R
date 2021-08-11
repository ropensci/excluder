# Test check_progress()

test_that("Output class is same as input class", {
  expect_s3_class(check_progress(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_progress(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_progress(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_progress(qualtrics_numeric)) == 6))
  suppressMessages(expect_true(ncol(check_progress(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_progress(qualtrics_numeric, min_progress = 98)) == 5))
  suppressMessages(expect_true(ncol(check_progress(qualtrics_numeric, min_progress = 98)) == 16))
})
