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
                            location_col = c("LocationLatitude",
                                             "LocationLongitude"),
                            dupl_ip = TRUE,
                            dupl_location = TRUE,
                            include_na = FALSE,
                            quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(x)
  ## id_col
  stopifnot("'id_col' should only have a single column name." =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## location_col
  stopifnot("'location_col' must have two columns: latitude and longitude." =
              length(id_col) == 1L)
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) {
    stop("The column specifying location ('location_col') was not found.")
  }
  ## ip_col
  stopifnot("'ip_col' should have a single column name"= length(ip_col) == 1L)
  if (!ip_col %in% column_names) {
    stop("The column specifying IP address ('ip_col') was not found.")
  }

  # Extract IP address, latitude, and longitude vectors
  ip_vector <- x[[ip_col]]
  latitude <- x[[location_col[1]]]
  longitude <- x[[location_col[2]]]

  # Check column types
  ## IP address column
  if (is.character(ip_vector)) {
    classify_ip <- iptools::ip_classify(ip_vector)
    if (any(classify_ip == "Invalid" | all(is.na(classify_ip)), na.rm = TRUE)) {
      stop("Invalid IP addresses in 'ip_col'.")
    }
  } else {
    stop("Please ensure 'ip_col' data type is character.")
  }

  ## Latitude and longitude columns
  if (!is.numeric(latitude)) {
    stop("Please ensure latitude column data type is numeric.")
  }
  if (!is.numeric(longitude)) {
    stop("Please ensure longitude column data type is numeric.")
  }

  # Check for duplicate IP addresses
  if (identical(dupl_ip, TRUE)) {
    if (identical(include_na, FALSE)) {
      no_nas <- tidyr::drop_na(x, tidyselect::all_of(ip_col))
    }
    same_ip <- janitor::get_dupes(no_nas, tidyselect::all_of(ip_col)) %>%
      dplyr::select(-.data$dupe_count)
    n_same_ip <- nrow(same_ip)
    if (identical(quiet, FALSE)) {
      message(n_same_ip, " out of ", nrow(no_nas),
              " rows have duplicate IP addresses.")
    }
  }

  # Check for duplicate locations
  if (identical(dupl_location, TRUE)) {
    if (identical(include_na, FALSE)) {
      n_nas <- ncol(x) - ncol(tidyr::drop_na(x, tidyselect::any_of(location_col)))
      no_nas <- tidyr::drop_na(x, tidyselect::any_of(location_col))
      if (identical(quiet, FALSE)) {
        message(n_nas, " NAs were found in location.")
      }
    }
    same_location <- janitor::get_dupes(no_nas, tidyselect::all_of(location_col)) %>%
      dplyr::select(-.data$dupe_count)
    n_same_location <- nrow(same_location)
    if (identical(quiet, FALSE)) {
      message(n_same_location, " out of ", nrow(no_nas),
              " rows have duplicate locations.")
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
    stop(paste0("You must specify location or IP address checks with ",
                "'dupl_location' or 'dupl_ip'."))
  }

  # Find rows to mark
  exclusions <- duplicates %>%
    dplyr::mutate(exclusion_duplicates = "duplicates") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_duplicates) %>%
    dplyr::distinct()

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
              dplyr::mutate(exclusion_duplicates =
                              stringr::str_replace_na(.data$exclusion_duplicates, ""))
  )
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
                             location_col = c("LocationLatitude",
                                              "LocationLongitude"),
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
                                quiet = quiet) %>%
    dplyr::filter(.data$exclusion_duplicates == "duplicates") %>%
    dplyr::select(-.data$exclusion_duplicates)

  # Determine whether to print results
  if (identical(print, TRUE)) {
    return(exclusions)
  } else {
    invisible(exclusions)
  }
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
                               location_col = c("LocationLatitude",
                                                "LocationLongitude"),
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
                                    quiet = quiet) %>%
    dplyr::filter(.data$exclusion_duplicates != "duplicates") %>%
    dplyr::select(-.data$exclusion_duplicates)

  # Print exclusion statement
  n_remaining <- nrow(remaining_data)
  n_exclusions <- nrow(x) - n_remaining
  if (identical(silent, FALSE)) {
    message(n_exclusions, " out of ", nrow(x),
            " duplicate rows were excluded, leaving ", n_remaining, " rows.")
  }

  # Determine whether to print results
  if (identical(print, TRUE)) {
    return(remaining_data)
  } else {
    invisible(remaining_data)
  }
}
