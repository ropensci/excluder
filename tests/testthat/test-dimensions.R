# Test the dimensions of function output

test_that("Checks create data frames of correct size", {
  # Check duplicates
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 10))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 17))
  suppressMessages(expect_true(nrow(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 7))
  suppressMessages(expect_true(ncol(check_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 17))

  # Check duration
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric)) == 0))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric, min_duration = 100)) == 4))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric, min_duration = 100)) == 16))
  suppressMessages(expect_true(nrow(check_duration(qualtrics_numeric, max_duration = 800)) == 2))
  suppressMessages(expect_true(ncol(check_duration(qualtrics_numeric, max_duration = 800)) == 16))

  # Check IP
  suppressMessages(expect_true(nrow(check_ip(qualtrics_numeric)) == 4))
  suppressMessages(expect_true(ncol(check_ip(qualtrics_numeric)) == 16))

  # Check location
  suppressMessages(expect_true(nrow(check_location(qualtrics_numeric)) == 6))
  suppressMessages(expect_true(ncol(check_location(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_location(qualtrics_numeric, include_na = TRUE)) == 5))
  suppressMessages(expect_true(ncol(check_location(qualtrics_numeric, include_na = TRUE)) == 16))

  # Check preview
  suppressMessages(expect_true(nrow(check_preview(qualtrics_numeric)) == 2))
  suppressMessages(expect_true(ncol(check_preview(qualtrics_numeric)) == 16))

  # Check progress
  suppressMessages(expect_true(nrow(check_progress(qualtrics_numeric)) == 6))
  suppressMessages(expect_true(ncol(check_progress(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(check_progress(qualtrics_numeric, min_progress = 98)) == 5))
  suppressMessages(expect_true(ncol(check_progress(qualtrics_numeric, min_progress = 98)) == 16))

  # Check resolution
  suppressMessages(expect_true(nrow(check_resolution(qualtrics_numeric)) == 4))
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric)) == 18))
  suppressMessages(expect_true(nrow(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 36))
  suppressMessages(expect_true(ncol(check_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 18))
})

test_that("Marks create data frames of correct size", {
  # Mark duplicates
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 17))
  suppressMessages(expect_true(nrow(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 100))
  suppressMessages(expect_true(ncol(mark_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 17))

  # Mark duration
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric, min_duration = 100)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric, min_duration = 100)) == 17))
  suppressMessages(expect_true(nrow(mark_duration(qualtrics_numeric, max_duration = 800)) == 100))
  suppressMessages(expect_true(ncol(mark_duration(qualtrics_numeric, max_duration = 800)) == 17))

  # Mark IP
  suppressMessages(expect_true(nrow(mark_ip(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_ip(qualtrics_numeric)) == 17))

  # Mark location
  suppressMessages(expect_true(nrow(mark_location(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_location(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_location(qualtrics_numeric, include_na = TRUE)) == 100))
  suppressMessages(expect_true(ncol(mark_location(qualtrics_numeric, include_na = TRUE)) == 17))

  # Mark preview
  suppressMessages(expect_true(nrow(mark_preview(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_preview(qualtrics_numeric)) == 17))

  # Mark progress
  suppressMessages(expect_true(nrow(mark_progress(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_progress(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_progress(qualtrics_numeric, min_progress = 98)) == 100))
  suppressMessages(expect_true(ncol(mark_progress(qualtrics_numeric, min_progress = 98)) == 17))

  # Mark resolution
  suppressMessages(expect_true(nrow(mark_resolution(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(mark_resolution(qualtrics_numeric)) == 17))
  suppressMessages(expect_true(nrow(mark_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 100))
  suppressMessages(expect_true(ncol(mark_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 17))
})

test_that("Excludes create data frames of correct size", {
  # Exclude duplicates
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 90))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric, dupl_ip = FALSE)) == 16))
  suppressMessages(expect_true(nrow(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 93))
  suppressMessages(expect_true(ncol(exclude_duplicates(qualtrics_numeric, dupl_location = FALSE)) == 16))

  # Exclude duration
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric)) == 100))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, min_duration = 100)) == 96))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, min_duration = 100)) == 16))
  suppressMessages(expect_true(nrow(exclude_duration(qualtrics_numeric, max_duration = 800)) == 98))
  suppressMessages(expect_true(ncol(exclude_duration(qualtrics_numeric, max_duration = 800)) == 16))

  # Exclude IP
  suppressMessages(expect_true(nrow(exclude_ip(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_ip(qualtrics_numeric)) == 16))

  # Exclude location
  suppressMessages(expect_true(nrow(exclude_location(qualtrics_numeric)) == 94))
  suppressMessages(expect_true(ncol(exclude_location(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_location(qualtrics_numeric, include_na = TRUE)) == 95))
  suppressMessages(expect_true(ncol(exclude_location(qualtrics_numeric, include_na = TRUE)) == 16))

  # Exclude preview
  suppressMessages(expect_true(nrow(exclude_preview(qualtrics_numeric)) == 98))
  suppressMessages(expect_true(ncol(exclude_preview(qualtrics_numeric)) == 16))

  # Exclude progress
  suppressMessages(expect_true(nrow(exclude_progress(qualtrics_numeric)) == 94))
  suppressMessages(expect_true(ncol(exclude_progress(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_progress(qualtrics_numeric, min_progress = 98)) == 95))
  suppressMessages(expect_true(ncol(exclude_progress(qualtrics_numeric, min_progress = 98)) == 16))

  # Exclude resolution
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric)) == 96))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric)) == 16))
  suppressMessages(expect_true(nrow(exclude_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 64))
  suppressMessages(expect_true(ncol(exclude_resolution(qualtrics_numeric, height_min = 800, width_min = 0)) == 16))
})

test_that("remove_label_rows() creates data frames of correct size", {
  # Test dimension of all data sets before and after applying remove_label_rows()
  expect_true(nrow(qualtrics_numeric) == 100)
  expect_true(nrow(remove_label_rows(qualtrics_numeric)) == 100)
  expect_true(nrow(qualtrics_text) == 100)
  expect_true(nrow(remove_label_rows(qualtrics_text)) == 100)
  expect_true(nrow(qualtrics_raw) == 102)
  expect_true(nrow(remove_label_rows(qualtrics_raw)) == 100)
})

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
