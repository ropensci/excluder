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
check_exclusions <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "language", "location", "preview", "progress", "resolution"), ...) {

  # Create vector of exclusion types to mark
  exclusion_types <- paste0("check_", exclusion_types)

  # Mark exclusions if present in exclusion_types
  if ("check_preview" %in% exclusion_types) {
    check_preview(.data, print_tibble = FALSE, ...)
  }
  if ("check_progress" %in% exclusion_types) {
    check_progress(.data, print_tibble = FALSE, ...)
  }
  if ("check_duplicates" %in% exclusion_types) {
    check_duplicates(.data, print_tibble = FALSE, ...)
  }
  if ("check_ip" %in% exclusion_types) {
    check_ip(.data, print_tibble = FALSE, ...)
  }
  if ("check_location" %in% exclusion_types) {
    check_location(.data, print_tibble = FALSE, ...)
  }
  if ("check_language" %in% exclusion_types) {
    check_language(.data, print_tibble = FALSE, ...)
  }
  if ("check_resolution" %in% exclusion_types) {
    check_resolution(.data, print_tibble = FALSE, ...)
  }
  if("check_duration" %in% exclusion_types) {
  check_duration(.data, ...)
  }
}
