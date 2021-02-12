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
mark_ip <- function(.data, id_col = "ResponseId", ...) {

  # Find rows to mark
  exclusions <- excluder::check_ip(.data, ...) %>%
    dplyr::mutate(exclusion_ip = "ip_exclusion") %>%
    dplyr::select(dplyr::all_of(id_col), exclusion_ip)

  # Mark rows
  dplyr::left_join(.data, exclusions, by = id_col)
}
