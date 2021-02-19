#' Title
#'
#' @param .data
#' @param id_col
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
exclude_resolution <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to exclude
  exclusions <- check_resolution(.data, ...)

  # Exclude rows
  dplyr::anti_join(.data, exclusions, by = id_col)
}
