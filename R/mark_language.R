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
mark_language <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to mark
  exclusions <- excluder::check_language(.data, ...) %>%
    dplyr::mutate(exclusion_language = "language_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_language)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
