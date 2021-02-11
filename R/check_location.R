check_location <- function(df, location_col = c("LocationLatitude", "LocationLongitude"), include_na = FALSE, quiet = FALSE) {
  # Rename latitude and longitude columns
  df2 <- dplyr::rename(df, latitude = as.name(location_col[1]), longitude = as.name(location_col[2]))

  # Check for participants with no location information
  no_location <- dplyr::filter(df2, is.na(latitude) | is.na(longitude))
  n_no_location <- nrow(no_location)
  df2 <- drop_na(df2, latitude:longitude)

  # Extract latitude and longitude
  latitude <- dplyr::pull(df2, latitude)
  longitude <- dplyr::pull(df2, longitude)

  # Determine if geolocation is within US
  df2$country <- maps::map.where(database = "usa", longitude, latitude)
  outside_us <- dplyr::filter(df2, is.na(country)) %>%
    select(-country)
  n_outside_us <- nrow(outside_us)

  # Combine no location with outside US
  if (include_na == FALSE) {
    location_issues <- rbind(no_location, outside_us)
  } else {
    location_issues <- outside_us
  }

  # Print messages and return output
  if (quiet == FALSE) {
    message(n_no_location, " participants had no information on location.")
    message(n_outside_us, " participants were located outside of the US.")
  }
  return(location_issues)
}
