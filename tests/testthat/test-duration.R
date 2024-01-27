# Test mark_duration()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_duration(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duration(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duration(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_duration(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(mark_duration(qualtrics_numeric)))
  suppressMessages(expect_no_error(mark_duration(qualtrics_fetch2,
    id_col = "Response ID"
  )))
  suppressMessages(expect_no_error(mark_duration(qualtrics_anonymous)))
})

test_that("Output class is same as input class", {
  expect_s3_class(
    mark_duration(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_duration(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_duration(qualtrics_numeric, min_duration = 10, quiet = FALSE),
    "took less time"
  ))
  suppressMessages(expect_message(
    mark_duration(qualtrics_numeric, max_duration = 200, quiet = FALSE),
    "took more time"
  ))
  expect_message(mark_duration(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_duration(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    mark_duration(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_duration(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duration(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_duration(qualtrics_numeric, min_duration = 100)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duration(qualtrics_numeric, min_duration = 100)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_duration(qualtrics_numeric, max_duration = 800)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_duration(qualtrics_numeric, max_duration = 800)) == 17
  ))
})

# Test check_duration()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_duration(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duration(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duration(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_duration(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(check_duration(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_duration(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_duration(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_duration(qualtrics_numeric, min_duration = 10, quiet = FALSE),
    "took less time"
  ))
  suppressMessages(expect_message(
    check_duration(qualtrics_numeric, max_duration = 200, quiet = FALSE),
    "took more time"
  ))
  expect_message(check_duration(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_duration(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_duration(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_duration(qualtrics_numeric)) == 0
  ))
  suppressMessages(expect_true(
    ncol(check_duration(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duration(qualtrics_numeric, min_duration = 100)) == 4
  ))
  suppressMessages(expect_true(
    ncol(check_duration(qualtrics_numeric, min_duration = 100)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duration(qualtrics_numeric, max_duration = 800)) == 2
  ))
  suppressMessages(expect_true(
    ncol(check_duration(qualtrics_numeric, max_duration = 800)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_duration(qualtrics_numeric, keep = TRUE)) == 0
  ))
  suppressMessages(expect_true(
    ncol(check_duration(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_duration(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_duration"
  ))
})

# Test exclude_duration()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_duration(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_duration(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_duration(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_duration(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(exclude_duration(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_duration(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(
    exclude_duration(qualtrics_numeric, min_duration = 10, quiet = FALSE),
    "took less time"
  ))
  suppressMessages(expect_message(
    exclude_duration(qualtrics_numeric, max_duration = 200, quiet = FALSE),
    "took more time"
  ))
  suppressMessages(expect_message(
    exclude_duration(qualtrics_numeric, silent = FALSE),
    "rows of short and/or long duration were excluded"
  ))
  expect_message(
    exclude_duration(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed or not", {
  expect_visible(
    exclude_duration(qualtrics_numeric, quiet = TRUE, silent = TRUE)
  )
  expect_invisible(
    exclude_duration(qualtrics_numeric,
      quiet = TRUE, print = FALSE,
      silent = TRUE
    )
  )
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(exclude_duration(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(exclude_duration(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_duration(qualtrics_numeric, min_duration = 100)) == 96
  ))
  suppressMessages(expect_true(
    ncol(exclude_duration(qualtrics_numeric, min_duration = 100)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_duration(qualtrics_numeric, max_duration = 800)) == 98
  ))
  suppressMessages(expect_true(
    ncol(exclude_duration(qualtrics_numeric, max_duration = 800)) == 16
  ))
})
