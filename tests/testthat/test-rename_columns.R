# Test rename_columns()

test_that("alert works", {
  expect_message(rename_columns(qualtrics_numeric))
  expect_message(rename_columns(qualtrics_numeric, alert = FALSE), NA)
  expect_message(rename_columns(qualtrics_fetch), NA)
})

test_that("column names are correct", {
  expect_true(names(rename_columns(qualtrics_fetch))[1] == "StartDate")
  expect_true(names(rename_columns(qualtrics_fetch))[3] == "Status")
  expect_true(names(rename_columns(qualtrics_fetch))[16] == "Resolution")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[1] == "StartDate")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[3] == "Status")
  expect_true(names(rename_columns(use_labels(qualtrics_fetch)))[16] == "Resolution")
  expect_true(names(rename_columns(qualtrics_numeric, alert = FALSE))[1] ==
                "StartDate")
})
