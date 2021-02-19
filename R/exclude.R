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
exclude <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "language", "location", "preview", "progress", "resolution"), quiet = FALSE, ...) {

  # Create vector of exclusion types to exclude
  exclusion_types <- paste0("exclude_", exclusion_types)

  # Count participants in full data set
  n_full_participants <- nrow(.data)

  # Exclude if present in exclusion_types
  if ("exclude_preview" %in% exclusion_types) {
    .data <- exclude_preview(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_progress" %in% exclusion_types) {
    .data <- exclude_progress(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_duplicates" %in% exclusion_types) {
    .data <- exclude_duplicates(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_ip" %in% exclusion_types) {
    .data <- exclude_ip(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_location" %in% exclusion_types) {
    .data <- exclude_location(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_language" %in% exclusion_types) {
    .data <- exclude_language(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_resolution" %in% exclusion_types) {
    .data <- exclude_resolution(.data, print_tibble = FALSE, ...)
  }
  if ("exclude_duration" %in% exclusion_types) {
    .data <- exclude_duration(.data, ...)
  }

  # Count excluded participants
  n_remaining_participants <- nrow(.data)
  n_excluded <- n_full_participants - n_remaining_participants
  if (quiet == FALSE) {
    message("****** ", n_excluded, " participants were excluded from this data set. ******")
  }
}
