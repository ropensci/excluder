# Test exclude_preview()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_preview(qualtrics_numeric), class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_preview(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_preview(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_preview(qualtrics_numeric)) == 98))
  suppressMessages(expect_true(ncol(exclude_preview(qualtrics_numeric)) == 16))
})
