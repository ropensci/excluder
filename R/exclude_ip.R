#' Exclude IP addresses that come from a specified country.
#'
#' @description
#' The `exclude_ip()` function removes
#' rows of data that have IP addresses in the specified country.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @inherit check_ip details
#'
#' @inheritParams exclude_duplicates
#'
#' @family ip functions
#' @family exclude functions
#' @return
#' An object of the same type as `.data` that excludes rows
#' with IP addresses outside of the specified country.
#' For a function that checks these rows, use [check_ip()].
#' For a function that marks these rows, use [mark_ip()].
#' @export
#'
#' @examples
#' # Exclude IP addresses outside of the US
#' data(qualtrics_text)
#' df <- exclude_ip(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_ip()
#'
#' # Exclude IP addresses outside of Germany
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_ip(country = "DE")
#'
#' # Do not print message to console
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_ip(quiet = TRUE)
#'
exclude_ip <- function(.data, id_col = "ResponseId", ...) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_ip(.data, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(.data, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  message(n_exclusions, " out of ", nrow(.data), " rows with IP addresses outside of the specified country were excluded, leaving ", n_remaining, " rows.")
  return(remaining_data)
}
