#' Metadata from simulated Qualtrics study
#'
#' A dataset containing the metadata from a standard Qualtrics survey with
#' browser metadata collected and exported with "Use numeric values".
#' These data were randomly generated using #' [iptools::ip_random] and
#' [rgeolocate::ip2location] functions.
#'
#' @format A data frame with 100 rows and 16 variables:
#' \describe{
#'   \item{StartDate}{date and time data collection started, in ISO 8601 format}
#'   \item{EndDate}{date and time data collection ended, in ISO 8601 format}
#'   \item{Status}{numeric flag for preview (1) vs. implemented survey (0) entries}
#'   \item{IPAddress}{participant IP address (truncated for anonymity)}
#'   \item{Progress}{percentage of survey completed}
#'   \item{Duration (in seconds)}{duration of time required to complete survey, in seconds}
#'   \item{Finished}{numeric flag for whether survey was completed (1) or progress was < 100 (0)}
#'   \item{RecordedDate}{date and time survey was recorded, in ISO 8601 format}
#'   \item{ResponseId}{random ID for participants}
#'   \item{LocationLatitude}{latitude geolocated from IP address}
#'   \item{LocationLongitude}{longitude geolocated from IP address}
#'   \item{UserLanguage}{language set in Qualtrics}
#'   \item{Browser}{user web browser type}
#'   \item{Version}{user web browser version}
#'   \item{Operation System}{user operating system}
#'   \item{Resolution}{user screen resolution}
#' }
"qualtrics_numeric"
