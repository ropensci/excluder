# Test mark_duplicates()

test_that("Output class is same as input class", {
  expect_s3_class(mark_duplicates(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(mark_duplicates(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(mark_duplicates(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric,
                                                    dupl_ip = FALSE)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric,
                                                    dupl_ip = FALSE)) == 17))
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 17))
})
