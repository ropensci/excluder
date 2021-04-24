# Test data validity

test_that("Columns are of correct type in numeric and text data", {
  # Check columns in numeric value are all numerics
  expect_type(qualtrics_numeric$Status, "double")
  expect_type(qualtrics_numeric$Finished, "double")

  # Check columns in choice text are all character strings
  expect_type(qualtrics_text$Status, "character")
  expect_type(qualtrics_text$Finished, "logical")
  expect_type(qualtrics_raw$Status, "character")
  expect_type(qualtrics_raw$Finished, "character")
})
test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_numeric$Status == 1))
  expect_true(any(qualtrics_text$Status == "Survey Preview"))
  expect_true(any(qualtrics_raw$Status == "Survey Preview"))

  # Check for incomplete progress
  expect_true(any(qualtrics_numeric$Finished == 0))
  expect_true(any(qualtrics_text$Finished == FALSE))
  expect_true(any(qualtrics_raw$Finished == FALSE))

  # Check for durations < 100 s
  expect_true(any(qualtrics_numeric$`Duration (in seconds)` < 100))
  expect_true(any(qualtrics_text$`Duration (in seconds)` < 100))
  expect_true(any(as.numeric(qualtrics_text$`Duration (in seconds)`) < 100))

  # Check for small screen resolution
  expect_true(any(as.numeric(stringr::str_split(qualtrics_numeric$Resolution, "x", simplify = TRUE)[, 1]) < 1000))
  expect_true(any(as.numeric(stringr::str_split(qualtrics_text$Resolution, "x", simplify = TRUE)[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_numeric, IPAddress)) > 0)
  expect_true(nrow(janitor::get_dupes(qualtrics_text, IPAddress)) > 0)
  expect_true(nrow(janitor::get_dupes(qualtrics_raw, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(nrow(janitor::get_dupes(qualtrics_numeric, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
  expect_true(nrow(janitor::get_dupes(qualtrics_text, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
  expect_true(nrow(janitor::get_dupes(qualtrics_raw, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
})
