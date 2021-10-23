#' Mark IP addresses from outside of a specified country.
#'
#' @description
#' The `mark_ip()` function creates a column labeling
#' rows of data that have IP addresses from outside the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The function uses [iptools::country_ranges()] to assign IP addresses to
#' specific countries using
#' [ISO 3166-1 alpha-2 country codes](
#' https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
#'
#' The function outputs to console a message about the number of rows
#' with IP addresses outside of the specified country. If there are `NA`s for IP
#' addresses (likely due to including preview data---see [check_preview()]), it
#' will print a message alerting to the number of rows with `NA`s.
#'
#' @param x Data frame or tibble (preferably imported from Qualtrics using
#' \{qualtRics\}).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param ip_col Column name for IP addresses.
#' @param country Two-letter abbreviation of country to check (default is "US").
#' @param quiet Logical indicating whether to print message to console.

#' @family ip functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with IP addresses outside of the specified country.
#' For a function that checks these rows, use [check_ip()].
#' For a function that excludes these rows, use [exclude_ip()].
#' @export
#'
#' @examples
#' # Mark IP addresses outside of the US
#' data(qualtrics_text)
#' df <- mark_ip(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_ip()
#'
#' # Mark IP addresses outside of Germany
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_ip(country = "DE")
mark_ip <- function(x,
                    id_col = "ResponseId",
                    ip_col = "IPAddress",
                    country = "US",
                    quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(x)
  ## id_col
  stopifnot(
    "'id_col' should only have a single column name" =
      length(id_col) == 1L
  )
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## ip_col
  stopifnot(
    "'ip_col' should only have a single column name" =
      length(ip_col) == 1L
  )
  if (!ip_col %in% column_names) {
    stop("The column specifying IP address ('ip_col') was not found.")
  }

  # Extract IP address, latitude, and longitude vectors
  ip_vector <- x[[ip_col]]

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

  # Remove rows with NAs for IP addresses
  na_rows <- which(is.na(ip_vector))
  n_na_rows <- length(na_rows)
  if (n_na_rows > 0 && identical(quiet, FALSE)) {
    message(
      n_na_rows, " out of ", nrow(x),
      paste0(
        " rows have NA values for IP addresses (check for preview ",
        "data with 'check_preview()')."
      )
    )
  }
  if (n_na_rows > 0) {
    filtered_data <- x[-na_rows, ]
  } else {
    filtered_data <- x
  }

  # Get IP ranges for specified country
  country_ip_ranges <- unlist(iptools::country_ranges(country))

  # Filter data based on IP ranges
  survey_ips <- filtered_data[[ip_col]]
  attr(survey_ips, "label") <- NULL
  outside_country <- !iptools::ip_in_any(survey_ips, country_ip_ranges)
  filtered_data <- dplyr::bind_cols(filtered_data, outside = outside_country)
  filtered_data <- dplyr::filter(filtered_data, .data$outside == TRUE) %>%
    dplyr::select(-.data$outside)
  n_outside_country <- nrow(filtered_data)

  # Print message and return output
  if (identical(quiet, FALSE)) {
    message(
      n_outside_country, " out of ", nrow(x),
      " rows have IP addresses outside of ", country, "."
    )
  }

  # Find rows to mark
  exclusions <- filtered_data %>%
    dplyr::mutate(exclusion_ip = "ip_outside_country") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_ip)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
    dplyr::mutate(
      exclusion_ip =
        stringr::str_replace_na(.data$exclusion_ip, "")
    ))
}

#' Check for IP addresses from outside of a specified country.
#'
#' @description
#' The `check_ip()` function subsets rows of data, retaining rows
#' that have IP addresses from outside the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' The function uses [iptools::country_ranges()] to assign IP addresses to
#' specific countries using
#' [ISO 3166-1 alpha-2 country codes](
#' https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
#'
#' The function outputs to console a message about the number of rows
#' with IP addresses outside of the specified country. If there are `NA`s for IP
#' addresses (likely due to including preview data---see [check_preview()]), it
#' will print a message alerting to the number of rows with `NA`s.
#'
#' @inheritParams mark_ip
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#' @family ip functions
#' @family check functions
#' @return
#' An object of the same type as `x` that includes the rows with
#' IP addresses outside of the specified country.
#' For a function that marks these rows, use [mark_ip()].
#' For a function that excludes these rows, use [exclude_ip()].
#'
#' @note
#' This function requires internet connectivity as it uses the
#' [iptools::country_ranges()] function, which pulls daily updated data
#' from \url{http://www.iwik.org/ipcountry/}.
#'
#' @export
#' @examples
#' # Check for IP addresses outside of the US
#' data(qualtrics_text)
#' check_ip(qualtrics_text)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip()
#'
#' # Check for IP addresses outside of Germany
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip(country = "DE")
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip(print = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip(quiet = TRUE)
check_ip <- function(x,
                     id_col = "ResponseId",
                     ip_col = "IPAddress",
                     country = "US",
                     quiet = FALSE,
                     print = TRUE) {

  # Mark and filter ip
  exclusions <- mark_ip(x,
    id_col = id_col,
    ip_col = ip_col,
    country = country,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_ip == "ip_outside_country") %>%
    dplyr::select(-.data$exclusion_ip)

  # Determine whether to print results
  if (identical(print, TRUE)) {
    return(exclusions)
  } else {
    invisible(exclusions)
  }
}

#' Exclude IP addresses from outside of a specified country.
#'
#' @description
#' The `exclude_ip()` function removes rows of data that have
#' IP addresses from outside the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_ip details
#'
#' @inheritParams mark_ip
#' @param print Logical indicating whether to print returned tibble to
#' console.
#' @param silent Logical indicating whether to print message to console. Note
#' this argument controls the exclude message not the check message.
#'
#' @family ip functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' with IP addresses outside of the specified country.
#' For a function that checks these rows, use [check_ip()].
#' For a function that marks these rows, use [mark_ip()].
#' @export
#'
#' @examples
#' # Exclude IP addresses outside of the US
#' data(qualtrics_text)
#' df <- exclude_ip(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_ip()
#'
#' # Exclude IP addresses outside of Germany
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_ip(country = "DE")
exclude_ip <- function(x,
                       id_col = "ResponseId",
                       ip_col = "IPAddress",
                       country = "US",
                       quiet = TRUE,
                       print = FALSE,
                       silent = FALSE) {

  # Mark and filter ip
  remaining_data <- mark_ip(x,
    id_col = id_col,
    ip_col = ip_col,
    country = country,
    quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_ip != "ip_outside_country") %>%
    dplyr::select(-.data$exclusion_ip)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x, "rows with IP addresses outside of the specified country")
  }

  # Determine whether to print results
  if (identical(print, TRUE)) {
    return(remaining_data)
  } else {
    invisible(remaining_data)
  }
}
