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
mark_exclusions <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "location", "progress"), ...) {

  # Create vector of exclusion types to mark
  exclusion_types <- paste0("mark_", exclusion_types)

  # Mark exclusions if present in exclusion_types
  if("mark_progress" %in% exclusion_types) {
    .data <- mark_progress(.data, ...)
  }
  if("mark_duplicates" %in% exclusion_types) {
    .data <- mark_duplicates(.data, ...)
  }
  if("mark_ip" %in% exclusion_types) {
    .data <- mark_ip(.data, ...)
  }
  if("mark_location" %in% exclusion_types) {
    .data <- mark_location(.data, ...)
  }
  # if("mark_duration" %in% exclusion_types) {
  # .data <- mark_duration(.data, ...)
  # }
}
