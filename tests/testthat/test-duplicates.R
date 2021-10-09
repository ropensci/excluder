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
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric)) == 10))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 10))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 7))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16))
})

# Test exclude_duplicates()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_duplicates(qualtrics_numeric),
                                   class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_duplicates(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE and silent = TRUE", {
  expect_message(exclude_duplicates(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric,
                                                       dupl_ip = FALSE)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric,
                                                       dupl_ip = FALSE)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 93))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16))
})
