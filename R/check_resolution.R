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
check_resolution <- function(.data, width_min = 0, height_min = 0, res_col = "Resolution", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!res_col %in% column_names) {
    stop("The column specifying resolution (res_col) is incorrect. Please check your data and specify 'res_col'.")
  }

  # Check width or height minimum
  if (width_min == 0 & height_min == 0) {
    stop("This check requires a minimum resolution for resolution width or height. Please include 'width_min' and/or 'height_min'.")
  }

  .data <- .data %>%
    separate(res_col, c("width", "height"), sep = "x", remove = FALSE) %>%
    mutate(
      width = parse_number(width),
      height = parse_number(height)
    ) %>%
    filter(width < width_min | height < height_min)
  n_wrong_resolution <- nrow(.data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_wrong_resolution, " participants have inappropriate screen resolution.")
  }
  if (print_tibble == TRUE) {
    return(.data)
  } else {
    invisible(.data)
  }
}
