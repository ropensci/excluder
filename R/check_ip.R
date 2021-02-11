check_ip <- function(.data, ip_col = "IPAddress", country = "US", quiet = FALSE) {
  country_ip_ranges <- unlist(iptools::country_ranges(country))
  survey_ips <- dplyr::pull(.data, ip_col)
  outside_country <- !iptools::ip_in_any(survey_ips, country_ip_ranges)
  .data <- dplyr::bind_cols(.data, outside = outside_country)
  outside_.data <- dplyr::filter(.data, outside == TRUE)
  n_outside_country <- nrow(outside_.data)
  if (quiet == FALSE) {
    message(n_outside_country, " participants have IP addresses outside of ", country, ".")
  }
  return(outside_.data)
}
