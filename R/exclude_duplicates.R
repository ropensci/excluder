#' Exclude rows with duplicate IP addresses and/or locations
#'
#' @description
#' The `exclude_duplicates()` function removes
#' rows of data that have the same IP address and/or same latitude and
#' longitude. The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_duplicates details
#'
#' @param x Data frame or tibble (preferably exported from Qualtrics).
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param silent Logical indicating whether to print message to console. Note this argument controls the exclude message not the check message.
#' @param ... Inherit parameters from check function.
#'
#' @family duplicates functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' with duplicate IP addresses and/or locations.
#' For a function that just checks for and returns duplicate rows,
#' use [check_duplicates()]. For a function that marks these rows,
#' use [mark_duplicates()].

#' @export
#'
#' @examples
#' # Exclude duplicate IP addresses and locations
#' data(qualtrics_text)
#' df <- exclude_duplicates(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates()
#'
#' # Exclude only for duplicate locations
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_duplicates(dupl_location = FALSE)
#'
exclude_duplicates <- function(x, id_col = "ResponseId", silent = FALSE, ...) {

  # Check for presence of required column
  column_names <- names(x)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID (id_col) is incorrect. Please check your data and specify 'id_col'.")
  }

  # Find rows to exclude
  exclusions <- check_duplicates(x, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(x, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (silent == FALSE) {
    message(n_exclusions, " out of ", nrow(x), " duplicate rows were excluded, leaving ", n_remaining, " rows.")
  }
  return(remaining_data)
}
