#' Collapse multiple exclusion columns into single column
#'
#' @description
#' Each of the `mark_*()` functions appends a new column to the data.
#' The `collapse_exclusions()` function collapses all of those columns in a single
#' column that can be used to filter any or all exclusions downstream. Rows
#' with multiple exclusions are concatenated with commas.
#'
#' @param .data  Data frame or tibble (preferably exported from Qualtrics).
#' @param exclusion_types Vector of types of exclusions to collapse.
#'
#' @return
#' #' An object of the same type as `.data` that includes the all of the same
#' rows but with a single `exclusion` column replacing all of the specified
#' `exclusion_*` columns.

#' @export
#'
#' @examples
#'
#' # Collapse all exclusion types
#' df <- qualtrics_text %>%
#'   mark_duplicates() %>%
#'   mark_duration(min_duration = 100) %>%
#'   mark_ip() %>%
#'   mark_location() %>%
#'   mark_preview() %>%
#'   mark_progress() %>%
#'   mark_resolution()
#' df2 <- df %>%
#'   collapse_exclusions()
#'
#' # Collapse subset of exclusion types
#' df2 <- df %>%
#'   collapse_exclusions(exclusion_types = c("duplicates", "duration", "ip"))
#'
collapse_exclusions <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "location", "preview", "progress", "resolution")) {

  # Create vector of exclusion columns to collapse
  exclusion_columns <- paste0("exclusion_", exclusion_types)

  # Collapse and delete columns
  .data %>%
    tidyr::unite(exclusions, exclusion_columns, sep = ",", na.rm = TRUE) %>%
    dplyr::mutate(exclusions = ifelse(exclusions == "", NA, exclusions))
}
