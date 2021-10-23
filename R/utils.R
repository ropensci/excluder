#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

#' Print number of excluded rows
#'
#' Prints a message to the console with the number of excluded rows. \emph{This function is not exported.}
#'
#' @param remaining_data Data after removing exclusions.
#' @param x Original data before removing exclusions.
#' @param msg Text to describe what types of rows were excluded.
#'
#' @keywords internal
#'
print_exclusion <- function(remaining_data, x, msg) {
  n_remaining <- nrow(remaining_data)
  n_exclusions <- nrow(x) - n_remaining
  cli::cli_alert_info("{n_exclusions} out of {nrow(x)} {msg} were excluded, leaving {n_remaining} rows.")
}

#' Print data to console
#'
#' Prints the data to the console. \emph{This function is not exported.}
#'
#' @param x Data set to print or not
#' @param print Logical indicating whether to print returned tibble to
#' console.
#'
#' @keywords internal
#'
print_data <- function(x, print) {
  if (identical(print, TRUE)) {
    return(x)
  } else {
    invisible(x)
  }
}
