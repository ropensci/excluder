# Test collapse_exclusions()

test_that("Output class is same as input class", {
  df <- qualtrics_text %>%
    mark_duplicates(quiet = TRUE) %>%
    mark_duration(min_duration = 100, quiet = TRUE)
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(collapse_exclusions(df), class(df))
})

test_that("Data frames are correct size", {
  df <- qualtrics_text %>%
    mark_duplicates(quiet = TRUE) %>%
    mark_duration(min_duration = 100, quiet = TRUE) %>%
    mark_ip(quiet = TRUE) %>%
    mark_location(quiet = TRUE) %>%
    mark_preview(quiet = TRUE) %>%
    mark_progress(quiet = TRUE) %>%
    mark_resolution(quiet = TRUE)
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_true(ncol(collapse_exclusions(df)) == 17)
  expect_true(ncol(collapse_exclusions(df,
                                       exclusion_types =
                                         c("duplicates", "duration", "ip"))) == 21)
})

test_that("Error displayed when exclusion columns not present", {
  withr::local_options(lifecycle_verbosity = "quiet")
  suppressMessages(expect_error(collapse_exclusions(qualtrics_numeric)))
})

test_that("Warning is issued (because deprecated)", {
  df <- qualtrics_text %>%
    mark_duplicates(quiet = TRUE) %>%
    mark_duration(min_duration = 100, quiet = TRUE)
  suppressMessages(expect_warning(collapse_exclusions(df)))
})
