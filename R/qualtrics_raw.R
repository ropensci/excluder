#' Example text-based metadata from simulated Qualtrics study
#'
#' A dataset containing the metadata from a standard Qualtrics survey with
#' browser metadata collected and exported with "Use choice text".
#' These data were randomly generated using [iptools::ip_random] and
#' [rgeolocate::ip2location](
#' https://cran.r-project.org/web/packages/rgeolocate/rgeolocate.pdf) functions.
#' This dataset includes the two header rows of with column information that is
#' exported by Qualtrics.
#'
#' @format A data frame with 102 rows and 16 variables:
#' \describe{
#'   \item{StartDate}{date and time data collection started, in ISO 8601 format}
#'   \item{EndDate}{date and time data collection ended, in ISO 8601 format}
#'   \item{Status}{flag for preview (Survey Preview) vs. implemented survey
#'   (IP Address) entries}
#'   \item{IPAddress}{participant IP address (truncated for anonymity)}
#'   \item{Progress}{percentage of survey completed}
#'   \item{Duration (in seconds)}{duration of time required to complete survey,
#'   in seconds}
#'   \item{Finished}{logical for whether survey was completed (TRUE) or progress
#'   was < 100 (FALSE)}
#'   \item{RecordedDate}{date and time survey was recorded, in ISO 8601 format}
#'   \item{ResponseId}{random ID for participants}
#'   \item{LocationLatitude}{latitude geolocated from IP address}
#'   \item{LocationLongitude}{longitude geolocated from IP address}
#'   \item{UserLanguage}{language set in Qualtrics}
#'   \item{Browser}{user web browser type}
#'   \item{Version}{user web browser version}
#'   \item{Operating System}{user operating system}
#'   \item{Resolution}{user screen resolution}
#' }
#' @family data
"qualtrics_raw"
