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
#' columns to proper data type. Datasets imported using
#' [`qualtRics::fetch_survey()`] should not need this function.
#'
#' The `convert` argument only converts the _StartDate_, _EndDate_,
#' _RecordedDate_, _Progress_, _Duration (in seconds)_, _LocationLatitude_, and
#' _LocationLongitude_ columns. To convert data columns, see [`dplyr::mutate()`].
#'
#' @param .data Data frame (downloaded from Qualtrics).
#' @param convert Logical indicating whether to convert/coerce date and numeric
#' columns from the metadata.
#'
#' @return
#' An object of the same type as `.data` that excludes Qualtrics label rows and
#' with date and numeric metadata columns converted to the correct data class.
#' @export
#'
#' @examples
#' # Remove label rows
#' data(qualtrics_raw)
#' df <- remove_label_rows(qualtrics_raw)
remove_label_rows <- function(.data, convert = TRUE) {

  # Check if Qualtrics data set
  if (names(.data)[1] == "StartDate") {
    # Remove label rows
    .data <- .data %>%
      dplyr::filter(.data$Status != "Response Type" & .data$Status != '{"ImportId":"status"}')
  } else {
    message("This data frame does not appear to be a Qualtrics data set.")
  }


  # Convert columns to date or numeric
  if (convert == TRUE) {
    column_names <- names(.data)
    if ("StartDate" %in% column_names) {
      .data <- dplyr::mutate(.data, StartDate = lubridate::parse_date_time(.data$StartDate, orders = c("ymd HMS", "ymd HM", "ymd", "mdy HMS", "mdy HM", "mdy")))
    }
    if ("EndDate" %in% column_names) {
      .data <- dplyr::mutate(.data, EndDate = lubridate::parse_date_time(.data$EndDate, orders = c("ymd HMS", "ymd HM", "ymd", "mdy HMS", "mdy HM", "mdy")))
    }
    if ("Progress" %in% column_names) {
      .data <- dplyr::mutate(.data, Progress = as.numeric(.data$Progress))
    }
    if ("Duration (in seconds)" %in% column_names) {
      .data <- dplyr::mutate(.data, `Duration (in seconds)` = as.numeric(.data$`Duration (in seconds)`))
    }
    if ("RecordedDate" %in% column_names) {
      .data <- dplyr::mutate(.data, RecordedDate = lubridate::parse_date_time(.data$RecordedDate, orders = c("ymd HMS", "ymd HM", "ymd", "mdy HMS", "mdy HM", "mdy")))
    }
    if ("LocationLatitude" %in% column_names) {
      .data <- dplyr::mutate(.data, LocationLatitude = as.numeric(.data$LocationLatitude))
    }
    if ("LocationLongitude" %in% column_names) {
      .data <- dplyr::mutate(.data, LocationLongitude = as.numeric(.data$LocationLongitude))
    }
  }

  invisible(.data)
}
