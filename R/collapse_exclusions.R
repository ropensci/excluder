#' Collapse multiple exclusion columns into single column
#'
#' @description
#' Each of the `mark_*()` functions appends a new column to the data.
#' The `collapse_exclusions()` function collapses all of those columns in a single
#' column that can be used to filter any or all exclusions downstream. Rows
#' with multiple exclusions are concatenated with commas.
#'
#' @param x  Data frame or tibble (preferably exported from Qualtrics).
#' @param exclusion_types Vector of types of exclusions to collapse.
#' @param separator Character string specifying what character to use to
#' separate multiple exclusion types
#' @param remove Logical specifying whether to remove collapsed columns
#' (default = TRUE) or leave them in the data frame (FALSE)
#'
#' @return
#' #' An object of the same type as `x` that includes the all of the same
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
collapse_exclusions <- function(x, exclusion_types = c("duplicates", "duration", "ip", "location", "preview", "progress", "resolution"), separator = ",", remove = TRUE) {

  # Define exclusions to avoid R CMD check failure
  exclusions <- NULL

  # Create vectors of exclusion columns to collapse
  exclusion_columns_selected <- paste0("exclusion_", exclusion_types)
  print(exclusion_columns_selected)
  exclusion_columns_to_collapse <- names(x)[which(names(x) %in% exclusion_columns_selected)]
  print(exclusion_columns_to_collapse)

  # Collapse and delete columns
  x %>%
    tidyr::unite(exclusions, exclusion_columns_to_collapse, sep = separator, na.rm = TRUE, remove = remove) %>%
    dplyr::mutate(exclusions = ifelse(.data$exclusions == "", NA, .data$exclusions))
}
