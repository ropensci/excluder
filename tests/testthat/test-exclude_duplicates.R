# Test exclude_duplicates()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_duplicates(qualtrics_numeric), class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_duplicates(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(exclude_duplicates(qualtrics_numeric, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 93))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16))
})
