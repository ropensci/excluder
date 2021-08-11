# Test check_ip()

test_that("Output class is same as input class", {
  expect_s3_class(check_ip(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_ip(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_ip(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_ip(qualtrics_numeric)) == 4))
  suppressMessages(expect_true(ncol(check_ip(qualtrics_numeric)) == 16))
})
