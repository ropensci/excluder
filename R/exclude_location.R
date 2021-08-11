#' Exclude locations outside of US
#'
#' @description
#' The `exclude_location()` function removes
#' rows that have locations outside of the US.
#' The function is written to work with data from
#' [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @inherit check_location details
#'
#' @inheritParams exclude_duplicates
#'
#' @family location functions
#' @family exclude functions
#' @return
#' An object of the same type as `x` that excludes rows
#' that are located outside of the US and (if `include_na == FALSE`) rows with
#' no location information.
#' For a function that checks for these rows, use [check_location()].
#' For a function that marks these rows, use [mark_location()].
#' @export
#'
#' @examples
#' # Exclude locations outside of the US
#' data(qualtrics_text)
#' df <- exclude_location(qualtrics_text)
#'
#' # Remove preview data first
#' df <- qualtrics_text %>%
#'   exclude_preview() %>%
#'   exclude_location()
exclude_location <- function(x,
                             id_col = "ResponseId",
                             silent = FALSE,
                             ...) {

  # Check for presence of required column
  column_names <- names(x)
  stopifnot("id_col should only have a single column name" =
              length(id_col) == 1L)
  if (!id_col %in% column_names) {
    stop("The column specifying the participant ID ('id_col') was not found.")
  }

  # Find rows to exclude
  exclusions <- check_location(x, quiet = TRUE, ...)
  n_exclusions <- nrow(exclusions)

  # Exclude rows
  remaining_data <- dplyr::anti_join(x, exclusions, by = id_col)
  n_remaining <- nrow(remaining_data)
  if (identical(silent, FALSE)) {
    message(n_exclusions, " out of ", nrow(x),
            " rows outside of the US were excluded, leaving ",
            n_remaining, " rows.")
  }
  return(remaining_data)
}
