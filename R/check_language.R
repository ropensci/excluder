#' Title
#'
#' @param .data
#' @param language
#' @param lang_col
#' @param print_tibble
#' @param quiet
#'
#' @return
#' @export
#'
#' @examples
check_language <- function(.data, language = "EN", lang_col = "UserLanguage", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!lang_col %in% column_names) {
    stop("The column specifying resolution (lang_col) is incorrect. Please check your data and specify 'lang_col'.")
  }

  # Quote column names
  lang_col <- dplyr::ensym(lang_col)

  # Check for preview rows
  .data <- filter(.data, !!lang_col != language)
  n_wrong_languate <- nrow(.data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_wrong_languate, " participants experienced the survey in the wrong language.")
  }
  if (print_tibble == TRUE) {
    return(.data)
  } else {
    invisible(.data)
  }
}
