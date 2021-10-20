#' Unite multiple exclusion columns into single column
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `collapse_exclusions()` was renamed to [unite_exclusions()] to create a more
#' consistent API with tidyverse's `unite()` function---please use
#' `unite_exclusions()`.
#' @keywords internal
#' @export
collapse_exclusions <- function(x,
                                exclusion_types = c(
                                  "duplicates", "duration",
                                  "ip", "location", "preview",
                                  "progress", "resolution"
                                ),
                                separator = ",",
                                remove = TRUE) {
  lifecycle::deprecate_warn(
    "0.3.0", "collapse_exclusions()",
    "unite_exclusions()"
  )
  unite_exclusions(x, exclusion_types, separator, remove)
}

#' Unite multiple exclusion columns into single column
#'
#' @description
#' Each of the `mark_*()` functions appends a new column to the data.
#' The `unite_exclusions()` function unites all of those columns in a
#' single column that can be used to filter any or all exclusions downstream.
#' Rows with multiple exclusions are concatenated with commas.
#'
#' @param x  Data frame or tibble (preferably exported from Qualtrics).
#' @param exclusion_types Vector of types of exclusions to unite.
#' @param separator Character string specifying what character to use to
#' separate multiple exclusion types
#' @param remove Logical specifying whether to remove united columns
#' (default = TRUE) or leave them in the data frame (FALSE)
#'
#' @concept helper
#'
#' @return
#' An object of the same type as `x` that includes the all of the same
#' rows but with a single `exclusion` column replacing all of the specified
#' `exclusion_*` columns.

#' @export
#'
#' @examples
#'
#' # Unite all exclusion types
#' df <- qualtrics_text %>%
#'   mark_duplicates() %>%
#'   mark_duration(min_duration = 100) %>%
#'   mark_ip() %>%
#'   mark_location() %>%
#'   mark_preview() %>%
#'   mark_progress() %>%
#'   mark_resolution()
#' df2 <- df %>%
#'   unite_exclusions()
#'
#' # Unite subset of exclusion types
#' df2 <- df %>%
#'   unite_exclusions(exclusion_types = c("duplicates", "duration", "ip"))
unite_exclusions <- function(x,
                             exclusion_types = c(
                               "duplicates", "duration",
                               "ip", "location", "preview",
                               "progress", "resolution"
                             ),
                             separator = ",",
                             remove = TRUE) {

  # Create vectors of exclusion columns to unite
  exclusion_columns_selected <- paste0("exclusion_", exclusion_types)
  exclusion_columns_to_unite <-
    names(x)[which(names(x) %in% exclusion_columns_selected)]

  # Check for presence of exclusion column(s)
  stopifnot(
    "No exclusion columns found. Run 'mark_*()' functions to mark columns." =
      length(exclusion_columns_to_unite) >= 1L
  )

  # Unite and delete columns
  x %>%
    tidyr::unite("exclusions",
      tidyselect::all_of(exclusion_columns_to_unite),
      sep = separator,
      na.rm = TRUE,
      remove = remove
    ) %>%
    dplyr::mutate( # remove extraneous separators from unite
      exclusions =  # remove multiple adjacent separators
        stringr::str_replace(.data$exclusions,
                             pattern = paste0(separator, "{2,}"),
                             replacement = separator),
      exclusions =  # remove separators as first character
        ifelse(substr(.data$exclusions, 1, 1) == separator,
          sub("^.", "", .data$exclusions), .data$exclusions
        ),
      exclusions =  # remove separators as last character
        ifelse(substr(
          .data$exclusions, nchar(.data$exclusions),
          nchar(.data$exclusions)
        ) == separator,
        sub(".$", "", .data$exclusions), .data$exclusions
        )
    )
}
