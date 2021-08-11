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
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric)) == 18))
  suppressMessages(expect_true(nrow(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 36))
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 18))
})
