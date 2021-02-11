check_ip <- function(df, ip_col = "IPAddress", country = "US", quiet = FALSE) {
  country_ip_ranges <- unlist(iptools::country_ranges(country))
  survey_ips <- dplyr::pull(df, ip_col)
  outside_country <- !iptools::ip_in_any(survey_ips, us_ip_ranges)
  df2 <- dplyr::bind_cols(df, outside = outside_country)
  outside_df <- dplyr::filter(df2, outside == TRUE)
  n_outside_country <- nrow(outside_df)
  if (quiet == FALSE) {
    message(n_outside_country, " participants have IP addresses outside of ", country, ".")
  }
  return(outside_df)
}
