# Test exclude_resolution()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_resolution(qualtrics_numeric), class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_resolution(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_resolution(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 64))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 16))
})
