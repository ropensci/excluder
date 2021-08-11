# Test check_duplicates()

test_that("Output class is same as input class", {
  expect_s3_class(check_duplicates(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_duplicates(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_duplicates(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 10))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 7))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16))
})
