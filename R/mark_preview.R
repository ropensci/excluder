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

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_preview(.data, ...) %>%
    dplyr::mutate(exclusion_preview = "preview_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_preview)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
