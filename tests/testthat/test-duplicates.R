# Test mark_duplicates()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_duplicates(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duplicates(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duplicates(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duplicates(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(mark_duplicates(qualtrics_numeric)))
  suppressMessages(expect_no_error(mark_duplicates(qualtrics_fetch2,
    id_col = "Response ID"
  )))
  suppressMessages(expect_error(
    mark_duplicates(qualtrics_anonymous),
    "The column 'LocationLatitude' was not found in the data frame"
  ))
})

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_duplicates(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_duplicates(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_duplicates(qualtrics_numeric, quiet = FALSE),
    "rows had duplicate IP addresses"
  ))
  expect_message(mark_duplicates(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_duplicates(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    mark_duplicates(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_duplicates(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duplicates(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_duplicates(qualtrics_numeric, include_na = TRUE)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duplicates(qualtrics_numeric, include_na = TRUE)) == 17
  ))
})

# Test check_duplicates()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_duplicates(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duplicates(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duplicates(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duplicates(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(check_duplicates(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_duplicates(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_duplicates(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_duplicates(qualtrics_numeric, quiet = FALSE),
    "rows had duplicate IP addresses"
  ))
  expect_message(check_duplicates(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_duplicates(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_duplicates(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_duplicates(qualtrics_numeric)) == 10
  ))
  suppressMessages(expect_true(
    ncol(check_duplicates(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 10
  ))
  suppressMessages(expect_true(
    ncol(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 7
  ))
  suppressMessages(expect_true(
    ncol(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duplicates(qualtrics_numeric, include_na = TRUE)) == 13
  ))
  suppressMessages(expect_true(
    ncol(check_duplicates(qualtrics_numeric, include_na = TRUE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duplicates(qualtrics_numeric, keep = TRUE)) == 10
  ))
  suppressMessages(expect_true(
    ncol(check_duplicates(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_duplicates(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_duplicates"
  ))
})

# Test exclude_duplicates()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_duplicates(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_duplicates(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_duplicates(qualtrics_numeric))[1]
  == "StartDate"))
  suppressMessages(expect_true(names(exclude_duplicates(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(exclude_duplicates(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_duplicates(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(exclude_duplicates(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_duplicates(qualtrics_numeric, quiet = FALSE),
    "rows had duplicate IP addresses"
  ))
  suppressMessages(expect_message(
    exclude_duplicates(qualtrics_numeric, silent = FALSE),
    "duplicate rows were excluded"
  ))
  expect_message(
    exclude_duplicates(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  expect_visible(
    exclude_duplicates(qualtrics_numeric, quiet = TRUE, silent = TRUE)
  )
  expect_invisible(
    exclude_duplicates(qualtrics_numeric,
      quiet = TRUE, print = FALSE,
      silent = TRUE
    )
  )
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(exclude_duplicates(qualtrics_numeric)) == 90
  ))
  suppressMessages(expect_true(
    ncol(exclude_duplicates(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 90
  ))
  suppressMessages(expect_true(
    ncol(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 93
  ))
  suppressMessages(expect_true(
    ncol(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_duplicates(qualtrics_numeric, include_na = TRUE)) == 87
  ))
  suppressMessages(expect_true(
    ncol(exclude_duplicates(qualtrics_numeric, include_na = TRUE)) == 16
  ))
})
