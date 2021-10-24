#' Mark minimum or maximum durations
#'
#' @description
#' The `mark_duration()` function creates a column labeling
#' rows with fast and/or slow duration.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' By default, minimum durations of 10 seconds are checked, but either
#' minima or maxima can be checked with the `min_duration` and
#' `max_duration` arguments. The function outputs to console separate
#' messages about the number of rows that are too fast or too slow.
#'
#' This function returns the fast and slow rows.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param min_duration Minimum duration that is too fast in seconds.
#' @param max_duration Maximum duration that is too slow in seconds.
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param duration_col Column name for durations.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family duration functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with fast and slow duration.
#' For a function that checks for these rows, use [check_duration()].
#' For a function that excludes these rows, use [exclude_duration()].
#' @export
#'
#' @examples
#' # Mark durations faster than 100 seconds
#' data(qualtrics_text)
#' df <- mark_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration()
#'
#' # Mark only for durations slower than 800 seconds
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duration(max_duration = 800)
mark_duration <- function(x,
                          min_duration = 10,
                          max_duration = NULL,
                          id_col = "ResponseId",
                          duration_col = "Duration (in seconds)",
                          quiet = FALSE) {

  # Check for presence of required columns
  validate_columns(x, id_col)
  validate_columns(x, duration_col)

  # Extract duration vector
  duration_vector <- x[[duration_col]]

  # Find participants quicker than minimum
  stopifnot(
    "'min_duration' should have a single value" =
      length(min_duration) == 1L
  )
  if (!is.null(min_duration)) {
    too_quick <- x[which(duration_vector < min_duration), ]
    too_quick <- dplyr::mutate(too_quick, exclusion_duration = "duration_quick")
    too_quick_slow <- too_quick
    n_too_quick <- nrow(too_quick)
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_too_quick} out of {nrow(x)} row{?s} took less time than {min_duration}."
      )
    }
  }

  # Find participants slower than maximum
  if (!is.null(max_duration)) {
    stopifnot(
      "'max_duration' should have a single value" =
        length(max_duration) == 1L
    )
    too_slow <- x[which(duration_vector > max_duration), ]
    too_slow <- dplyr::mutate(too_slow, exclusion_duration = "duration_slow")
    too_quick_slow <- too_slow
    n_too_slow <- nrow(too_slow)
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_too_slow} out of {nrow(x)} row{?s} took more time than {max_duration}."
      )
    }
  }

  # Combine quick and slow participants
  if (!is.null(min_duration) && !is.null(max_duration)) {
    too_quick_slow <- dplyr::bind_rows(too_quick, too_slow)
  } else if (is.null(min_duration) && is.null(max_duration)) {
    stop("You must specify either a minimum or maximum duration.'")
    too_quick_slow <- NULL
  }

  # Find rows to mark
  exclusions <- too_quick_slow %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_duration)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
    dplyr::mutate(
      exclusion_duration =
        stringr::str_replace_na(
          .data$exclusion_duration, ""
        )
    ))
}

#' Check for minimum or maximum durations
#'
#' @description
#' The `check_duration()` function subsets rows of data, retaining rows
#' that have durations that are too fast or too slow.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' By default, minimum durations of 10 seconds are checked, but either
#' minima or maxima can be checked with the `min_duration` and
#' `max_duration` arguments. The function outputs to console separate
#' messages about the number of rows that are too fast or too slow.
#'
#' This function returns the fast and slow rows.
#'
#' @inheritParams mark_duration
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#' @family duration functions
#' @family check functions
#' @return
#' An object of the same type as `x` that includes the rows with fast and/or
#' slow duration.
#' For a function that marks these rows, use [mark_duration()].
#' For a function that excludes these rows, use [exclude_duration()].
#' @export
#'
#' @examples
#' # Check for durations faster than 100 seconds
#' data(qualtrics_text)
#' check_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100)
#'
#' # Check only for durations slower than 800 seconds
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(max_duration = 800)
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100, print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_duration(min_duration = 100, quiet = TRUE)
check_duration <- function(x,
                           min_duration = 10,
                           max_duration = NULL,
                           id_col = "ResponseId",
                           duration_col = "Duration (in seconds)",
                           quiet = FALSE,
                           print = TRUE) {

  # Mark and filter duration
  exclusions <- mark_duration(x,
    min_duration = min_duration,
    max_duration = max_duration,
    id_col = id_col,
    duration_col = duration_col,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_duration == "duration_quick" |
      .data$exclusion_duration == "duration_slow") %>%
    dplyr::select(-.data$exclusion_duration)

  # Determine whether to print results
  print_data(exclusions, print)
}

#' Exclude rows with minimum or maximum durations
#'
#' @description
#' The `exclude_duration()` function removes
#' rows of data that have durations that are too fast or too slow.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_duration details
#'
#' @inheritParams mark_duration
#' @param print Logical indicating whether to print returned tibble to
#' console.
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family duration functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' with fast and/or slow duration.
#' For a function that checks for these rows, use [check_duration()].
#' For a function that marks these rows, use [mark_duration()].
#' @export
#'
#' @examples
#' # Exclude durations faster than 100 seconds
#' data(qualtrics_text)
#' df <- exclude_duration(qualtrics_text, min_duration = 100)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duration()
#'
#' # Exclude only for durations slower than 800 seconds
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duration(max_duration = 800)
exclude_duration <- function(x,
                             min_duration = 10,
                             max_duration = NULL,
                             id_col = "ResponseId",
                             duration_col = "Duration (in seconds)",
                             quiet = TRUE,
                             print = FALSE,
                             silent = FALSE) {

  # Mark and filter duration
  remaining_data <- mark_duration(x,
    min_duration = min_duration,
    max_duration = max_duration,
    id_col = id_col,
    duration_col = duration_col,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_duration != "duration_quick" &
      .data$exclusion_duration != "duration_slow") %>%
    dplyr::select(-.data$exclusion_duration)

  # Print exclusion statement

  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "rows of short and/or long duration")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
