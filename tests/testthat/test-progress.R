# Test mark_progress()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_progress(qualtrics_fetch))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(mark_progress(qualtrics_fetch,
                                                   rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(mark_progress(qualtrics_numeric))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(mark_progress(qualtrics_numeric,
                                                   rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_message(mark_progress(qualtrics_numeric)))
})

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_progress(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_progress(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_progress(qualtrics_numeric, quiet = FALSE),
    "rows did not complete the study"
  ))
  expect_message(mark_progress(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_progress(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    mark_progress(qualtrics_numeric, quiet = TRUE, print = FALSE
    ))
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_progress(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_progress(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_progress(qualtrics_numeric, min_progress = 98)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_progress(qualtrics_numeric, min_progress = 98)) == 17
  ))
})

# Test check_progress()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_progress(qualtrics_fetch))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(check_progress(qualtrics_fetch,
                                                    rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(check_progress(qualtrics_numeric))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(check_progress(qualtrics_numeric,
                                                    rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_message(check_progress(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_progress(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_progress(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_progress(qualtrics_numeric, quiet = FALSE),
    "rows did not complete the study"
  ))
  expect_message(check_progress(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_progress(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_progress(qualtrics_numeric, quiet = TRUE, print = FALSE
    ))
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_progress(qualtrics_numeric)) == 6
  ))
  suppressMessages(expect_true(
    ncol(check_progress(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_progress(qualtrics_numeric, min_progress = 98)) == 5
  ))
  suppressMessages(expect_true(
    ncol(check_progress(qualtrics_numeric, min_progress = 98)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_progress(qualtrics_numeric, keep = TRUE)) == 6
  ))
  suppressMessages(expect_true(
    ncol(check_progress(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_progress(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_progress"
  ))
})

# Test exclude_progress()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_progress(qualtrics_fetch))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(exclude_progress(qualtrics_fetch,
                                                      rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(exclude_progress(qualtrics_numeric))[1] ==
                                 "StartDate"))
  suppressMessages(expect_true(names(exclude_progress(qualtrics_numeric,
                                                      rename = FALSE))[1] ==
                                 "StartDate"))
  suppressMessages(expect_message(exclude_progress(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_progress(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(exclude_progress(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_progress(qualtrics_numeric, quiet = FALSE),
    "rows did not complete the study"
  ))
  suppressMessages(expect_message(
    exclude_progress(qualtrics_numeric, silent = FALSE),
    "rows with incomplete progress were excluded"
  ))
  expect_message(
    exclude_progress(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  expect_visible(
    exclude_progress(qualtrics_numeric, quiet = TRUE, silent = TRUE
    ))
  expect_invisible(
    exclude_progress(qualtrics_numeric, quiet = TRUE, print = FALSE,
                     silent = TRUE
    ))
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(exclude_progress(qualtrics_numeric)) == 94
  ))
  suppressMessages(expect_true(
    ncol(exclude_progress(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(exclude_progress(qualtrics_numeric, min_progress = 98)) == 95
  ))
  suppressMessages(expect_true(
    ncol(exclude_progress(qualtrics_numeric, min_progress = 98)) == 16
  ))
})
