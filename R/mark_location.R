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
mark_location <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_location(.data, ...) # %>%
  exclusions$exclusion_location <- "location_exclusion"
  exclusions <- dplyr::select(exclusions, dplyr::all_of(id_col), exclusion_location)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
