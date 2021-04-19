#' Remove two initial rows created in Qualtrics data
#'
#' @description
#' The `remove_label_rows()` function filters out the initial label rows from
#' datasets downloaded from [Qualtrics](https://qualtrics.com) surveys.
#'
#' @details
#' The function (1) checks if the data set uses Qualtrics column names,
#' (2) checks if label rows are already used as column names,
#' (3) removes label rows if present, and (4) converts date and numeric metadata
#' columns to proper data class. Datasets imported using
#' [qualtRics::fetch_survey()] should not need this function.
#'
#' The `convert` argument only converts the _StartDate_, _EndDate_,
#' _RecordedDate_, _Progress_, _Duration (in seconds)_, _LocationLatitude_, and
#' _LocationLongitude_ columns. To convert data columns, see [dplyr::mutate].
#'
#' @param .data Data frame (downloaded from Qualtrics).
#' @param convert Logical indicating whether to convert date and numeric columns
#' from the metadata.
#'@param qualtrics_check Logical indicating whether to check if the data are
#' from Qualtrics.
#'
#' @return
#' An object of the same type as `.data` that excludes Qualtrics label rows and
#' with date and numeric metadata columns converted to the correct data class.
#' @export
#'
#' @examples
#' # Check for survey previews
#' data(qualtrics_raw)
#' df <- remove_label_rows(qualtrics_raw)
#'

remove_label_rows <- function(.data, convert = TRUE, qualtrics_check = TRUE) {

  # Check if Qualtrics data set
  if(qualtrics_check == TRUE) {
    if(names(.data)[1] !=  "StartDate") {
      if(names(.data)[1] == "Start Date") {
        message("This data frame has used the label row for the column names.")
      } else {
        message("This data frame does not appear to be a Qualtrics data set.")
      }
    }
  }

  # Remove label rows
  .data <- .data %>%
    dplyr::filter(.data$StartDate != "Start Date" & .data$StartDate != "{\"ImportId\":\"startDate\",\"timeZone\":\"America/Chicago\"}")

  # Convert columns to numeric
  if(convert == TRUE) {
    column_names <- names(.data)
    if("StartDate" %in% column_names) {
      .data <- dplyr::mutate(.data, StartDate = lubridate::ymd_hms(.data$StartDate))
    }
    if("EndDate" %in% column_names) {
      .data <- dplyr::mutate(.data, EndDate = lubridate::ymd_hms(.data$EndDate))
    }
    if("Progress" %in% column_names) {
      .data <- dplyr::mutate(.data, Progress = as.numeric(.data$Progress))
    }
    if("Duration (in seconds)" %in% column_names) {
      .data <- dplyr::mutate(.data, `Duration (in seconds)` = as.numeric(.data$`Duration (in seconds)`))
    }
    if("RecordedDate" %in% column_names) {
      .data <- dplyr::mutate(.data, RecordedDate = lubridate::ymd_hms(.data$RecordedDate))
    }
    if("LocationLatitude" %in% column_names) {
      .data <- dplyr::mutate(.data, LocationLatitude = as.numeric(.data$LocationLatitude))
    }
    if("LocationLongitude" %in% column_names) {
      .data <- dplyr::mutate(.data, LocationLongitude = as.numeric(.data$LocationLongitude))
    }
  }

  return(.data)
}
