exclude_ip <- function(.data, ip_col = "IPAddress", country = "US", id_col = "ResponseId", quiet = FALSE) {

  exclusions <- check_ip(.data, ip_col, country, quiet = quiet)
  dplyr::anti_join(.data, exclusions, by = id_col)
}
