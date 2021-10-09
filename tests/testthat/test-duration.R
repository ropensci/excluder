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

# Test check_duration()

test_that("Output class is same as input class", {
  expect_s3_class(check_duration(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
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

# Test exclude_duration()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_duration(qualtrics_numeric),
                                   class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_duration(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE and silent = TRUE", {
  expect_message(exclude_duration(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, min_duration = 100)) == 96))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, min_duration = 100)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, max_duration = 800)) == 98))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, max_duration = 800)) == 16))
})
