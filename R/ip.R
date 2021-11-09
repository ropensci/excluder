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
#' @param include_na Logical indicating whether to include rows with NA in
#' IP address column in the output list of potentially excluded data.
#' @param quiet Logical indicating whether to print message to console.
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#' @family ip functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with IP addresses outside of the specified country.
#' For a function that checks these rows, use [check_ip()].
#' For a function that excludes these rows, use [exclude_ip()].
#' @export
#'
#' @note
#' This function **requires internet connectivity** as it uses the
#' [iptools::country_ranges()] function, which pulls daily updated data
#' from \url{https://www.iwik.org/ipcountry/}. It only updates the data once
#' per session, as it caches the results for future work during the session.
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
                    include_na = FALSE,
                    quiet = FALSE,
                    print = TRUE) {

  # Check for presence of required column
  validate_columns(x, id_col)
  validate_columns(x, ip_col)

  # Extract IP address, latitude, and longitude vectors
  ip_vector <- x[[ip_col]]

  # Check for valid IP addresses
  classify_ip <- iptools::ip_classify(ip_vector)
  if (any(classify_ip == "Invalid" | all(is.na(classify_ip)), na.rm = TRUE)) {
    stop("Invalid IP addresses in 'ip_col'.")
  }

  # Remove rows with NAs for IP addresses
  na_rows <- which(is.na(ip_vector))
  n_na_rows <- length(na_rows)
  if (n_na_rows > 0 && identical(quiet, FALSE)) {
    cli::cli_alert_info(
      "{n_na_rows} out of {nrow(x)} row{?s} had NA values for IP addresses (check for preview data with 'check_preview()')."
    )
  }
  if (n_na_rows > 0) {
    filtered_data <- x[-na_rows, ]
  } else {
    filtered_data <- x
  }

  # Get IP ranges for specified country
  country_ip_ranges <- unlist(iptools::country_ranges(country))

  # Check if country_ip_ranges is valid
  if (!curl::has_internet()) {
    cli::cli_alert_warning("There is no internet connection.")
    return(invisible(NULL))
  } else if (identical(country_ip_ranges, NA)) {
    cli::cli_alert_warning("The website for downloading country IP addresses is not available. Please try again later.")
    return(invisible(NULL))
  } else if (identical(country_ip_ranges, NULL)) {
    cli::cli_alert_warning("'{country}' is not recognized as a valid country code, so IP addresses could not be checked for this country.")
    return(invisible(NULL))
  } else {
    # Filter data based on IP ranges
    survey_ips <- filtered_data[[ip_col]]
    attr(survey_ips, "label") <- NULL
    outside_country <- !iptools::ip_in_any(survey_ips, country_ip_ranges)
    filtered_data <- dplyr::bind_cols(filtered_data, outside = outside_country)
    filtered_data <- dplyr::filter(filtered_data, .data$outside == TRUE) %>%
      dplyr::select(-.data$outside)
    n_outside_country <- nrow(filtered_data)

    # Filter NAs when requested
    if (identical(include_na, TRUE)) {
      na_data <- x[na_rows, ]
      filtered_data <- dplyr::bind_rows(filtered_data, na_data)
    }

    # Print message and return output
    if (identical(quiet, FALSE)) {
      cli::cli_alert_info(
        "{n_outside_country} out of {nrow(x)} row{?s} had IP address outside of {country}."
      )
    }

    # Mark exclusion rows
    marked_data <- mark_rows(x, filtered_data, id_col, "ip")
    print_data(marked_data, print)
  }
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
#' @param keep Logical indicating whether to keep or remove exclusion column.
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
#' This function **requires internet connectivity** as it uses the
#' [iptools::country_ranges()] function, which pulls daily updated data
#' from \url{https://www.iwik.org/ipcountry/}. It only updates the data once
#' per session, as it caches the results for future work during the session.
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
                     include_na = FALSE,
                     keep = FALSE,
                     quiet = FALSE,
                     print = TRUE) {

  # Mark and filter ip
  exclusions <- mark_ip(x,
                        id_col = id_col,
                        ip_col = ip_col,
                        country = country,
                        quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_ip == "ip") %>%
    keep_marked_column(.data$exclusion_ip, keep)

  # Determine whether to print results
  print_data(exclusions, print)
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
#' @note
#' This function **requires internet connectivity** as it uses the
#' [iptools::country_ranges()] function, which pulls daily updated data
#' from \url{http://www.iwik.org/ipcountry/}. It only updates the data once
#' per session, as it caches the results for future work during the session.
#'
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
                       include_na = FALSE,
                       quiet = TRUE,
                       print = TRUE,
                       silent = FALSE) {

  # Mark and filter ip
  remaining_data <- mark_ip(x,
                            id_col = id_col,
                            ip_col = ip_col,
                            country = country,
                            include_na = include_na,
                            quiet = quiet
  ) %>%
    dplyr::filter(.data$exclusion_ip != "ip") %>%
    dplyr::select(-.data$exclusion_ip)

  # Print exclusion statement
  if (identical(silent, FALSE)) {
    print_exclusion(remaining_data, x,
                    paste0("rows with IP addresses outside of ", country))
  }

  # Determine whether to print results
  print_data(remaining_data, print)
}
