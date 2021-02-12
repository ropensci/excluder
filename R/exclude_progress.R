exclude_progress <- function(.data, min = 100, finished_col = "Finished", progress_col = "Progress", id_col = "ResponseId", quiet = FALSE) {

  exclusions <- check_progress(.data)
  dplyr::anti_join(.data, exclusions, by = id_col)
}
