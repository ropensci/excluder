#' Title
#'
#' @param .data
#' @param ip_col
#' @param country
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_ip <- function(.data, ip_col = "IPAddress", country = "US", quiet = FALSE) {

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
  return(.data)
}
