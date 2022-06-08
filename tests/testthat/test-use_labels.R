test_that("alert works", {
  expect_error(use_labels(qualtrics_numeric))
  expect_error(use_labels(qualtrics_fetch, NA))
})

test_that("labels are correct", {
  expect_true(colnames(qualtrics_numeric)[1] == "StartDate")
  expect_true(colnames(qualtrics_fetch)[1] == "StartDate")
  expect_true(colnames(use_labels(qualtrics_fetch))[1] == "Start Date")
  expect_true(colnames(qualtrics_fetch)[16] == "Q1_Resolution")
  expect_true(colnames(use_labels(qualtrics_fetch))[16] == "Resolution")
})
