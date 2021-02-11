exclude_duplicates <- function(.data, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), check_ip = TRUE, check_location = TRUE, include_na = FALSE, id_col = "ResponseId", quiet = FALSE) {
  exclusions <- check_duplicates(.data, ip_col, location_col, check_ip, check_location, include_na, quiet = quiet)
  anti_join(.data, exclusions, by = id_col)
}
