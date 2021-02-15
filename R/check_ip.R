#' Title
#'
#' @param .data
#' @param ip_col
#' @param country
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_ip <- function(.data, ip_col = "IPAddress", country = "US", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!ip_col %in% column_names) {
    stop("The column specifying IP address (ip_col) is incorrect. Please check your data and specify ip_col.")
  }

  # Remove rows with NAs for IP addresses
  na_rows <- filter(.data, is.na(IPAddress))
  n_na_rows <- nrow(na_rows)
  if (n_na_rows > 0) {
    message(n_na_rows, " participants have NA values for IP addresses (likely because it includes preview data).")
  }
  .data <- filter(.data, !is.na(IPAddress))

  # Get IP ranges for specified country
  country_ip_ranges <- unlist(iptools::country_ranges(country))

  # Filter data based on IP ranges
  survey_ips <- dplyr::pull(.data, ip_col)
  outside_country <- !iptools::ip_in_any(survey_ips, country_ip_ranges)
  .data <- dplyr::bind_cols(.data, outside = outside_country)
  .data <- dplyr::filter(.data, .data$outside == TRUE) %>%
    dplyr::select(-.data$outside)
  n_outside_country <- nrow(.data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_outside_country, " participants have IP addresses outside of ", country, ".")
  }
  if (print_tibble == TRUE) {
    return(.data)
  } else {
    invisible(.data)
  }
}
