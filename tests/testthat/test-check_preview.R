# Test check_preview()

test_that("Output class is same as input class", {
  expect_s3_class(check_preview(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_preview(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_preview(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_preview(qualtrics_numeric)) == 2))
  suppressMessages(expect_true(ncol(check_preview(qualtrics_numeric)) == 16))
})
