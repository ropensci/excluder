#' Title
#'
#' @param .data
#' @param exclusion_types
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
mark_exclusions <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "language", "location", "preview", "progress", "resolution"), ...) {

  # Create vector of exclusion types to mark
  exclusion_types <- paste0("mark_", exclusion_types)

  # Mark exclusions if present in exclusion_types
  if ("mark_preview" %in% exclusion_types) {
    .data <- mark_preview(.data, print_tibble = FALSE, ...)
  }
  if ("mark_progress" %in% exclusion_types) {
    .data <- mark_progress(.data, print_tibble = FALSE, ...)
  }
  if ("mark_duplicates" %in% exclusion_types) {
    .data <- mark_duplicates(.data, print_tibble = FALSE, ...)
  }
  if ("mark_ip" %in% exclusion_types) {
    .data <- mark_ip(.data, print_tibble = FALSE, ...)
  }
  if ("mark_location" %in% exclusion_types) {
    .data <- mark_location(.data, print_tibble = FALSE, ...)
  }
  if ("mark_language" %in% exclusion_types) {
    .data <- mark_language(.data, print_tibble = FALSE, ...)
  }
  if ("mark_resolution" %in% exclusion_types) {
    .data <- mark_resolution(.data, print_tibble = FALSE, ...)
  }
  if("mark_duration" %in% exclusion_types) {
    .data <- mark_duration(.data, ...)
  }
}
