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
exclude_ip <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to exclude
  exclusions <- check_ip(.data, ...)

  # Exclude rows
  dplyr::anti_join(.data, exclusions, by = id_col)
}
