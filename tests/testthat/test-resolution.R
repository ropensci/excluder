# Test mark_resolution()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_resolution(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_resolution(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_resolution(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_error(mark_resolution(qualtrics_fetch,
    rename = FALSE
  )))
  suppressMessages(expect_message(mark_resolution(qualtrics_numeric)))
  suppressMessages(expect_no_error(names(mark_resolution(qualtrics_fetch2,
    id_col = "Response ID"))))
})

test_that("Mark output class is same as input class", {
  expect_s3_class(
    mark_resolution(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  suppressMessages(expect_message(mark_resolution(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_resolution(qualtrics_numeric, quiet = FALSE),
    "rows had screen resolutions"
  ))
  expect_message(mark_resolution(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  expect_visible(mark_resolution(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    mark_resolution(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Marks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(mark_resolution(qualtrics_numeric)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_resolution(qualtrics_numeric)) == 17
  ))
  suppressMessages(expect_true(
    nrow(mark_resolution(qualtrics_numeric,
      height_min = 800,
      width_min = 0
    )) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_resolution(qualtrics_numeric,
      height_min = 800,
      width_min = 0
    )) == 17
  ))
})

# Test check_resolution()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_resolution(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_resolution(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_resolution(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_error(check_resolution(qualtrics_fetch,
    rename = FALSE
  )))
  suppressMessages(expect_message(check_resolution(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  expect_s3_class(
    check_resolution(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  suppressMessages(expect_message(check_resolution(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_resolution(qualtrics_numeric, quiet = FALSE),
    "rows had screen resolutions"
  ))
  expect_message(check_resolution(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  expect_visible(check_resolution(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    check_resolution(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Checks create data frames of correct size", {
  suppressMessages(expect_true(
    nrow(check_resolution(qualtrics_numeric)) == 3
  ))
  suppressMessages(expect_true(
    nrow(check_resolution(qualtrics_numeric,
      res_min = 0, width_min = 1000
    )) == 4
  ))
  suppressMessages(expect_true(
    ncol(check_resolution(qualtrics_numeric)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_resolution(qualtrics_numeric,
      height_min = 800,
      width_min = 0
    )) == 36
  ))
  suppressMessages(expect_true(
    ncol(check_resolution(qualtrics_numeric,
      height_min = 800,
      width_min = 0
    )) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_resolution(qualtrics_numeric, keep = TRUE)) == 3
  ))
  suppressMessages(expect_true(
    nrow(check_resolution(qualtrics_numeric,
      res_min = 0, width_min = 1000, keep = TRUE
    )) == 4
  ))
  suppressMessages(expect_true(
    ncol(check_resolution(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  suppressMessages(expect_true(
    names(check_resolution(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_resolution"
  ))
})

# Test exclude_resolution()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_resolution(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_resolution(qualtrics_numeric))[1]
  == "StartDate"))
  suppressMessages(expect_true(names(exclude_resolution(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_error(exclude_resolution(qualtrics_fetch,
    rename = FALSE
  )))
  suppressMessages(expect_message(exclude_resolution(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  suppressMessages(expect_s3_class(
    exclude_resolution(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  suppressMessages(expect_message(exclude_resolution(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_resolution(qualtrics_numeric, quiet = FALSE),
    "rows had screen resolutions"
  ))
  suppressMessages(expect_message(
    exclude_resolution(qualtrics_numeric, silent = FALSE),
    "rows with unacceptable screen resolution were excluded"
  ))
  expect_message(
    exclude_resolution(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  expect_visible(
    exclude_resolution(qualtrics_numeric, quiet = TRUE, silent = TRUE)
  )
  expect_invisible(
    exclude_resolution(qualtrics_numeric,
      quiet = TRUE, print = FALSE,
      silent = TRUE
    )
  )
})

test_that("Excludes create data frames of correct size", {
  suppressMessages(
    expect_true(nrow(exclude_resolution(qualtrics_numeric,
      res_min = 0, width_min = 1000
    )) == 96)
  )
  suppressMessages(
    expect_true(nrow(exclude_resolution(qualtrics_numeric)) == 97)
  )
  suppressMessages(
    expect_true(ncol(exclude_resolution(qualtrics_numeric)) == 16)
  )
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric,
    height_min = 800,
    width_min = 0
  )) == 64))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric,
    height_min = 800,
    width_min = 0
  )) == 16))
})
