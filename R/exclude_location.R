#' Exclude data rows where location information is absent and outside of the the US
#'
#' @param .data Data frame (preferably directly from Qualtrics imported using {qualtRics}.)
#' @param location_col Two element vector specifying columns for latitude and longitude (in that order).
#' @param include_na Logical indicating whether to include rows with NA in latitude and longitude columns in the output list of potentially excluded data.
#' @param id_col Column label of column specifying unique row ID. This used to exclude from \code{.data} the rows outputted from [check_location()].
#' @param quiet Logical indicating whether to print results to console.
#'
#' @return The output is a data frame of the rows that are located inside the US and (if \code{include_na == FALSE}) rows with location information. For a function that creates a data frame that outputs the excluded rows, use [check_location()].
#' @export
#'
#' @examples
exclude_location <- function(.data, location_col = c("LocationLatitude", "LocationLongitude"), include_na = FALSE, id_col = "ResponseId", quiet = FALSE) {
  exclusions <- check_location(.data, location_col, include_na, quiet = quiet)
  dplyr::anti_join(.data, exclusions, by = id_col)
}
