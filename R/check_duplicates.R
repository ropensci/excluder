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
#' [qualtRics::fetch_survey()].
#' By default, IP address and location are both checked, but they can be
#' checked separately with the `dupl_ip` and `dupl_location` arguments.
#'
#' The function outputs to console separate messages about the number of
#' rows with duplicate IP addresses and rows with duplicate locations.
#' These counts are computed independently, so rows may be counted for both
#' types of duplicates.
#'
#' @param x Data frame or tibble (preferably exported from Qualtrics).
#' @param ip_col Column name for IP addresses.
#' @param location_col Two element vector specifying columns for latitude and
#' longitude (in that order).
#' @param dupl_ip Logical indicating whether to check IP addresses.
#' @param dupl_location Logical indicating whether to check latitude and
#' longitude.
#' @param include_na Logical indicating whether to include rows with NAs for
#' IP address and location as potentially excluded rows.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.x
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
#'   check_duplicates(print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   check_duplicates(quiet = TRUE)
check_duplicates <- function(x, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), dupl_ip = TRUE, dupl_location = TRUE, include_na = FALSE, print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(x)
  if (length(location_col) != 2) stop("Incorrect number of columns for location_col. You must specify two columns for latitude and longitude (respectively).")
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) stop("The columns specifying participant location (location_col) are incorrect. Please check your data and specify location_col.")
  if (!ip_col %in% column_names) stop("The column specifying IP address (ip_col) is incorrect. Please check your data and specify ip_col.")

  # Extract IP address, latitude, and longitude vectors
  ip_vector <- dplyr::pull(x, ip_col)
  latitude <- dplyr::pull(x, location_col[1])
  longitude <- dplyr::pull(x, location_col[2])

  # Check column types
  ## IP address column
  if (is.character(ip_vector)) {
    classify_ip <- iptools::ip_classify(ip_vector)
    if (any(classify_ip == "Invalid" | all(is.na(classify_ip)), na.rm = TRUE)) stop("Invalid IP addresses present in ip_col. Please ensure all values are valid IPv4 or IPv6 addresses.")
  } else {
    stop("Incorrect data type for ip_col. Please ensure data type is character.")
  }

  ## Latitude and longitude columns
  if (!is.numeric(latitude)) stop("Incorrect data type for latitude column. Please ensure data type is numeric.")
  if (!is.numeric(longitude)) stop("Incorrect data type for longitude column. Please ensure data type is numeric.")

  # Check for duplicate IP addresses
  if (dupl_ip == TRUE) {
    if (include_na == FALSE) {
      x <- tidyr::drop_na(x, dplyr::all_of(ip_col))
    }
    same_ip <- janitor::get_dupes(x, dplyr::all_of(ip_col)) %>%
      dplyr::select(-.data$dupe_count)
    n_same_ip <- nrow(same_ip)
    if (quiet == FALSE) {
      message(n_same_ip, " out of ", nrow(x), " rows have duplicate IP addresses.")
    }
  }

  # Check for duplicate locations
  if (dupl_location == TRUE) {
    if (include_na == FALSE) {
      n_nas <- ncol(x) - ncol(tidyr::drop_na(x, dplyr::any_of(location_col)))
      x <- tidyr::drop_na(x, dplyr::any_of(location_col))
      if (quiet == FALSE) {
        message(n_nas, " NAs were found in location.")
      }
    }
    same_location <- janitor::get_dupes(x, dplyr::all_of(location_col)) %>%
      dplyr::select(-.data$dupe_count)
    n_same_location <- nrow(same_location)
    if (quiet == FALSE) {
      message(n_same_location, " out of ", nrow(x), " rows have duplicate locations.")
    }
  }

  # Create data frame of duplicates if both location and IP address are used
  if (dupl_location == TRUE & dupl_ip == TRUE) {
    duplicates <- rbind(same_location, same_ip)
  } else if (dupl_location == TRUE) {
    duplicates <- same_location
  } else if (dupl_ip == TRUE) {
    duplicates <- same_ip
  } else {
    duplicates <- NULL
    warning("No check run. Please allow either location or IP address checks by setting dupl_location or dupl_ip to TRUE.")
  }
  if (print_tibble == TRUE) {
    return(duplicates)
  } else {
    invisible(duplicates)
  }
}
