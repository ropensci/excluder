#' Remove two initial rows created in Qualtrics data
#'
#' @description
#' The `remove_label_rows()` function filters out the initial label rows from
#' [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' The function (1) checks if the data set uses Qualtrics column names,
#' (2) checks if label rows are already used as column names, and
#' (3) removes label rows if present.
#'
#' @param .data Data frame (preferably directly from Qualtrics imported
#' using {qualtRics}.)
#' @param qualtrics_check Logical indicating whether to check if the data are
#' from Qualtrics.
#'
#' @return
#' An object of the same type as `.data` that excludes Qualtrics label rows.
#' @export
#'
#' @examples
#' # Check for survey previews
#' data(qualtrics_raw)
#' df <- remove_label_rows(qualtrics_raw)
#'

remove_label_rows <- function(.data, qualtrics_check = TRUE) {

  # Check if Qualtrics data set
  if(qualtrics_check == TRUE) {
    if(names(data)[1] !=  "StartDate") {
      if(names(data)[1] == "Start Date") {
        message("This data frame has used the label row for the column names.")
      } else {
        message("This data frame does not appear to be a Qualtrics data set.")
      }
    }
  }

  # Remove label rows
  filtered_data <- data %>%
    dplyr::filter(StartDate != "Start Date" & StartDate != "{\"ImportId\":\"startDate\",\"timeZone\":\"America/Chicago\"}")
  return(filtered_data)
}
