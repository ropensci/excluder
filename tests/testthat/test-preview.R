# Test mark_preview()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_preview(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_preview(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_preview(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_preview(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(mark_preview(qualtrics_numeric)))
  suppressMessages(expect_no_error(mark_preview(qualtrics_fetch2,
    id_col = "Response ID"
  )))
  suppressMessages(expect_no_error(mark_preview(qualtrics_anonymous)))
})

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_preview(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_preview(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_preview(qualtrics_numeric, quiet = FALSE),
    "rows were collected as previews"
  ))
  expect_message(mark_preview(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_preview(qualtrics_numeric, quiet = TRUE))
  expect_invisible(mark_preview(qualtrics_numeric, quiet = TRUE, print = FALSE))
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(nrow(mark_preview(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_preview(qualtrics_numeric)) == 17))
})

# Test check_preview()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_preview(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_preview(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_preview(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_preview(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(check_preview(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_preview(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_preview(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_preview(qualtrics_numeric, quiet = FALSE),
    "rows were collected as previews"
  ))
  expect_message(check_preview(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_preview(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_preview(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(nrow(check_preview(qualtrics_numeric)) == 2))
  suppressMessages(expect_true(ncol(check_preview(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(
    nrow(check_preview(qualtrics_numeric, keep = TRUE)) == 2
  ))
  suppressMessages(expect_true(
    ncol(check_preview(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_preview(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_preview"
  ))
})

# Test exclude_preview()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_preview(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_preview(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_preview(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_preview(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(exclude_preview(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_preview(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(exclude_preview(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_preview(qualtrics_numeric, quiet = FALSE),
    "rows were collected as previews"
  ))
  suppressMessages(expect_message(
    exclude_preview(qualtrics_numeric, silent = FALSE),
    "preview rows were excluded"
  ))
  expect_message(
    exclude_preview(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  expect_visible(
    exclude_preview(qualtrics_numeric, quiet = TRUE, silent = TRUE)
  )
  expect_invisible(
    exclude_preview(qualtrics_numeric,
      quiet = TRUE, print = FALSE,
      silent = TRUE
    )
  )
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(nrow(exclude_preview(qualtrics_numeric)) == 98))
  suppressMessages(expect_true(ncol(exclude_preview(qualtrics_numeric)) == 16))
})
