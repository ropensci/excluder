# Test exclude_location()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_location(qualtrics_numeric), class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_location(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_location(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_location(qualtrics_numeric)) == 94))
  suppressMessages(expect_true(ncol(exclude_location(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_location(qualtrics_numeric, include_na = TRUE)) == 95))
  suppressMessages(expect_true(ncol(exclude_location(qualtrics_numeric, include_na = TRUE)) == 16))
})
