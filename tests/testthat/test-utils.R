# keep_marked_column()
test_that("keep_marked_column() keeps or removes column", {
  expect_true(
    ncol(keep_marked_column(qualtrics_numeric, "ResponseId", keep = TRUE)) == 16
  )
  expect_true(
    ncol(keep_marked_column(qualtrics_numeric, "ResponseId",
                            keep = FALSE)) == 15
  )
})


# print_data()

test_that("print_data() returns data visibly or invisibly", {
  expect_visible(print_data(qualtrics_numeric, print = TRUE))
  expect_invisible(print_data(qualtrics_numeric, print = FALSE))
})


#print_exclusion()

test_that("print_exclusions() calculates correctly", {
  test <- qualtrics_numeric[1:75, ]
  expect_message(print_exclusion(test, qualtrics_numeric, "test rows"),
                 "25 out of 100 test rows were excluded, leaving 75 rows")
})


# validate_columns

test_that("validate_columns() checks column number properly", {
  expect_error(mark_duplicates(qualtrics_numeric,
                               id_col = c("ResponseID", "IPAddress")),
               "requires 1 column name")
  expect_error(mark_duplicates(qualtrics_numeric, location_col = "ResponseID"),
               "requires 2 column names")
  expect_error(mark_duplicates(qualtrics_numeric,
                               location_col = c("ResponseID", "ResponseID")),
               "same column name was entered twice")
})

test_that("validate_columns() checks column names properly", {
  expect_error(validate_columns(qualtrics_numeric, "ResponseId"), NA)
  expect_error(validate_columns(qualtrics_numeric, "ResponseID"),
               "was not found in the data frame")
  expect_error(mark_duplicates(qualtrics_numeric, id_col = "ResponseID"),
               "was not found in the data frame")
  expect_error(mark_duplicates(qualtrics_numeric,
                               location = c("ResponseID", "LocationLongitude")),
               "was not found in the data frame")
  expect_error(mark_duplicates(qualtrics_numeric,
                               location = c("LocationLatitude", "ResponseID")),
               "was not found in the data frame")
})

test_that("validate_columns() checks column type properly", {
  expect_error(mark_duplicates(qualtrics_numeric, ip_col = "LocationLatitude"),
               "data type is character")
  expect_error(mark_duplicates(qualtrics_numeric,
                               location_col = c("IPAddress", "Resolution")),
               "data type is numeric")
  expect_error(mark_duration(qualtrics_numeric, duration_col = "IPAddress"),
               "data type is numeric")
  expect_error(mark_preview(qualtrics_text, preview_col = "Finished"),
               "data type is character or numeric")
  expect_error(mark_progress(qualtrics_text, finished_col = "IPAddress"),
               "data type is logical or numeric")
})
