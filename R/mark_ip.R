#' Mark IP addresses that come from a specified country.
#'
#' @description
#' The `mark_ip()` function creates a column labeling
#' rows of data that have IP addresses in the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com/) surveys.
#'
#' @inherit check_ip details
#'
#' @inheritParams mark_duplicates
#'
#' @family ip functions
#' @family mark functions
#' @return
#' An object of the same type as `x` that includes a column marking rows
#' with IP addresses outside of the specified country.
#' For a function that checks these rows, use [check_ip()].
#' For a function that excludes these rows, use [exclude_ip()].
#' @export
#'
#' @examples
#' # Mark IP addresses outside of the US
#' data(qualtrics_text)
#' df <- mark_ip(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_ip()
#'
#' # Mark IP addresses outside of Germany
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   mark_ip(country = "DE")
#'
mark_ip <- function(x, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to mark
  exclusions <- excluder::check_ip(x, ...) %>%
    dplyr::mutate(exclusion_ip = "ip_outside_country") %>%
    dplyr::select(dplyr::all_of(id_col), .data$exclusion_ip)

  # Mark rows
  dplyr::left_join(x, exclusions, by = id_col)
}
