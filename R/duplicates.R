#' Mark duplicate IP addresses and/or locations
#'
#' @description
#' The `mark_duplicates()` function creates a column labeling
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' By default, IP address and location are both checked, but they can be
#' checked separately with the `dupl_ip` and `dupl_location` arguments.
#'
#' The function outputs to console separate messages about the number of
#' rows with duplicate IP addresses and rows with duplicate locations.
#' These counts are computed independently, so rows may be counted for both
#' types of duplicates.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ip_col Column name for IP addresses.
#' @param location_col Two element vector specifying columns for latitude and
#' longitude (in that order).
#' @param dupl_ip Logical indicating whether to check IP addresses.
#' @param dupl_location Logical indicating whether to check latitude and
#' longitude.
#' @param include_na Logical indicating whether to include rows with NAs for
#' IP address and location as potentially excluded rows.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family duplicates functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with duplicate IP addresses and/or locations.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates()]. For a function that excludes these rows,
#' use [exclude_duplicates()].
#'
#' @export
#'
#' @examples
#' # Mark duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- mark_duplicates(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duplicates()
#'
#' # Mark only for duplicate locations
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_duplicates(dupl_location = FALSE)
mark_duplicates <- function(x,
                            id_col = "ResponseId",
                            ip_col = "IPAddress",
                            location_col = c(
                              "LocationLatitude",
                              "LocationLongitude"
                            ),
                            dupl_ip = TRUE,
                            dupl_location = TRUE,
                            include_na = FALSE,
                            quiet = FALSE) {

  # Check for presence of required columns
  validate_columns(x, id_col)
  validate_columns(x, location_col)
  validate_columns(x, ip_col)

  # Extract IP address, latitude, and longitude vectors
  ip_vector <- x[[ip_col]]
  latitude <- x[[location_col[1]]]
  longitude <- x[[location_col[2]]]

  # Check for valid IP addresses
  classify_ip <- iptools::ip_classify(ip_vector)
  if (any(classify_ip == "Invalid" | all(is.na(classify_ip)), na.rm = TRUE)) {
    stop("Invalid IP addresses in 'ip_col'.")
  }

  # Check for duplicate IP addresses
  if (identical(dupl_ip, TRUE)) {
    if (identical(include_na, FALSE)) {
      no_nas <- tidyr::drop_na(x, tidyselect::all_of(ip_col))
      n_nas <- nrow(x) - nrow(no_nas)
    }
    same_ip <- janitor::get_dupes(no_nas, tidyselect::all_of(ip_col)) %>%
      dplyr::select(-.data$dupe_count)
    n_same_ip <- nrow(same_ip)
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_nas} NA{?s} w{?as/ere} found in IP addresses."
      )
      cli::cli_alert_info(
        "{n_same_ip} out of {nrow(no_nas)} row{?s} had duplicate IP addresses."
      )
    }
  }

  # Check for duplicate locations
  if (identical(dupl_location, TRUE)) {
    if (identical(include_na, FALSE)) {
      no_nas <- tidyr::drop_na(x, tidyselect::any_of(location_col))
      n_nas <- nrow(x) - nrow(no_nas)
      if (identical(quiet, FALSE)) {
        cli::cli_alert_info(
          "{n_nas} NA{?s} w{?as/ere} found in location."
        )
      }
    }
    same_location <- janitor::get_dupes(
      no_nas,
      tidyselect::all_of(location_col)
    ) %>%
      dplyr::select(-.data$dupe_count)
    n_same_location <- nrow(same_location)
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_same_location} out of {nrow(no_nas)} row{?s} had duplicate locations."
      )
    }
  }

  # Create data frame of duplicates if both location and IP address are used
  if (identical(dupl_location, TRUE) && identical(dupl_ip, TRUE)) {
    duplicates <- dplyr::bind_rows(same_location, same_ip)
  } else if (identical(dupl_location, TRUE)) {
    duplicates <- same_location
  } else if (identical(dupl_ip, TRUE)) {
    duplicates <- same_ip
  } else {
    duplicates <- NULL
    stop(paste0(
      "You must specify location or IP address checks with ",
      "'dupl_location' or 'dupl_ip'."
    ))
  }

  # Find rows to mark
  exclusions <- duplicates %>%
    dplyr::mutate(exclusion_duplicates = "duplicates") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_duplicates) %>%
    dplyr::distinct()

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
    dplyr::mutate(
      exclusion_duplicates =
        stringr::str_replace_na(
          .data$exclusion_duplicates, ""
        )
    ))
}

#' Check for duplicate IP addresses and/or locations
#'
#' @description
#' The `check_duplicates()` function subsets rows of data, retaining rows
#' that have the same IP address and/or same latitude and longitude. The
#' function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' By default, IP address and location are both checked, but they can be
#' checked separately with the `dupl_ip` and `dupl_location` arguments.
#'
#' The function outputs to console separate messages about the number of
#' rows with duplicate IP addresses and rows with duplicate locations.
#' These counts are computed independently, so rows may be counted for both
#' types of duplicates.
#'
#' @inheritParams mark_duplicates
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#' @family duplicates functions
#' @family check functions
#' @return
#' An object of the same type as `x` that includes the rows with
#' duplicate IP addresses and/or locations. This includes a column
#' called dupe_count that returns the number of duplicates.
#' For a function that marks these rows, use [mark_duplicates()].
#' For a function that excludes these rows, use [exclude_duplicates()].
#'
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' # Check for duplicate IP addresses and locations
#' data(qualtrics_text)
#' check_duplicates(qualtrics_text)
#'
#' # Check only for duplicate locations
#' qualtrics_text %>%
#'   check_duplicates(dupl_location = FALSE)
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   check_duplicates(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   check_duplicates(quiet = TRUE)
check_duplicates <- function(x,
                             id_col = "ResponseId",
                             ip_col = "IPAddress",
                             location_col = c(
                               "LocationLatitude",
                               "LocationLongitude"
                             ),
                             dupl_ip = TRUE,
                             dupl_location = TRUE,
                             include_na = FALSE,
                             quiet = FALSE,
                             print = TRUE) {

  # Mark and filter duplicates
  exclusions <- mark_duplicates(x,
    id_col = id_col,
    ip_col = ip_col,
    location_col = location_col,
    dupl_ip = dupl_ip,
    dupl_location = dupl_location,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_duplicates == "duplicates") %>%
    dplyr::select(-.data$exclusion_duplicates)

  # Determine whether to print results
  print_data(exclusions, print)
}

#' Exclude rows with duplicate IP addresses and/or locations
#'
#' @description
#' The `exclude_duplicates()` function removes
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_duplicates details
#'
#' @inheritParams mark_duplicates
#' @param print Logical indicating whether to print returned tibble to
#' console.
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family duplicates functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' with duplicate IP addresses and/or locations.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates()]. For a function that marks these rows,
#' use [mark_duplicates()].

#' @export
#'
#' @examples
#' # Exclude duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- exclude_duplicates(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates()
#'
#' # Exclude only for duplicate locations
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates(dupl_location = FALSE)
exclude_duplicates <- function(x,
                               id_col = "ResponseId",
                               ip_col = "IPAddress",
                               location_col = c(
                                 "LocationLatitude",
                                 "LocationLongitude"
                               ),
                               dupl_ip = TRUE,
                               dupl_location = TRUE,
                               include_na = FALSE,
                               quiet = TRUE,
                               print = FALSE,
                               silent = FALSE) {

  # Mark and filter duplicates
  remaining_data <- mark_duplicates(x,
    id_col = id_col,
    ip_col = ip_col,
    location_col = location_col,
    dupl_ip = dupl_ip,
    dupl_location = dupl_location,
    include_na = include_na,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_duplicates != "duplicates") %>%
    dplyr::select(-.data$exclusion_duplicates)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "duplicate rows")
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
