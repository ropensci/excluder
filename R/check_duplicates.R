check_duplicates <- function(df, ip_col = "IPAddress", location_col = c("LocationLatitude", "LocationLongitude"), check_ip = TRUE, check_location = TRUE, include_na = FALSE, quiet = FALSE) {
  # Check for duplicate locations
  if (check_location == TRUE) {
    if (include_na == FALSE) {
      df2 <- tidyr::drop_na(df, dplyr::any_of(location_col))
    } else {
      df2 <- df
    }
    same_location <- janitor::get_dupes(df2, dplyr::all_of(location_col))
    n_same_location <- nrow(same_location)
    if (quiet == FALSE) {
      message(n_same_location, " participants have duplicate locations.")
    }
  }
  # Check for duplicate IP addresses
  if (check_ip == TRUE) {
    if (include_na == FALSE) {
      df2 <- tidyr::drop_na(df, dplyr::all_of(ip_col))
    } else {
      df2 <- df
    }
    same_ip <- janitor::get_dupes(df2, dplyr::all_of(ip_col))
    n_same_ip <- nrow(same_ip)
    if (quiet == FALSE) {
      message(n_same_ip, " participants have duplicate IP addresses.")
    }
  }
  # Create data frame of duplicates if both location and IP address are used
  if (check_location == TRUE & check_ip == TRUE) {
    duplicates <- rbind(same_location, same_ip)
  } else if (check_location == TRUE) {
    duplicates <- same_location
  } else if (check_ip == TRUE) {
    duplicates <- same_ip
  } else {
    duplicates <- NULL
    warning("No check run. Please allow either location or IP address checks by setting check_location or check_ip to TRUE.")
  }
  return(duplicates)
}
