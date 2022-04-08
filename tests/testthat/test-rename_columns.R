# Test rename_columns()

test_that("Alert works", {
  expect_message(rename_columns(qualtrics_numeric))
  expect_message(rename_columns(qualtrics_numeric, alert = FALSE), NA)
  expect_message(rename_columns(qualtrics_fetch), NA)
})

test_that("Column names are correct", {
  expect_true(names(rename_columns(qualtrics_fetch))[1] == "StartDate")
  expect_true(names(rename_columns(qualtrics_fetch))[3] == "Status")
  expect_true(names(rename_columns(qualtrics_fetch))[16] == "Resolution")
  expect_true(names(rename_columns(qualtrics_numeric, alert = FALSE))[1] ==
                "StartDate")
})
