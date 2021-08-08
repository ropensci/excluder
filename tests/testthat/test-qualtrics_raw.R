# Test qualtrics_raw()

test_that("Columns are of correct type in character data", {
  expect_type(qualtrics_text$Status, "character")
  expect_type(qualtrics_text$Finished, "logical")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_raw$Status == "Survey Preview"))

  # Check for incomplete progress
  expect_true(any(qualtrics_raw$Finished == FALSE))

  # Check for durations < 100 s
  suppressWarnings(expect_true(any(as.numeric(qualtrics_raw$`Duration (in seconds)`) < 100)))

  # Check for small screen resolution
  suppressWarnings(expect_true(any(as.numeric(stringr::str_split(qualtrics_raw$Resolution, "x", simplify = TRUE)[, 1]) < 1000)))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_raw, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(nrow(janitor::get_dupes(qualtrics_raw, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
})
