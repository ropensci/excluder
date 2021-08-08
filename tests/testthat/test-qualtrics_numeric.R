# Test qualtrics_numeric()

test_that("Columns are of correct type in numeric data", {
  expect_type(qualtrics_numeric$Status, "double")
  expect_type(qualtrics_numeric$Finished, "double")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_numeric$Status == 1))

  # Check for incomplete progress
  expect_true(any(qualtrics_numeric$Finished == 0))

  # Check for durations < 100 s
  expect_true(any(qualtrics_numeric$`Duration (in seconds)` < 100))

  # Check for small screen resolution
  expect_true(any(as.numeric(stringr::str_split(qualtrics_numeric$Resolution, "x", simplify = TRUE)[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_numeric, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(nrow(janitor::get_dupes(qualtrics_numeric, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
})
