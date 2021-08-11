# Test mark_duration()

test_that("Output class is same as input class", {
  expect_s3_class(mark_duration(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(mark_duration(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(mark_duration(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric,
                                                  min_duration = 100)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric,
                                                  min_duration = 100)) == 17))
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric,
                                                  max_duration = 800)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric,
                                                  max_duration = 800)) == 17))
})
