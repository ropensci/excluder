# Test mark_resolution()

test_that("Output class is same as input class", {
  expect_s3_class(mark_resolution(qualtrics_numeric, quiet = TRUE), class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(mark_resolution(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(mark_resolution(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(nrow(mark_resolution(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_resolution(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 100))
  suppressMessages(expect_true(ncol(mark_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 17))
})
