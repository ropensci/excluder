check_ip <- function(df) {
  iana_assignments <- data(iana_assignments, package = "iptools")
  iana_assignments_refresh()
  # extract information from US IP addresses
  us_ip_data <- dplyr::filter(iana_assignments,
                              stringr::str_detect(designation, "ARIN") |
                                stringr::str_detect(designation, "PSINet") |
                                stringr::str_detect(designation, "AT&T"))
  us_ip_ranges <- dplyr::pull(us_ip_data, prefix)
  survey_ips <- dplyr::pull(df, `IP Address`)
  outside_us <- dplyr::filter(df, !ip_in_any(survey_ips, us_ip_ranges)) %>%
    dplyr::mutate(outside_us = "Outside US") %>%
    dplyr::select(`Response ID`, outside_us)
}
