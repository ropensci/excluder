# Test mark_ip()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(mark_ip(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_ip(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_ip(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(mark_ip(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(mark_ip(qualtrics_numeric)))
  suppressMessages(expect_no_error(names(mark_ip(qualtrics_fetch2,
    id_col = "Response ID"))))
})

test_that("Mark output class is same as input class", {
  skip_on_cran()
  expect_s3_class(
    mark_ip(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Mark messages are displayed properly", {
  skip_on_cran()
  suppressMessages(expect_message(mark_ip(qualtrics_numeric)))
  suppressMessages(expect_message(
    mark_ip(qualtrics_numeric, quiet = FALSE),
    "rows had IP address outside of"
  ))
  expect_message(mark_ip(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Mark output is printed properly", {
  skip_on_cran()
  expect_visible(mark_ip(qualtrics_numeric, quiet = TRUE))
  expect_invisible(
    mark_ip(qualtrics_numeric, quiet = TRUE, print = FALSE)
  )
})

test_that("Marks create data frames of correct size", {
  skip_on_cran()
  suppressMessages(expect_true(nrow(mark_ip(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_ip(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(
    nrow(mark_ip(qualtrics_numeric, include_na = TRUE)) == 100
  ))
  suppressMessages(expect_true(
    ncol(mark_ip(qualtrics_numeric, include_na = TRUE)) == 17
  ))
})

# Test check_ip()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(check_ip(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_ip(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_ip(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(check_ip(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(check_ip(qualtrics_numeric)))
})

test_that("Check output class is same as input class", {
  skip_on_cran()
  expect_s3_class(
    check_ip(qualtrics_numeric, quiet = TRUE),
    class(qualtrics_numeric)
  )
})

test_that("Check messages are displayed properly", {
  skip_on_cran()
  suppressMessages(expect_message(check_ip(qualtrics_numeric)))
  suppressMessages(expect_message(
    check_ip(qualtrics_numeric, quiet = FALSE),
    "rows had IP address outside of"
  ))
  expect_message(check_ip(qualtrics_numeric, quiet = TRUE), NA)
})

test_that("Check output is printed properly", {
  skip_on_cran()
  expect_visible(check_ip(qualtrics_numeric, quiet = TRUE))
  expect_invisible(check_ip(qualtrics_numeric, quiet = TRUE, print = FALSE))
})

test_that("Checks create data frames of correct size", {
  skip_on_cran()
  suppressMessages(expect_true(nrow(check_ip(qualtrics_numeric)) == 4))
  suppressMessages(expect_true(ncol(check_ip(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(
    nrow(check_ip(qualtrics_numeric, include_na = TRUE)) == 4
  ))
  suppressMessages(expect_true(
    ncol(check_ip(qualtrics_numeric, include_na = TRUE)) == 16
  ))
  suppressMessages(expect_true(
    nrow(check_ip(qualtrics_numeric, keep = TRUE)) == 4
  ))
  suppressMessages(expect_true(
    ncol(check_ip(qualtrics_numeric, keep = TRUE)) == 17
  ))
})

test_that("Exclusion column moved to first column when keep = TRUE", {
  skip_on_cran()
  suppressMessages(expect_true(
    names(check_ip(qualtrics_numeric, keep = TRUE))[1] ==
      "exclusion_ip"
  ))
})

# Test exclude_ip()

test_that("Column names are renamed correctly", {
  suppressMessages(expect_true(names(exclude_ip(qualtrics_fetch))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_ip(qualtrics_fetch,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_ip(qualtrics_numeric))[1] ==
    "StartDate"))
  suppressMessages(expect_true(names(exclude_ip(qualtrics_numeric,
    rename = FALSE
  ))[1] ==
    "StartDate"))
  suppressMessages(expect_message(exclude_ip(qualtrics_numeric)))
})

test_that("Exclude output class is same as input class", {
  skip_on_cran()
  suppressMessages(expect_s3_class(
    exclude_ip(qualtrics_numeric),
    class(qualtrics_numeric)
  ))
})

test_that("Exclude messages are displayed properly", {
  skip_on_cran()
  suppressMessages(expect_message(exclude_ip(qualtrics_numeric)))
  suppressMessages(expect_message(
    exclude_ip(qualtrics_numeric, quiet = FALSE),
    "rows had IP address outside of"
  ))
  suppressMessages(expect_message(
    exclude_ip(qualtrics_numeric, silent = FALSE),
    "IP addresses outside of"
  ))
  expect_message(
    exclude_ip(qualtrics_numeric, quiet = TRUE, silent = TRUE), NA
  )
})

test_that("Exclude output is printed properly", {
  skip_on_cran()
  expect_visible(exclude_ip(qualtrics_numeric, quiet = TRUE, silent = TRUE))
  expect_invisible(
    exclude_ip(qualtrics_numeric, quiet = TRUE, print = FALSE, silent = TRUE)
  )
})

test_that("Excludes create data frames of correct size", {
  skip_on_cran()
  suppressMessages(expect_true(nrow(exclude_ip(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_ip(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(
    nrow(exclude_ip(qualtrics_numeric, include_na = TRUE)) == 94
  ))
  suppressMessages(expect_true(
    ncol(exclude_ip(qualtrics_numeric, include_na = TRUE)) == 16
  ))
})
