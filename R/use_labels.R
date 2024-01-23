#' Use Qualtrics labels as column names
#'
#' @description
#' The `use_labels()` function renames the columns using the labels generated
#' in [Qualtrics](https://www.qualtrics.com/).  Data must be imported using
#' [`qualtRics::fetch_survey()`](https://docs.ropensci.org/qualtRics/reference/fetch_survey.html).
#'
#' @param x Data frame imported using `qualtRics::fetch_survey()`.
#'
#' @concept helper
#' @family column name functions
#'
#' @return
#' An object of the same type as `x` that has column names using the labels
#' generated in Qualtrics.
#' @export
#'
#' @examples
#' # Rename columns
#' data(qualtrics_fetch)
#' qualtrics_renamed <- qualtrics_fetch %>%
#'   use_labels()
#' names(qualtrics_fetch)
#' names(qualtrics_renamed)
use_labels <- function(x) {
  if (is.null(attributes(x)$column_map$description)) {
    cli::cli_abort("Data frame does not have proper Qualtrics labels from `qualtRics::fetch_survey()`.")
  } else {
    # Assign labels to column names
    column_names <- colnames(x)
    colnames(x) <- attributes(x)$column_map[attributes(x)$column_map$qname %in% column_names, ]$description

    # Find extraneous text to remove from computer info columns
    if (any(grepl("Resolution", column_names))) {
      text <- x %>%
        dplyr::select(dplyr::contains("Resolution")) %>%
        names() %>%
        strsplit(split = " - ")
      throwaway <- paste0(text[[1]][1], " - ")

      # Rename columns
      x <- x %>%
        dplyr::rename_with(~ gsub(throwaway, "", .x), dplyr::contains(throwaway))
    }
    return(x)
  }
}
