#' Title
#'
#' @param .data
#' @param ip_col
#' @param location_col
#' @param check_ip
#' @param check_location
#' @param include_na
#' @param id_col
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
exclude_duplicates <- function(.data, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), check_ip = TRUE, check_location = TRUE, include_na = FALSE, id_col = "ResponseId", quiet = FALSE) {
  exclusions <- check_duplicates(.data, ip_col, location_col, check_ip, check_location, include_na, quiet = quiet)
  dplyr::anti_join(.data, exclusions, by = id_col)
}
