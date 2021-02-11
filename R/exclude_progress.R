exclude_progress <- function(.data, min = 100, id_col = "ResponseId", quiet = FALSE) {
  exclusions <- check_progress(.data, min, quiet = quiet)
  anti_join(.data, exclusions, by = id_col)
}
