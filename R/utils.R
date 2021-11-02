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


#' Keep column with marked rows
#'
#' For check_*() functions, keep the column that has marked rows and move to
#' first column or remove the column depending on `keep` flag.
#' \emph{This function is not exported.}
#'
#' @param x Data set.
#' @param column Name of exclusion column.
#' @param keep Logical indicating whether to keep or remove exclusion column.
#'
#' @keywords internal
#'
keep_marked_column <- function(x, column, keep) {
  if (!keep) {
    x %>% dplyr::select(-{{ column }})
  } else {
    x %>% dplyr::relocate({{ column }})
  }
}


#' Return marked rows
#'
#' Create new column marking rows that meet exclusion criteria.
#' \emph{This function is not exported.}
#'
#' @param x Original data.
#' @param filtered_data Data to be excluded.
#' @param id_col Column name for unique row ID (e.g., participant).
#' @param exclusion_type Column name for exclusion column.
#'
#' @importFrom rlang :=
#' @keywords internal
#'
mark_rows <- function(x,
                      filtered_data,
                      id_col,
                      exclusion_type) {
  exclusion_col <- paste0("exclusion_", exclusion_type)
  if (exclusion_type != "duration") {
    exclusions <- filtered_data %>%
      dplyr::mutate({{ exclusion_col }} := exclusion_type)
  } else {
    exclusions <- filtered_data
  }
  exclusions <- exclusions %>%
    dplyr::select(tidyselect::all_of(id_col), {{ exclusion_col }}) %>%
    dplyr::distinct()
  x %>%
    dplyr::left_join(exclusions, by = id_col) %>%
    dplyr::mutate(
      dplyr::across({{ exclusion_col }}, ~ tidyr::replace_na(., ""))
    )
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
    "{n_exclusions} out of {nrow(x)} {msg} were excluded, leaving {n_remaining} rows."
  )
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


#' Check number, names, and type of columns
#'
#' Determines whether the correct number and names of columns were specified
#' as arguments to the functions. \emph{This function is not exported.}
#'
#' @param x Data set.
#' @param column Name of column argument to check.
#'
#' @keywords internal
#'
validate_columns <- function(x, column) {
  # Extract column name
  col_name <- substitute(column)

  # Check number of columns
  if (col_name == "location_col") {
    col_num <- 2L
  } else {
    col_num <- 1L
  }
  if (length(column) != col_num) {
    if (col_num == 1) {
      msg <- paste0("'", col_name, "' requires ", col_num, " column name.")
    } else {
      msg <- paste0("'", col_name, "' requires ", col_num, " column names.")
    }
    stop(msg)
  } else if (length(column) == 2L & column[1] == column[2]) {
    msg <- paste0("The same column name was entered twice in '", col_name, "'.")
    stop(msg)
  }

  # Check column names
  column_names <- names(x)
  if (col_num == 1) {
    if (!column %in% column_names) {
      msg <- paste0(
        "The column '", column,
        "' was not found in the data frame."
      )
      stop(msg)
    }
  } else if (!column[1] %in% column_names) {
    msg <- paste0(
      "The column '", column[1],
      "' was not found in the data frame."
    )
    stop(msg)
  } else if (!column[2] %in% column_names) {
    msg <- paste0(
      "The column '", column[2],
      "' was not found in the data frame."
    )
    stop(msg)
  }

  # Check column data type
  col_label <- as.character(col_name)
  if (col_label %in% c("ip_col", "res_col")) {
    if (!is.character(x[[column]])) {
      msg <- paste0("Please ensure '", col_name, "' data type is character.")
      stop(msg)
    }
  } else if (col_label %in% c("location_col", "duration_col", "progress_col")) {
    if (!is.numeric(x[[column[1]]])) {
      msg <- paste0("Please ensure '", col_name, "' data type is numeric.")
      stop(msg)
    }
  } else if (col_label == "preview_col") {
    if (!is.character(x[[column]]) & !is.numeric(x[[column]])) {
      print(typeof(x[[column]]))
      msg <- paste0(
        "Please ensure '", col_name,
        "' data type is character or numeric."
      )
      stop(msg)
    }
  } else if (col_label == "finished") {
    if (!is.logical(x[[column]]) & !is.numeric(x[[column]])) {
      print(typeof(x[[column]]))
      msg <- paste0(
        "Please ensure '", col_name,
        "' data type is character or numeric."
      )
      stop(msg)
    }
  }
}
