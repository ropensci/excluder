#' Title
#'
#' @param .data
#' @param ip_col
#' @param location_col
#' @param dupl_ip
#' @param dupl_location
#' @param include_na
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_duplicates <- function(.data, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), dupl_ip = TRUE, dupl_location = TRUE, include_na = FALSE, print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required columns
  column_names <- names(.data)
  if (length(location_col) != 2) stop("Incorrect number of columns for location_col. You must specify two columns for latitude and longitude (respectively).")
  if (!location_col[1] %in% column_names | !location_col[2] %in% column_names) stop("The columns specifying participant location (location_col) are incorrect. Please check your data and specify location_col.")
  if (!ip_col %in% column_names) stop("The column specifying IP address (ip_col) is incorrect. Please check your data and specify ip_col.")

  # Check for duplicate locations
  if (dupl_location == TRUE) {
    if (include_na == FALSE) {
      .data <- tidyr::drop_na(.data, dplyr::any_of(location_col))
    }
    same_location <- janitor::get_dupes(.data, dplyr::all_of(location_col))
    n_same_location <- nrow(same_location)
    if (quiet == FALSE) {
      message(n_same_location, " participants have duplicate locations.")
    }
  }

  # Check for duplicate IP addresses
  if (dupl_ip == TRUE) {
    if (include_na == FALSE) {
      .data <- tidyr::drop_na(.data, dplyr::all_of(ip_col))
    }
    same_ip <- janitor::get_dupes(.data, dplyr::all_of(ip_col))
    n_same_ip <- nrow(same_ip)
    if (quiet == FALSE) {
      message(n_same_ip, " participants have duplicate IP addresses.")
    }
  }

  # Create data frame of duplicates if both location and IP address are used
  if (dupl_location == TRUE & dupl_ip == TRUE) {
    duplicates <- rbind(same_location, same_ip)
  } else if (dupl_location == TRUE) {
    duplicates <- same_location
  } else if (dupl_ip == TRUE) {
    duplicates <- same_ip
  } else {
    duplicates <- NULL
    warning("No check run. Please allow either location or IP address checks by setting dupl_location or dupl_ip to TRUE.")
  }
  if (print_tibble == TRUE) {
    return(duplicates)
  } else {
    invisible(duplicates)
  }
}
