# Test mark_resolution()

test_that("Output class is same as input class", {
  expect_s3_class(mark_resolution(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
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
  suppressMessages(expect_true(nrow(mark_resolution(qualtrics_numeric,
                                                    height_min = 800,
                                                    width_min = 0)) == 100))
  suppressMessages(expect_true(ncol(mark_resolution(qualtrics_numeric,
                                                    height_min = 800,
                                                    width_min = 0)) == 17))
})

# Test check_resolution()

test_that("Output class is same as input class", {
  expect_s3_class(check_resolution(qualtrics_numeric, quiet = TRUE),
                  class(qualtrics_numeric))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(check_resolution(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE", {
  expect_message(check_resolution(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_resolution(qualtrics_numeric)) == 4))
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 36))
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 16))
})

# Test exclude_resolution()

test_that("Output class is same as input class", {
  suppressMessages(expect_s3_class(exclude_resolution(qualtrics_numeric),
                                   class(qualtrics_numeric)))
})

test_that("Messages displayed by default", {
  suppressMessages(expect_message(exclude_resolution(qualtrics_numeric)))
})

test_that("No messages displayed when quiet = TRUE and silent = TRUE", {
  expect_message(exclude_resolution(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA)
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric,
                                                       height_min = 800,
                                                       width_min = 0)) == 64))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric,
                                                       height_min = 800,
                                                       width_min = 0)) == 16))
})
