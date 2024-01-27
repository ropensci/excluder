# Test qualtrics_raw

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_raw) == 102)
  expect_true(ncol(qualtrics_raw) == 16)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_raw)[1] == "StartDate")
  expect_true(names(qualtrics_raw)[3] == "Status")
})

test_that("Columns are of correct type in character data", {
  expect_type(qualtrics_raw$Status, "character")
  expect_type(qualtrics_raw$Finished, "character")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_raw$Status == "Survey Preview"))

  # Check for incomplete progress
  expect_true(any(qualtrics_raw$Finished == FALSE))

  # Check for durations < 100 s
  suppressWarnings(
    expect_true(any(as.numeric(qualtrics_raw$`Duration (in seconds)`) < 100))
  )

  # Check for small screen resolution
  suppressWarnings(
    expect_true(any(as.numeric(stringr::str_split(
      qualtrics_raw$Resolution, "x",
      simplify = TRUE
    )[, 1]) < 1000))
  )

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_raw, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(
    nrow(janitor::get_dupes(
      qualtrics_raw,
      dplyr::any_of(
        c("LocationLatitude", "LocationLongitude")
      )
    )) > 0
  )
})

# Test qualtrics_numeric

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_numeric) == 100)
  expect_true(ncol(qualtrics_numeric) == 16)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_numeric)[1] == "StartDate")
  expect_true(names(qualtrics_numeric)[3] == "Status")
})

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
  expect_true(any(as.numeric(stringr::str_split(qualtrics_numeric$Resolution,
    "x",
    simplify = TRUE
  )[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_numeric, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(
    nrow(janitor::get_dupes(
      qualtrics_numeric,
      dplyr::any_of(
        c("LocationLatitude", "LocationLongitude")
      )
    )) > 0
  )
})

# Test qualtrics_text

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_text) == 100)
  expect_true(ncol(qualtrics_text) == 16)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_text)[1] == "StartDate")
  expect_true(names(qualtrics_text)[3] == "Status")
})

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
    simplify = TRUE
  )[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_text, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(
    nrow(janitor::get_dupes(
      qualtrics_text,
      dplyr::any_of(
        c("LocationLatitude", "LocationLongitude")
      )
    )) > 0
  )
})

# Test qualtrics_fetch

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_fetch) == 100)
  expect_true(ncol(qualtrics_fetch) == 17)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_fetch)[1] == "StartDate")
  expect_true(names(qualtrics_fetch)[3] == "Status")
})

test_that("Columns are of correct type in fetch data", {
  expect_type(qualtrics_fetch$Status, "double")
  expect_type(qualtrics_fetch$Finished, "double")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_fetch$Status == 1))

  # Check for incomplete progress
  expect_true(any(qualtrics_fetch$Finished == 0))

  # Check for durations < 100 s
  expect_true(any(qualtrics_fetch$`Duration (in seconds)` < 100))

  # Check for small screen resolution
  expect_true(any(as.numeric(stringr::str_split(qualtrics_fetch$Q1_Resolution,
                                                "x",
                                                simplify = TRUE
  )[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_fetch, IPAddress)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(
    nrow(janitor::get_dupes(
      qualtrics_fetch,
      dplyr::any_of(
        c("Location Latitude", "Location Longitude")
      )
    )) > 0
  )
})


# Test qualtrics_fetch2

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_fetch2) == 100)
  expect_true(ncol(qualtrics_fetch2) == 17)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_fetch2)[1] == "Start Date")
  expect_true(names(qualtrics_fetch2)[3] == "Response Type")
})

test_that("Columns are of correct type in fetch data", {
  expect_type(qualtrics_fetch2$`Response Type`, "double")
  expect_type(qualtrics_fetch2$Finished, "double")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_fetch2$`Response Type` == 1))

  # Check for incomplete progress
  expect_true(any(qualtrics_fetch2$Finished == 0))

  # Check for durations < 100 s
  expect_true(any(qualtrics_fetch2$`Duration (in seconds)` < 100))

  # Check for small screen resolution
  expect_true(any(as.numeric(stringr::str_split(qualtrics_fetch2$`Click to write the question text - Resolution`,
                                                "x",
                                                simplify = TRUE
  )[, 1]) < 1000))

  # Check for duplicate IP addresses
  expect_true(nrow(janitor::get_dupes(qualtrics_fetch2, `IP Address`)) > 0)

  # Check for duplicate latitude and longitude
  expect_true(
    nrow(janitor::get_dupes(
      qualtrics_fetch2,
      dplyr::any_of(
        c("Location Latitude", "Location Longitude")
      )
    )) > 0
  )
})


# Test qualtrics_anonymous

test_that("Row and column numbers are correct", {
  expect_true(nrow(qualtrics_anonymous) == 100)
  expect_true(ncol(qualtrics_anonymous) == 10)
})

test_that("Column names are correct", {
  expect_true(names(qualtrics_anonymous)[1] == "StartDate")
  expect_true(names(qualtrics_anonymous)[3] == "Status")
})

test_that("Columns are of correct type in fetch data", {
  expect_type(qualtrics_anonymous$Status, "double")
  expect_type(qualtrics_anonymous$Finished, "double")
})

test_that("Data sets include exclusion criteria", {
  # Check for preview surveys
  expect_true(any(qualtrics_anonymous$Status == 1))

  # Check for incomplete progress
  expect_true(any(qualtrics_anonymous$Finished == 0))

  # Check for durations < 100 s
  expect_true(any(qualtrics_anonymous$`Duration (in seconds)` < 100))
})
