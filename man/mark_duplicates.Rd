% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/duplicates.R
\name{mark_duplicates}
\alias{mark_duplicates}
\title{Mark duplicate IP addresses and/or locations}
\usage{
mark_duplicates(
  x,
  id_col = "ResponseId",
  ip_col = "IPAddress",
  location_col = c("LocationLatitude", "LocationLongitude"),
  rename = TRUE,
  dupl_ip = TRUE,
  dupl_location = TRUE,
  include_na = FALSE,
  quiet = FALSE,
  print = TRUE
)
}
\arguments{
\item{x}{Data frame (preferably imported from Qualtrics using \{qualtRics\}).}

\item{id_col}{Column name for unique row ID (e.g., participant).}

\item{ip_col}{Column name for IP addresses.}

\item{location_col}{Two element vector specifying columns for latitude and
longitude (in that order).}

\item{rename}{Logical indicating whether to rename columns (using \code{\link[=rename_columns]{rename_columns()}})}

\item{dupl_ip}{Logical indicating whether to check IP addresses.}

\item{dupl_location}{Logical indicating whether to check latitude and
longitude.}

\item{include_na}{Logical indicating whether to include rows with NAs for
IP address and location as potentially excluded rows.}

\item{quiet}{Logical indicating whether to print message to console.}

\item{print}{Logical indicating whether to print returned tibble to
console.}
}
\value{
An object of the same type as \code{x} that includes a column marking rows
with duplicate IP addresses and/or locations.
For a function that just checks for and returns duplicate rows,
use \code{\link[=check_duplicates]{check_duplicates()}}. For a function that excludes these rows,
use \code{\link[=exclude_duplicates]{exclude_duplicates()}}.
}
\description{
The \code{mark_duplicates()} function creates a column labeling
rows of data that have the same IP address and/or same latitude and
longitude. The function is written to work with data from
\href{https://www.qualtrics.com/}{Qualtrics} surveys.
}
\details{
To record this information in your Qualtrics survey, you must ensure that
\href{https://www.qualtrics.com/support/survey-platform/survey-module/survey-options/survey-protection/#AnonymizingResponses}{Anonymize responses is disabled}.

Default column names are set based on output from the
\href{https://docs.ropensci.org/qualtRics/reference/fetch_survey.html}{\code{qualtRics::fetch_survey()}}.
By default, IP address and location are both checked, but they can be
checked separately with the \code{dupl_ip} and \code{dupl_location} arguments.

The function outputs to console separate messages about the number of
rows with duplicate IP addresses and rows with duplicate locations.
These counts are computed independently, so rows may be counted for both
types of duplicates.
}
\examples{
# Mark duplicate IP addresses and locations
data(qualtrics_text)
df <- mark_duplicates(qualtrics_text)

# Remove preview data first
df <- qualtrics_text \%>\%
  exclude_preview() \%>\%
  mark_duplicates()

# Mark only for duplicate locations
df <- qualtrics_text \%>\%
  exclude_preview() \%>\%
  mark_duplicates(dupl_location = FALSE)
}
\seealso{
Other duplicates functions: 
\code{\link{check_duplicates}()},
\code{\link{exclude_duplicates}()}

Other mark functions: 
\code{\link{mark_duration}()},
\code{\link{mark_ip}()},
\code{\link{mark_location}()},
\code{\link{mark_preview}()},
\code{\link{mark_progress}()},
\code{\link{mark_resolution}()}
}
\concept{duplicates functions}
\concept{mark functions}
