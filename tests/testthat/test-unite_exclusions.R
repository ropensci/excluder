# Test unite_exclusions()

test_that("Output class is same as input class", {
  df <- qualtrics_text %>%
    mark_duplicates(quiet = TRUE) %>%
    mark_duration(min_duration = 100, quiet = TRUE)
  expect_s3_class(unite_exclusions(df), class(df))
})

test_that("Data frames are correct size", {
  skip_on_cran()
  skip_on_ci()
  df <- qualtrics_text %>%
    mark_duplicates(quiet = TRUE) %>%
    mark_duration(min_duration = 100, quiet = TRUE) %>%
    mark_ip(quiet = TRUE) %>%
    mark_location(quiet = TRUE) %>%
    mark_preview(quiet = TRUE) %>%
    mark_progress(quiet = TRUE) %>%
    mark_resolution(quiet = TRUE)
  expect_true(ncol(unite_exclusions(df)) == 17)
  expect_true(
    ncol(unite_exclusions(
      df,
      exclusion_types = c("duplicates", "duration", "ip")
    )) ==
      21
  )
})

test_that("Error displayed when exclusion columns not present", {
  suppressMessages(expect_error(unite_exclusions(qualtrics_numeric)))
})
