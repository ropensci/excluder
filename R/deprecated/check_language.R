#' Check for user language
#'
#' @description
#' The `check_language()` function subsets rows of data, retaining rows
#' that have incorrect user language.
#' The function is written to work with data from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' Default column names are set based on output from the
#' [qualtRics::fetch_survey()]. The country codes come from the
#' [Qualtrics Language Codes](https://www.qualtrics.com/support/survey-platform/survey-module/survey-tools/translate-survey/#AvailableLanguageCodes).
#'
#' The function outputs to console a message about the number of
#' rows with the incorrect language.
#'
#' @param .data Data frame or tibble (preferably exported from Qualtrics).
#' @param language Abbreviation for language user used to complete survey.
#' @param lang_col Column name for user language.
#' @param print_tibble Logical indicating whether to print returned tibble to
#' console.
#' @param quiet Logical indicating whether to print message to console.
#'
#' @family language functions
#' @family check functions
#' @return
#' An object of the same type as `.data` that includes the rows with
#' duplicate IP addresses and/or locations.
#' For a function that excludes these rows, use [exclude_language()].
#' For a function that marks these rows, use [mark_language()].
#'
#' @export
#'
#' @examples
#' # Check for duplicate IP addresses and locations
#' data(qualtrics_text)
#' check_language(qualtrics_text)
#'
#' # Check only for duplicate locations
#' check_language(qualtrics_text, dupl_location = FALSE)
#'
#' # Do not print rows to console
#' check_language(qualtrics_text, print_tibble = FALSE)
#'
#' # Do not print message to console
#' check_language(qualtrics_text, quiet = TRUE)
#'
check_language <- function(.data, language = "EN", lang_col = "UserLanguage", print_tibble = TRUE, quiet = FALSE) {

  # Check for presence of required column
  column_names <- names(.data)
  if (!lang_col %in% column_names) {
    stop("The column specifying resolution (lang_col) is incorrect. Please check your data and specify 'lang_col'.")
  }

  # Quote column names
  lang_col <- dplyr::ensym(lang_col)

  # Check for preview rows
  filtered_data <- dplyr::filter(.data, !!lang_col != language)
  n_wrong_languate <- nrow(filtered_data)

  # Print message and return output
  if (quiet == FALSE) {
    message(n_wrong_languate, " participants experienced the survey in the wrong language.")
  }
  if (print_tibble == TRUE) {
    return(filtered_data)
  } else {
    invisible(filtered_data)
  }
}
