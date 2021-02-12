exclude_duration <- function(.data, duration_col = "Duration (in seconds)", min = NULL, max = NULL, id_col = "ResponseId", quiet = FALSE) {

  exclusions <- check_duration(.data, min = min, max = max, quiet = quiet)
  dplyr::anti_join(.data, exclusions, by = id_col)
}
