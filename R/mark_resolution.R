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
mark_resolution <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to mark
  exclusions <- excluder::check_resolution(.data, ...) %>%
    dplyr::mutate(exclusion_resolution = "resolution_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_resolution)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
