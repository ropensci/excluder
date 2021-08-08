# Test check_location()

test_that("Output class is same as input class", {
  expect_s3_class(check_location(qualtrics_numeric, quiet = TRUE), class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_location(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_location(qualtrics_numeric)) == 6))
  suppressMessages(expect_true(ncol(check_location(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_location(qualtrics_numeric, include_na = TRUE)) == 5))
  suppressMessages(expect_true(ncol(check_location(qualtrics_numeric, include_na = TRUE)) == 16))
})
