#' Check screen resolution
#'
#' @description
#' The `check_resolution()` function subsets rows of data, retaining rows
#' that have unacceptable screen resolution. This can be used, for example, to
#' determine data collected via phones when desktop monitors are required.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey()].
#'
#' The function outputs to console a message about the number of rows
#' with unacceptable screen resolution.
#'
#' @param .data Data frame (preferably directly from Qualtrics imported
#' using {qualtRics}.)
#' @param width_min Minimum acceptable screen width.
#' @param height_min Minimum acceptable screen height
#' @param res_col Column name for screen resolution (in format widthxheight)
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family resolution functions
#' @family check functions
#' @return The output is a data frame of the rows that have unacceptable screen
#' resolutions. This includes new columns for resolution width and height.
#' For a function that marks these rows, use [mark_resolution()].
#' For a function that excludes these rows, use [exclude_resolution()].
#' @export
#'
#' @examples
#' # Check for survey previews
#' data(qualtrics_text)
#' check_resolution(qualtrics_text)
#'
#' # Remove preview data first
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution()
#'
#' # Do not print rows to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution(print_tibble = FALSE)
#'
#' # Do not print message to console
#' qualtrics_text %>%
#'   exclude_preview() %>%
#'   check_resolution(quiet = TRUE)
#'
check_resolution <- function(.data, width_min = 1000, height_min = 0, res_col = "Resolution", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!res_col %in% column_names) {
    stop("The column specifying resolution (res_col) is incorrect. Please check your data and specify 'res_col'.")
  }

  # Check width or height minimum
  if (width_min == 0 & height_min == 0) {
    stop("This check requires a minimum resolution for resolution width or height. Please include 'width_min' and/or 'height_min'.")
  }

  filtered_data <- .data %>%
    tidyr::separate(res_col, c("width", "height"), sep = "x", remove = FALSE) %>%
    dplyr::mutate(
      width = readr::parse_number(.data$width),
      height = readr::parse_number(.data$height)
    ) %>%
    dplyr::filter(.data$width < width_min | .data$height < height_min)
  n_wrong_resolution <- nrow(filtered_data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_wrong_resolution, " out of ", nrow(.data), " rows have screen resolution width less than ", width_min, " or height less than ", height_min, ".")
  }
  if (print_tibble == TRUE) {
    return(filtered_data)
  } else {
    invisible(filtered_data)
  }
}
