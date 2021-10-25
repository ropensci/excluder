# Test deidentify()

test_that("deidentify() creates data frames of correct size", {
  # Test dimension of all data sets before and after applying deidentify()
  expect_true(ncol(qualtrics_numeric) == 16)
  expect_true(ncol(deidentify(qualtrics_numeric)) == 8)
  expect_true(ncol(deidentify(qualtrics_numeric, strict = FALSE)) == 12)
  expect_true(ncol(qualtrics_text) == 16)
  expect_true(ncol(deidentify(qualtrics_text)) == 8)
  expect_true(ncol(deidentify(qualtrics_text, strict = FALSE)) == 12)
  expect_true(ncol(qualtrics_raw) == 16)
  expect_true(ncol(deidentify(qualtrics_raw)) == 8)
  expect_true(ncol(deidentify(qualtrics_raw, strict = FALSE)) == 12)
})

test_that("non-strict columns are removed", {
  expect_false("IPAddress" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("LocationLatitude" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("LocationLongitude" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("UserLanguage" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("IP Address" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("Location Latitude" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("Location Longitude" %in%
    colnames(deidentify(qualtrics_numeric)))
  expect_false("User Language" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("IPAddress" %in% colnames(deidentify(qualtrics_numeric)))
})

test_that("strict columns are removed properly", {
  expect_false("Browser" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("Version" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("Operating System" %in% colnames(deidentify(qualtrics_numeric)))
  expect_false("Resolution" %in% colnames(deidentify(qualtrics_numeric)))
  expect_true("Browser" %in% colnames(deidentify(qualtrics_numeric,
    strict = FALSE
  )))
  expect_true("Version" %in% colnames(deidentify(qualtrics_numeric,
    strict = FALSE
  )))
  expect_true("Operating System" %in% colnames(deidentify(qualtrics_numeric,
    strict = FALSE
  )))
  expect_true("Resolution" %in% colnames(deidentify(qualtrics_numeric,
    strict = FALSE
  )))
})
