# Test exclude_ip()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_ip(qualtrics_numeric),
                                   class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_ip(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_ip(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_ip(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_ip(qualtrics_numeric)) == 16))
})
