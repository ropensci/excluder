#' Title
#'
#' @param .data
#' @param exclusion_types
#'
#' @return
#' @export
#'
#' @examples
collapse_exclusions <- function(.data, exclusion_types = c("duplicates", "duration", "ip", "location", "progress")) {

  # Create vector of exclusion columns to collapse
  exclusion_columns <- paste0("exclusion_", exclusion_types)

  # Collapse and delete columns
  .data %>%
    tidyr::unite(exclusions, exclusion_columns, sep = ",", na.rm = TRUE) %>%
    dplyr::mutate(exclusions = ifelse(exclusions == "", NA, exclusions))
}
