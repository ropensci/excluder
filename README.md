
<!-- README.md is generated from README.Rmd. Please edit that file -->

# excluder

<!-- badges: start -->
<!-- badges: end -->

The goal of [`{excluder}`](https://jstevens5.github.io/excluder/) is to
facilitate checking for, marking, and excluding rows of data frames for
common exclusion criteria. This package applies to data collected from
[Qualtrics](https://qualtrics.com) surveys, and default column names
come from importing data with the
[`{qualtRics}`](https://docs.ropensci.org/qualtRics/) package.

## Installation

You can install the released version of `{excluder}`
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jstevens5/excluder")
```

## Verbs

This package provides three primary verbs:

-   `check` functions search for the exclusion criteria and outputs a
    message with the number of rows meeting the criteria and a data
    frame of the rows meeting the criteria. This is useful for viewing
    the potential exclusions.
-   `mark` functions add a new column to the data frame that labels the
    rows meeting the exclusion criteria. This is useful to label the
    potential exclusions for future processing.
-   `exclude` functions remove rows meeting the exclusion criteria. This
    is often the last step to complete after checking and/or marking the
    rows to ensure the exclusions are correct.

## Exclusion types

This package provides six types of exclusions based on Qualtrics
metadata. If you have ideas for other metadata exclusions, please submit
them as [issues](https://github.com/jstevens5/excluder/issues). Note,
the intent of this package is not to develop functions for excluding
rows based on survey-specific data but on general, frequently used
metadata.

-   `duplicates` works with rows that have duplicate IP addresses and/or
    locations (latitude/longitude).
-   `duration` works with rows whose survey completion time is too short
    and/or too long.
-   `ip` works with rows whose IP addresses are not found in the
    specified country (note: this exclusion type requires an internet
    connection to download the country’s IP ranges).
-   `location` works with rows whose latitude and longitude are not
    found in the United States.
-   `preview` works with rows that are survey previews.
-   `progress` works with rows in which the survey was not complete.
-   `resolution` works with rows whose screen resolution is not
    acceptable.

## Usage

The verbs and exclusion types combine with `_` to create the functions,
such as `check_duplicates`, `mark_duration`, and `exclude_ip`. Multiple
functions can be changed together using the [`{magrittr}`]() pipe `%>%`.

### Checking

The `check_*()` functions output messages about the number of rows that
meet the exclusion criteria.

``` r
library(excluder)
# Check for preview rows
qualtrics_text %>% 
  check_preview()
#> 2 out of 100 rows included previews. It is highly recommended to exclude these rows before further checking.
#> # A tibble: 2 x 16
#> # Rowwise: 
#>   StartDate           EndDate             Status         IPAddress Progress
#>   <dttm>              <dttm>              <chr>          <chr>        <dbl>
#> 1 2020-12-11 12:06:52 2020-12-11 12:10:30 Survey Preview <NA>           100
#> 2 2020-12-11 12:06:43 2020-12-11 12:11:27 Survey Preview <NA>           100
#> # … with 11 more variables: Duration (in seconds) <dbl>, Finished <lgl>,
#> #   RecordedDate <dttm>, ResponseId <chr>, LocationLatitude <dbl>,
#> #   LocationLongitude <dbl>, UserLanguage <chr>, Browser <chr>, Version <chr>,
#> #   Operating System <chr>, Resolution <chr>
```

Because checks return only the rows meeting the criteria, they should
not be connected via pipes unless you want to subset the second check
criterion within the rows that meet the first criterion.

``` r
# Check for rows with incomplete data then rows with durations less than 100 seconds
qualtrics_text %>% 
  check_progress()
#> 6 out of 100 rows did not complete the study.
#> # A tibble: 6 x 16
#> # Rowwise: 
#>   StartDate           EndDate             Status     IPAddress    Progress
#>   <dttm>              <dttm>              <chr>      <chr>           <dbl>
#> 1 2020-12-17 15:40:53 2020-12-17 15:43:25 IP Address 22.51.31.0         99
#> 2 2020-12-17 15:40:56 2020-12-17 15:46:23 IP Address 71.146.112.0        1
#> 3 2020-12-17 15:41:52 2020-12-17 15:46:37 IP Address 15.223.0.0         13
#> 4 2020-12-17 15:41:27 2020-12-17 15:46:45 IP Address 19.127.87.0        48
#> 5 2020-12-17 15:49:42 2020-12-17 15:51:50 IP Address 40.146.247.0        5
#> 6 2020-12-17 15:49:28 2020-12-17 15:55:06 IP Address 2.246.67.0         44
#> # … with 11 more variables: Duration (in seconds) <dbl>, Finished <lgl>,
#> #   RecordedDate <dttm>, ResponseId <chr>, LocationLatitude <dbl>,
#> #   LocationLongitude <dbl>, UserLanguage <chr>, Browser <chr>, Version <chr>,
#> #   Operating System <chr>, Resolution <chr>
```

``` r
qualtrics_text %>% 
  check_duration(min_duration = 100)
#> 4 out of 100 rows took less time than the minimum duration of 100 seconds.
#> # A tibble: 4 x 16
#> # Rowwise: 
#>   StartDate           EndDate             Status     IPAddress    Progress
#>   <dttm>              <dttm>              <chr>      <chr>           <dbl>
#> 1 2020-12-11 16:59:08 2020-12-11 17:02:05 IP Address 84.56.189.0       100
#> 2 2020-12-17 15:41:52 2020-12-17 15:46:37 IP Address 15.223.0.0         13
#> 3 2020-12-17 15:41:27 2020-12-17 15:46:45 IP Address 19.127.87.0        48
#> 4 2020-12-17 15:46:46 2020-12-17 15:49:02 IP Address 21.134.217.0      100
#> # … with 11 more variables: Duration (in seconds) <dbl>, Finished <lgl>,
#> #   RecordedDate <dttm>, ResponseId <chr>, LocationLatitude <dbl>,
#> #   LocationLongitude <dbl>, UserLanguage <chr>, Browser <chr>, Version <chr>,
#> #   Operating System <chr>, Resolution <chr>
```

``` r
# Check for rows with durations less than 100 seconds within rows that did not complete the survey
qualtrics_text %>% 
  check_progress() %>% 
  check_duration(min_duration = 100)
#> 6 out of 100 rows did not complete the study.
#> 2 out of 6 rows took less time than the minimum duration of 100 seconds.
#> # A tibble: 2 x 16
#> # Rowwise: 
#>   StartDate           EndDate             Status     IPAddress   Progress
#>   <dttm>              <dttm>              <chr>      <chr>          <dbl>
#> 1 2020-12-17 15:41:52 2020-12-17 15:46:37 IP Address 15.223.0.0        13
#> 2 2020-12-17 15:41:27 2020-12-17 15:46:45 IP Address 19.127.87.0       48
#> # … with 11 more variables: Duration (in seconds) <dbl>, Finished <lgl>,
#> #   RecordedDate <dttm>, ResponseId <chr>, LocationLatitude <dbl>,
#> #   LocationLongitude <dbl>, UserLanguage <chr>, Browser <chr>, Version <chr>,
#> #   Operating System <chr>, Resolution <chr>
```

### Marking

The `mark_*()` functions output the original data set with a new column
specifying rows that meet the exclusion criteria. These can be chained
together for multiple exclusion types.

``` r
# Mark preview and incomplete progress rows
df <- qualtrics_text %>% 
  mark_preview() %>% 
  mark_progress()
#> 2 out of 100 rows included previews. It is highly recommended to exclude these rows before further checking.
#> 6 out of 100 rows did not complete the study.
tibble::glimpse(df)
#> Rows: 100
#> Columns: 18
#> Rowwise: 
#> $ StartDate               <dttm> 2020-12-11 12:06:52, 2020-12-11 12:06:43, 202…
#> $ EndDate                 <dttm> 2020-12-11 12:10:30, 2020-12-11 12:11:27, 202…
#> $ Status                  <chr> "Survey Preview", "Survey Preview", "IP Addres…
#> $ IPAddress               <chr> NA, NA, "73.23.43.0", "16.140.105.0", "107.57.…
#> $ Progress                <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 1…
#> $ `Duration (in seconds)` <dbl> 465, 545, 651, 409, 140, 213, 177, 662, 296, 2…
#> $ Finished                <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE…
#> $ RecordedDate            <dttm> 2020-12-11 12:10:30, 2020-12-11 12:11:27, 202…
#> $ ResponseId              <chr> "R_xLWiuPaNuURSFXY", "R_Q5lqYw6emJQZx2o", "R_f…
#> $ LocationLatitude        <dbl> 29.73694, 39.74107, 34.03852, 44.96581, 27.980…
#> $ LocationLongitude       <dbl> -94.97599, -121.82490, -118.25739, -93.07187, …
#> $ UserLanguage            <chr> "EN", "EN", "EN", "EN", "EN", "EN", "EN", "EN"…
#> $ Browser                 <chr> "Chrome", "Chrome", "Chrome", "Chrome", "Chrom…
#> $ Version                 <chr> "88.0.4324.41", "88.0.4324.50", "87.0.4280.88"…
#> $ `Operating System`      <chr> "Windows NT 10.0", "Macintosh", "Windows NT 10…
#> $ Resolution              <chr> "1366x768", "1680x1050", "1366x768", "1536x864…
#> $ exclusion_preview       <chr> "preview", "preview", NA, NA, NA, NA, NA, NA, …
#> $ exclusion_progress      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
```

Use the [`collapse_exclusions()`](?collapse_exclusions) function to
collapse all of the marked columns into a single column.

``` r
# Collapse labels for preview and incomplete progress rows
df <- qualtrics_text %>% 
  mark_preview() %>% 
  mark_progress() %>% 
  collapse_exclusions(exclusion_types = c("preview", "progress"))
#> 2 out of 100 rows included previews. It is highly recommended to exclude these rows before further checking.
#> 6 out of 100 rows did not complete the study.
tibble::glimpse(df)
#> Rows: 100
#> Columns: 17
#> $ StartDate               <dttm> 2020-12-11 12:06:52, 2020-12-11 12:06:43, 202…
#> $ EndDate                 <dttm> 2020-12-11 12:10:30, 2020-12-11 12:11:27, 202…
#> $ Status                  <chr> "Survey Preview", "Survey Preview", "IP Addres…
#> $ IPAddress               <chr> NA, NA, "73.23.43.0", "16.140.105.0", "107.57.…
#> $ Progress                <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 1…
#> $ `Duration (in seconds)` <dbl> 465, 545, 651, 409, 140, 213, 177, 662, 296, 2…
#> $ Finished                <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE…
#> $ RecordedDate            <dttm> 2020-12-11 12:10:30, 2020-12-11 12:11:27, 202…
#> $ ResponseId              <chr> "R_xLWiuPaNuURSFXY", "R_Q5lqYw6emJQZx2o", "R_f…
#> $ LocationLatitude        <dbl> 29.73694, 39.74107, 34.03852, 44.96581, 27.980…
#> $ LocationLongitude       <dbl> -94.97599, -121.82490, -118.25739, -93.07187, …
#> $ UserLanguage            <chr> "EN", "EN", "EN", "EN", "EN", "EN", "EN", "EN"…
#> $ Browser                 <chr> "Chrome", "Chrome", "Chrome", "Chrome", "Chrom…
#> $ Version                 <chr> "88.0.4324.41", "88.0.4324.50", "87.0.4280.88"…
#> $ `Operating System`      <chr> "Windows NT 10.0", "Macintosh", "Windows NT 10…
#> $ Resolution              <chr> "1366x768", "1680x1050", "1366x768", "1536x864…
#> $ exclusions              <chr> "preview", "preview", NA, NA, NA, NA, NA, NA, …
```

### Excluding

The `exclude_*()` functions remove the rows that meet exclusion
criteria. These, too, can be piped together. Since the output of each
function is a subset of the original data with the excluded rows
removed, the order of the functions will influence the reported number
of rows meeting the exclusion criteria.

``` r
# Exclude preview then incomplete progress rows
df <- qualtrics_text %>% 
  exclude_duration(min_duration = 100) %>% 
  exclude_progress()
#> 4 out of 100 rows of short and/or long duration were excluded, leaving 96 rows.
#> 4 out of 96 rows with incomplete progress were excluded, leaving 92 rows.
dim(df)
#> [1] 92 16
```

``` r
# Exclude incomplete progress then preview rows
df <- qualtrics_text %>% 
  exclude_progress() %>% 
  exclude_duration(min_duration = 100)
#> 6 out of 100 rows with incomplete progress were excluded, leaving 94 rows.
#> 2 out of 94 rows of short and/or long duration were excluded, leaving 92 rows.
dim(df)
#> [1] 92 16
```

Though the order of functions should not influence the final data set,
it may speed up processing large files by removing preview and
incomplete progress data first and waiting to check IP addresses and
locations after other exclusions have been performed.

``` r
# Exclude rows
df <- qualtrics_text %>% 
  exclude_preview() %>% 
  exclude_progress() %>% 
  exclude_duplicates() %>% 
  exclude_duration(min_duration = 100) %>% 
  exclude_resolution() %>% 
  exclude_ip() %>% 
  exclude_location()
#> 2 out of 100 preview rows were excluded, leaving 98 rows.
#> 6 out of 98 rows with incomplete progress were excluded, leaving 92 rows.
#> 15 out of 92 duplicate rows were excluded, leaving 83 rows.
#> 2 out of 83 rows of short and/or long duration were excluded, leaving 81 rows.
#> 4 out of 81 rows with unacceptable screen resolution were excluded, leaving 77 rows.
#> 2 out of 77 rows with IP addresses outside of the specified country were excluded, leaving 75 rows.
#> 4 out of 75 rows outside of the US were excluded, leaving 71 rows.
```

### Combining verbs

It often makes sense to remove the preview surveys and incomplete
surveys before checking other exclusion types.

``` r
# Exclude preview then incomplete progress rows
qualtrics_text %>% 
  exclude_preview() %>% 
  exclude_progress() %>% 
  check_duplicates()
#> 2 out of 100 preview rows were excluded, leaving 98 rows.
#> 6 out of 98 rows with incomplete progress were excluded, leaving 92 rows.
#> 
#> 9 out of 91 rows have duplicate locations.
#> 6 out of 91 rows have duplicate IP addresses.
#> # A tibble: 15 x 17
#>    LocationLatitude LocationLongitude dupe_count StartDate          
#>               <dbl>             <dbl>      <int> <dttm>             
#>  1             28.6             -81.5          2 2020-12-17 15:42:47
#>  2             28.6             -81.5          2 2020-12-17 15:42:18
#>  3             37.3            -121.           2 2020-12-17 15:46:51
#>  4             37.3            -121.           2 2020-12-17 15:48:53
#>  5             40.3             -75.9          2 2020-12-11 12:41:23
#>  6             40.3             -75.9          2 2020-12-17 15:41:17
#>  7             45.5            -123.           3 2020-12-17 15:40:52
#>  8             45.5            -123.           3 2020-12-17 15:40:57
#>  9             45.5            -123.           3 2020-12-17 15:48:48
#> 10             37.3            -121.           2 2020-12-17 15:46:51
#> 11             37.3            -121.           2 2020-12-17 15:48:53
#> 12             40.3             -75.9          2 2020-12-11 12:41:23
#> 13             40.3             -75.9          2 2020-12-17 15:41:17
#> 14             28.6             -81.5          2 2020-12-17 15:42:47
#> 15             28.6             -81.5          2 2020-12-17 15:42:18
#> # … with 13 more variables: EndDate <dttm>, Status <chr>, IPAddress <chr>,
#> #   Progress <dbl>, Duration (in seconds) <dbl>, Finished <lgl>,
#> #   RecordedDate <dttm>, ResponseId <chr>, UserLanguage <chr>, Browser <chr>,
#> #   Version <chr>, Operating System <chr>, Resolution <chr>
```
