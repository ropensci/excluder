#' Check for IP addresses that come from a specified country.
#'
#' @description
#' The `check_ip()` function subsets rows of data, retaining rows
#' that have IP addresses in the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey()].
#' The function uses [iptools::country_ranges()] to assign IP addresses to
#' specific countries using
#' [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
#'
#' The function outputs to console a message about the number of rows
#' with IP addresses outside of the specified country. If there are `NA`s for IP
#' addresses (likely due to including preview data---see [check_preview()]), it
#' will print a message alerting to the number of rows with `NA`s.
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param ip_col Column name for IP addresses.
#' @param country Two-letter abbreviation of country to check (default is "US").
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family ip functions
#' @family check functions
#' @return
#' An object of the same type as `.data` that includes the rows with
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
#'   check_ip(qualtrics_text, country = "DE")
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip(qualtrics_text, print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_ip(qualtrics_text, quiet = TRUE)
#'
check_ip <- function(.data, ip_col = "IPAddress", country = "US", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!ip_col %in% column_names) {
    stop("The column specifying IP address (ip_col) is incorrect. Please check your data and specify ip_col.")
  }

  # Quote column names
  ip_col <- dplyr::ensym(ip_col)

  # Remove rows with NAs for IP addresses
  na_rows <- dplyr::filter(.data, is.na(!!ip_col))
  n_na_rows <- nrow(na_rows)
  if (n_na_rows > 0 & quiet == FALSE) {
    message(n_na_rows, " rows have NA values for IP addresses (likely because it includes preview data).")
  }
  filtered_data <- dplyr::filter(.data, !is.na(!!ip_col))

  # Get IP ranges for specified country
  country_ip_ranges <- unlist(iptools::country_ranges(country))

  # Filter data based on IP ranges
  survey_ips <- dplyr::pull(filtered_data, ip_col)
  attr(survey_ips, "label") <- NULL
  outside_country <- !iptools::ip_in_any(survey_ips, country_ip_ranges)
  filtered_data <- dplyr::bind_cols(filtered_data, outside = outside_country)
  filtered_data <- dplyr::filter(filtered_data, outside == TRUE) %>%
    dplyr::select(-outside)
  n_outside_country <- nrow(filtered_data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_outside_country, " rows have IP addresses outside of ", country, ".")
  }
  if (print_tibble == TRUE) {
    return(filtered_data)
  } else {
    invisible(filtered_data)
  }
}
