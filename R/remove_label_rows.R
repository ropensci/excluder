#' Remove two initial rows created in Qualtrics data
#'
#' @description
#' The `remove_label_rows()` function filters out the initial label rows from
#' datasets downloaded from [Qualtrics](https://www.qualtrics.com/) surveys.
#'
#' @details
#' The function (1) checks if the data set uses Qualtrics column names,
#' (2) checks if label rows are already used as column names,
#' (3) removes label rows if present, and (4) converts date, logical, and
#' numeric metadata columns to proper data type. Datasets imported using
#' [qualtRics::fetch_survey()](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html)
#' should not need this function.
#'
#' The `convert` argument only converts the _StartDate_, _EndDate_,
#' _RecordedDate_, _Progress_, _Finished_, _Duration (in seconds)_,
#' _LocationLatitude_, and _LocationLongitude_ columns. To convert other data
#' columns, see [`dplyr::mutate()`].
#'
#' @param x Data frame (downloaded from Qualtrics).
#' @param convert Logical indicating whether to convert/coerce date, logical and
#' numeric columns from the metadata.
#' @param rename Logical indicating whether to rename columns based on first row
#' of data.
#'
#' @concept helper
#'
#' @return
#' An object of the same type as `x` that excludes Qualtrics label rows and
#' with date, logical, and numeric metadata columns converted to the correct
#' data class.
#' @export
#'
#' @examples
#' # Remove label rows
#' data(qualtrics_raw)
#' df <- remove_label_rows(qualtrics_raw)
remove_label_rows <- function(x,
                              convert = TRUE,
                              rename = FALSE) {
  # Relabel if requested
  if (identical(rename, TRUE)) {
    # Keep meta column names
    col_names_orig <- names(x)
    resolution_col_num <- grep("_Resolution", col_names_orig)
    col_names_meta <- col_names_orig[1:resolution_col_num]

    # Remove question number from column names
    resolution_col <- col_names_meta[resolution_col_num]
    trash_string <- paste0(strsplit(resolution_col, "_")[[1]][1], "_")
    col_names_meta <- gsub(trash_string, "", col_names_meta)

    # Combine meta column names with first row labels
    first_row <- x[1, ]
    names(x) <- unlist(c(
      col_names_meta,
      first_row[(length(col_names_meta) + 1):length(first_row)]
    ))
  }

  # Check if Qualtrics data set
  if (identical(names(x)[1], "StartDate")) {
    # Remove label rows
    x <- x %>%
      dplyr::filter(.data$Status != "Response Type" &
        .data$Status != '{"ImportId":"status"}')
  } else if (identical(names(x)[1], "Start Date")) {
    # Remove label rows
    x <- x %>%
      dplyr::filter(.data$`Response Type` != "Response Type" &
        .data$`Response Type` != '{"ImportId":"status"}')
  } else {
    message("This data frame does not appear to be a Qualtrics data set.")
  }


  # Convert columns to date, logical, or numeric
  if (identical(convert, TRUE)) {
    column_names <- names(x)
    if ("StartDate" %in% column_names) {
      x <- dplyr::mutate(x,
        StartDate =
          lubridate::parse_date_time(.data$StartDate,
            orders = c(
              "ymd HMS",
              "ymd HM",
              "ymd",
              "mdy HMS",
              "mdy HM",
              "mdy"
            )
          )
      )
    }
    if ("EndDate" %in% column_names) {
      x <- dplyr::mutate(x,
        EndDate =
          lubridate::parse_date_time(.data$EndDate,
            orders = c(
              "ymd HMS",
              "ymd HM",
              "ymd",
              "mdy HMS",
              "mdy HM",
              "mdy"
            )
          )
      )
    }
    if ("Progress" %in% column_names) {
      x <- dplyr::mutate(x, Progress = as.numeric(.data$Progress))
    }
    if ("Status" %in% column_names) {
      if (x$Status[1] %in% c("1", "0")) {
        x <- dplyr::mutate(x, Status = as.numeric(.data$Status))
      }
    }
    if ("Duration (in seconds)" %in% column_names) {
      x <- dplyr::mutate(x,
        `Duration (in seconds)` =
          as.numeric(.data$`Duration (in seconds)`)
      )
    }
    if ("Finished" %in% column_names) {
      if (x$Finished[1] %in% c("TRUE", "FALSE")) {
        x <- dplyr::mutate(x, Finished = as.logical(.data$Finished))
      } else if (x$Finished[1] %in% c("True", "False")) {
        x <- dplyr::mutate(x, Finished = as.logical(toupper(.data$Finished)))
      } else if (x$Finished[1] %in% c("1", "0")) {
        x <- dplyr::mutate(x, Finished = as.logical(as.numeric(.data$Finished)))
      } else {
        cli::cli_alert_danger("The 'Finished' column cannot be converted to logical.")
      }
    }
    if ("RecordedDate" %in% column_names) {
      x <- dplyr::mutate(x,
        RecordedDate =
          lubridate::parse_date_time(.data$RecordedDate,
            orders = c(
              "ymd HMS",
              "ymd HM",
              "ymd",
              "mdy HMS",
              "mdy HM",
              "mdy"
            )
          )
      )
    }
    if ("LocationLatitude" %in% column_names) {
      x <- dplyr::mutate(x,
        LocationLatitude = as.numeric(.data$LocationLatitude)
      )
    }
    if ("LocationLongitude" %in% column_names) {
      x <- dplyr::mutate(x,
        LocationLongitude =
          as.numeric(.data$LocationLongitude)
      )
    }
  }

  invisible(x)
}
