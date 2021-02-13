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
exclude <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "location", "progress"), ...) {

  # Create vector of exclusion types to exclude
  exclusion_types <- paste0("exclude_", exclusion_types)

  # Exclude if present in exclusion_types
  if ("exclude_progress" %in% exclusion_types) {
    .data <- exclude_progress(.data, ...)
  }
  if ("exclude_duplicates" %in% exclusion_types) {
    .data <- exclude_duplicates(.data, ...)
  }
  if ("exclude_ip" %in% exclusion_types) {
    .data <- exclude_ip(.data, ...)
  }
  if ("exclude_location" %in% exclusion_types) {
    .data <- exclude_location(.data, ...)
  }
  # if("exclude_duration" %in% exclusion_types) {
  # .data <- exclude_duration(.data, ...)
  # }
}
