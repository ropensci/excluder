#' Rename columns to match standard Qualtrics names
#'
#' @description
#' The `rename_columns()` function renames the metadata columns to match
#' standard Qualtrics names.
#'
#' @details
#' When importing Qualtrics data using
#' [`qualtRics::fetch_survey()`](
#' https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#' labels entered in Qualtrics questions are saved as 'subtitles' for column
#' names. Using [`sjlabelled::get_label()`](
#' https://strengejacke.github.io/sjlabelled/reference/get_label.html)
#' can make these secondary labels be the
#' primary column names. However, this results in a different set of names for
#' the metadata columns than is used in all of the `mark_()`, `check_()`, and
#' `exclude_()` functions. This function renames these columns to match the
#' standard Qualtrics names.
#'
#' @param x Data frame (preferably imported from Qualtrics using \{qualtRics\}).
#' @param alert Logical indicating whether to alert user to the fact that the
#' columns do not match the secondary labels and therefore cannot be renamed.
#'
#' @concept helper
#' @family column name functions
#'
#' @return
#' An object of the same type as `x` that has column names that match standard
#' Qualtrics names.
#' @export
#'
#' @examples
#' # Rename columns
#' data(qualtrics_fetch)
#' qualtrics_renamed <- qualtrics_fetch %>%
#'   rename_columns()
#' names(qualtrics_fetch)
#' names(qualtrics_renamed)
#'
#' # Alerts when columns cannot be renamed
#' data(qualtrics_numeric)
#' rename_columns(qualtrics_numeric)
#'
#' # Turn off alert
#' rename_columns(qualtrics_numeric, alert = FALSE)
#'
rename_columns <- function(x, alert = TRUE) {
  # Check if data frame uses secondary label column names
  column_names <- colnames(x)
  if (column_names[1] == "Start Date") {
    # Find extraneous text to remove from computer info columns
    text <- x %>%
      dplyr::select(dplyr::contains("Resolution")) %>%
      names() %>%
      strsplit(split = c(" - ", "_"))
    throwaway <- paste0(text[[1]][1], " - ")

    # Rename columns
    x %>%
      dplyr::rename(
        StartDate = "Start Date",
        EndDate = "End Date",
        Status = "Response Type",
        IPAddress = "IP Address",
        RecordedDate = "Recorded Date",
        ResponseId = "Response ID",
        LocationLatitude = "Location Latitude",
        LocationLongitude = "Location Longitude",
        UserLanguage = "User Language"
      ) %>%
      dplyr::rename_with(~ gsub(throwaway, "", .x), dplyr::contains(throwaway))
  } else if (any(grepl("_Resolution", column_names))) {
    # Find extraneous text to remove from computer info columns
    text <- x %>%
      dplyr::select(dplyr::contains("_Resolution")) %>%
      names() %>%
      strsplit(split = "_")
    throwaway <- paste0(text[[1]][1], "_")

    # Rename columns
    x %>%
      dplyr::rename_with(~ gsub(throwaway, "", .x), dplyr::contains(throwaway))
  } else { # if first column is not `Started Date`
    if (alert) {
      cli::cli_alert_warning("The columns cannot be renamed.")
    }
    invisible(x)
  }
}
