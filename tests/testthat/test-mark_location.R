# Test mark_location()

test_that("Output class is same as input class", {
  expect_s3_class(mark_location(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(mark_location(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(mark_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(nrow(mark_location(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_location(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_location(qualtrics_numeric,
                                                  include_na = TRUE)) == 100))
  suppressMessages(expect_true(ncol(mark_location(qualtrics_numeric,
                                                  include_na = TRUE)) == 17))
})
