# Test qualtrics_text()

test_that("Columns are of correct type in character data", {
  expect_type(qualtrics_text$Status, "character")
  expect_type(qualtrics_text$Finished, "logical")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_text$Status == "Survey Preview"))

  # Check for incomplete progress
  expect_true(any(qualtrics_text$Finished == FALSE))

  # Check for durations < 100 s
  expect_true(any(qualtrics_text$`Duration (in seconds)` < 100))

  # Check for small screen resolution
  expect_true(any(as.numeric(stringr::str_split(qualtrics_text$Resolution,
                                                "x",
                                                simplify = TRUE)[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_text, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(nrow(janitor::get_dupes(qualtrics_text, dplyr::any_of(c("LocationLatitude", "LocationLongitude")))) > 0)
})
