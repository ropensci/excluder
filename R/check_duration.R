check_duration <- function(df, duration_col = "Duration (in seconds)", min = NULL, max = NULL, quiet = FALSE) {
  # Rename duration column
  df2 <- rename(df, duration = as.name(duration_col))
  # Find participants quicker than minimum
  if (!is.null(min)) {
    too_quick <- too_quick_slow <- dplyr::filter(df2, duration < min)
    n_too_quick <- nrow(too_quick)
    if(quiet == FALSE) {
      message(n_too_quick, " participants took less time than the minimum duration of ", min, ".")
    }
  }
  # Find participants slower than minimum
  if (!is.null(max)) {
    too_slow <- too_quick_slow <- dplyr::filter(df2, duration > max)
    n_too_slow <- nrow(too_slow)
    if(quiet == FALSE) {
      message(n_too_slow, " participants took more time than the maximum duration of ", max, ".")
    }
  }
  # Combine quick and slow participants
  if (!is.null(min) & !is.null(max)) {
    too_quick_slow <- rbind(too_quick, too_slow)
  }
  return(too_quick_slow)
}
