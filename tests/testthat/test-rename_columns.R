# Test rename_columns()

qualtrics_wrong <- qualtrics_fetch %>%
  dplyr::rename(date = StartDate)

test_that("alert works", {
  expect_message(rename_columns(qualtrics_numeric), "The columns are already named correctly")
  expect_message(rename_columns(qualtrics_wrong), "The columns cannot be renamed")
  expect_no_message(rename_columns(qualtrics_numeric, alert = FALSE))
  expect_no_message(rename_columns(qualtrics_fetch))
  expect_no_message(rename_columns(qualtrics_fetch2))
  expect_message(rename_columns(qualtrics_anonymous), "The columns are already named correctly")
})

test_that("column names are correct", {
  expect_true(names(rename_columns(qualtrics_fetch))[1] == "StartDate")
  expect_true(names(rename_columns(qualtrics_fetch))[3] == "Status")
  expect_true(names(rename_columns(qualtrics_fetch))[16] == "Resolution")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[1] == "StartDate")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[3] == "Status")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[16] == "Resolution")
  expect_true(names(rename_columns(qualtrics_numeric, alert = FALSE))[1] == "StartDate")
})

test_that("dataframes without resolution column are OK", {
  suppressMessages(expect_no_error(rename_columns(qualtrics_anonymous)))
})
