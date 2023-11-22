# Test mark_location()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_location(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_location(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_location(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_location(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(mark_location(qualtrics_numeric)))
  suppressMessages(expect_no_error(names(mark_location(qualtrics_fetch2,
    id_col = "Response ID"))))
})

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_location(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_location(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_location(qualtrics_numeric, quiet = FALSE),
    "rows were located outside of"
  ))
  expect_message(mark_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_location(qualtrics_numeric, quiet = TRUE))
  expect_invisible
  (mark_location(qualtrics_numeric, quiet = TRUE, print = FALSE))
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

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_location(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_location(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_location(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_location(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(check_location(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_location(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_location(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_location(qualtrics_numeric, quiet = FALSE),
    "rows were located outside of"
  ))
  expect_message(check_location(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_location(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_location(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
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

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_location(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_location(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_location(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_location(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(exclude_location(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_location(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(exclude_location(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_location(qualtrics_numeric, quiet = FALSE),
    "rows were located outside of"
  ))
  suppressMessages(expect_message(
    exclude_location(qualtrics_numeric, silent = FALSE),
    "rows outside of the US were excluded"
  ))
  expect_message(
    exclude_location(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  expect_visible(
    exclude_location(qualtrics_numeric, quiet = TRUE, silent = TRUE)
  )
  expect_invisible(
    exclude_location(qualtrics_numeric,
      quiet = TRUE, print = FALSE,
      silent = TRUE
    )
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
