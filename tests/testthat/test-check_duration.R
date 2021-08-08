# Test check_duration()

test_that("Output class is same as input class", {
  expect_s3_class(check_duration(qualtrics_numeric, quiet = TRUE), class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_duration(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_duration(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric)) == 0))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric, min_duration = 100)) == 4))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric, min_duration = 100)) == 16))
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric, max_duration = 800)) == 2))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric, max_duration = 800)) == 16))
})
