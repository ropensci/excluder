exclude_location <- function(.data, location_col = c("LocationLatitude", "LocationLongitude"), include_na = FALSE, id_col = "ResponseId", quiet = FALSE) {
  exclusions <- check_location(.data, location_col, include_na, quiet = quiet)
  anti_join(.data, exclusions, by = id_col)
}
