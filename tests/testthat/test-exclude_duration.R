# Test exclude_duration()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_duration(qualtrics_numeric),
                                   class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_duration(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_duration(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, min_duration = 100)) == 96))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, min_duration = 100)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, max_duration = 800)) == 98))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, max_duration = 800)) == 16))
})
