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

#' Check number and names of columns
#'
#' Determines whether the correct number and names of columns were specified
#' as arguments to the functions. \emph{This function is not exported.}
#'
#' @param x Data set.
#' @param column Name of column argument to check.
#' @param col_num Expected number of columns.
#'
#' @keywords internal
#'
validate_columns <- function(x, column) {
  # Extract column name
  col_name <- substitute(column)

  # Set parameters for columns
  if (col_name == "location_col") {
    col_num = 2L
  } else {
    col_num = 1L
  }

  # Check number of columns
  if (length(column) != col_num) {
    if (col_num == 1) {
      msg <- paste0("'", col_name, "' requires ", col_num, " column name.")
    } else {
      msg <- paste0("'", col_name, "' requires ", col_num, " column names.")
    }
    stop(msg)
  } else if (length(column) == 2L & column[1] == column[2]) {
    msg <- paste0("The same column name was entered twice in '", col_name,"'.")
    stop(msg)
  }

  # Check column names
  column_names <- names(x)
  if (col_num == 1) {
    if (!column %in% column_names) {
      msg <- paste0("The column '", column,
                    "' was not found in the data frame.")
      stop(msg)
    }
  } else if (!column[1] %in% column_names) {
    msg <- paste0("The column '", column[1],
                  "' was not found in the data frame.")
    stop(msg)
  } else if (!column[2] %in% column_names) {
    msg <- paste0("The column '", column[2],
                  "' was not found in the data frame.")
    stop(msg)
  }

}

#' Print number of excluded rows
#'
#' Prints a message to the console with the number of excluded rows.
#' \emph{This function is not exported.}
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
  cli::cli_alert_info(
    "{n_exclusions} out of {nrow(x)} {msg} were excluded, leaving {n_remaining} rows.")
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
