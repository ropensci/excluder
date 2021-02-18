#' Title
#'
#' @param .data
#' @param width_min
#' @param height_min
#' @param res_col
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
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
      width = readr::parse_number(width),
      height = readr::parse_number(height)
    ) %>%
    dplyr::filter(width < width_min | height < height_min)
  n_wrong_resolution <- nrow(filtered_data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_wrong_resolution, " participants have screen resolution width less than ", width_min, " or height less than ", height_min, ".")
  }
  if (print_tibble == TRUE) {
    return(filtered_data)
  } else {
    invisible(filtered_data)
  }
}
