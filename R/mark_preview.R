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
mark_preview <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to mark
  exclusions <- excluder::check_preview(.data, ...) %>%
    dplyr::mutate(exclusion_preview = "preview_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_preview)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
