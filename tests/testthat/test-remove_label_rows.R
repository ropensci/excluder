# Test remove_label_rows()

test_that("remove_label_rows() creates data frames of correct size", {
  # Test dimension of all data sets before and after applying remove_label_rows
  expect_true(nrow(qualtrics_numeric) == 100)
  expect_true(nrow(remove_label_rows(qualtrics_numeric)) == 100)
  expect_true(nrow(qualtrics_text) == 100)
  expect_true(nrow(remove_label_rows(qualtrics_text)) == 100)
  expect_true(nrow(qualtrics_raw) == 102)
  expect_true(nrow(remove_label_rows(qualtrics_raw)) == 100)
})

test_that("non-Qualtrics data is identified", {
  expect_message(remove_label_rows(iris),
                 "This data frame does not appear to be a Qualtrics data set.")
})

test_that("columns are converted when requested", {
  expect_true(inherits(remove_label_rows(qualtrics_raw,
                                         convert = TRUE)$StartDate, "POSIXct"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$EndDate, "POSIXct"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$RecordedDate, "POSIXct"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$Progress, "numeric"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$`Duration (in seconds)`, "numeric"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$LocationLatitude, "numeric"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = TRUE)$LocationLongitude, "numeric"))
})

test_that("columns are not converted when not requested", {
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$StartDate, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$EndDate, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$RecordedDate, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$Progress, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$`Duration (in seconds)`, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$LocationLatitude, "character"))
  expect_true(inherits(remove_label_rows(qualtrics_raw, convert = FALSE)$LocationLongitude, "character"))
})
