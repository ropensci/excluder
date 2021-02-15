#' Title
#'
#' @param .data
#' @param preview_col
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_preview <- function(.data, preview_col = "Status", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!preview_col %in% column_names) {
    stop("The column specifying resolution (preview_col) is incorrect. Please check your data and specify 'preview_col'.")
  }

  # Quote column names
  preview_col <- dplyr::ensym(preview_col)

  # Check for preview rows
  .data <- filter(.data, !!preview_col == "Survey Preview")
  n_previews <- nrow(.data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_previews, " rows were collected as previews. It is highly recommended to exclude these rows before further checking.")
  }
  if (print_tibble == TRUE) {
    return(.data)
  } else {
    invisible(.data)
  }
}
