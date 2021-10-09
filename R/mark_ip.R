#' Mark IP addresses that come from a specified country.
#'
#' @description
#' The `mark_ip()` function creates a column labeling
#' rows of data that have IP addresses in the specified country.
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
  stopifnot("'id_col' should only have a single column name" =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }
  ## ip_col
  stopifnot("'ip_col' should only have a single column name" =
              length(ip_col) == 1L)
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
  if (n_na_rows > 0 & identical(quiet, FALSE)){
    message(n_na_rows, " out of ", nrow(x),
            paste0(" rows have NA values for IP addresses (check for preview ",
                   "data with 'check_preview()')."))
  }
  filtered_data <- x[-na_rows, ]

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
    message(n_outside_country, " out of ", nrow(x),
            " rows have IP addresses outside of ", country, ".")
  }
  # if (identical(print_tibble, TRUE)) {
  #   # return(filtered_data)
  # } else {
  #   invisible(filtered_data)
  # }

  # Find rows to mark
  exclusions <- filtered_data %>%
    dplyr::mutate(exclusion_ip = "ip_outside_country") %>%
    dplyr::select(tidyselect::all_of(id_col), .data$exclusion_ip)

  # Mark rows
  invisible(dplyr::left_join(x, exclusions, by = id_col) %>%
              dplyr::mutate(exclusion_ip =
                              stringr::str_replace_na(.data$exclusion_ip, "")))
}
