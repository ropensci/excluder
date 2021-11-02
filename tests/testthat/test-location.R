# Test mark_location()

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_location(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages displayed by default", {
  suppressMessages(expect_message(mark_location(qualtrics_numeric)))
})

test_that("No mark messages displayed when quiet = TRUE", {
  expect_message(mark_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_location(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_location(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_location(qualtrics_numeric, include_na = TRUE)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_location(qualtrics_numeric, include_na = TRUE)) == 17
  ))
})

# Test check_location()

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_location(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages displayed by default", {
  suppressMessages(expect_message(check_location(qualtrics_numeric)))
})

test_that("No check messages displayed when quiet = TRUE", {
  expect_message(check_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_location(qualtrics_numeric)) == 6
  ))
  suppressMessages(expect_true(
    ncol(check_location(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_location(qualtrics_numeric, include_na = TRUE)) == 5
  ))
  suppressMessages(expect_true(
    ncol(check_location(qualtrics_numeric, include_na = TRUE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_location(qualtrics_numeric, keep = TRUE)) == 6
  ))
  suppressMessages(expect_true(
    ncol(check_location(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_location(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_location"
  ))
})

# Test exclude_location()

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_location(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages displayed by default", {
  suppressMessages(expect_message(exclude_location(qualtrics_numeric)))
})

test_that("No exclude messages displayed when quiet = TRUE and silent = TRUE", {
  expect_message(
    exclude_location(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(exclude_location(qualtrics_numeric)) == 94
  ))
  suppressMessages(expect_true(
    ncol(exclude_location(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_location(qualtrics_numeric, include_na = TRUE)) == 95
  ))
  suppressMessages(expect_true(
    ncol(exclude_location(qualtrics_numeric, include_na = TRUE)) == 16
  ))
})
