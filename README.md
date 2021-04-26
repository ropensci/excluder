
<!-- README.md is generated from README.Rmd. Please edit that file -->

# excluder

<!-- badges: start -->

[![R-CMD-check](https://github.com/jeffreyrstevens/excluder/workflows/R-CMD-check/badge.svg)](https://github.com/jeffreyrstevens/excluder/actions)
[![Codecov test
coverage](https://codecov.io/gh/jstevens5/excluder/branch/main/graph/badge.svg)](https://codecov.io/gh/jstevens5/excluder?branch=main)
[![lifecycle](man/figures/lifecycle-experimental.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of [`{excluder}`](https://jeffreyrstevens.github.io/excluder/)
is to facilitate checking for, marking, and excluding rows of data
frames for common exclusion criteria. This package applies to data
collected from [Qualtrics](https://qualtrics.com) surveys, and default
column names come from importing data with the
[`{qualtRics}`](https://docs.ropensci.org/qualtRics/) package.

This may be most useful for [Mechanical Turk](https://www.mturk.com/)
data to screen for duplicate entries from the same location/IP address
or entries from locations outside of the United States. But it can be
used more generally to exclude based on response durations, preview
status, progress, or screen resolution.

More details are available on the package
[website](https://jeffreyrstevens.github.io/excluder/).

## Installation

You can install the released version of `{excluder}`
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jeffreyrstevens/excluder")
```

## Verbs

This package provides three primary verbs:

-   `check` functions search for the exclusion criteria and output a
    message with the number of rows meeting the criteria and a data
    frame of the rows meeting the criteria. This is useful for viewing
    the potential exclusions.
-   `exclude` functions remove rows meeting the exclusion criteria. This
    is safest to do after checking the rows to ensure the exclusions are
    correct.
-   `mark` functions add a new column to the original data frame that
    labels the rows meeting the exclusion criteria. This is useful to
    label the potential exclusions for future processing without
    changing the original data frame.

## Exclusion types

This package provides six types of exclusions based on Qualtrics
metadata. If you have ideas for other metadata exclusions, please submit
them as [issues](https://github.com/jeffreyrstevens/excluder/issues).
Note, the intent of this package is not to develop functions for
excluding rows based on survey-specific data but on general, frequently
used metadata.

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
such as `check_duplicates()`, `exclude_ip()`, and `mark_duration()`.
Multiple functions can be linked together using the [`{magrittr}`]()
pipe `%>%`. For datasets downloaded directly from Qualtrics, use
`remove_label_rows()` to remove the first two rows of labels and convert
date and numeric columns in the metadata.

### Checking

The `check_*()` functions output messages about the number of rows that
meet the exclusion criteria.

``` r
library(excluder)
# Check for preview rows
qualtrics_text %>%
  check_preview()
#> 2 out of 100 rows were collected as previews. It is highly recommended to exclude these rows before further checking.
#>             StartDate             EndDate         Status IPAddress Progress
#> 1 2020-12-11 12:06:52 2020-12-11 12:10:30 Survey Preview      <NA>      100
#> 2 2020-12-11 12:06:43 2020-12-11 12:11:27 Survey Preview      <NA>      100
#>   Duration (in seconds) Finished        RecordedDate        ResponseId
#> 1                   465     TRUE 2020-12-11 12:10:30 R_xLWiuPaNuURSFXY
#> 2                   545     TRUE 2020-12-11 12:11:27 R_Q5lqYw6emJQZx2o
#>   LocationLatitude LocationLongitude UserLanguage Browser      Version
#> 1         29.73694         -94.97599           EN  Chrome 88.0.4324.41
#> 2         39.74107        -121.82490           EN  Chrome 88.0.4324.50
#>   Operating System Resolution
#> 1  Windows NT 10.0   1366x768
#> 2        Macintosh  1680x1050
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

### Marking

The `mark_*()` functions output the original data set with a new column
specifying rows that meet the exclusion criteria. These can be chained
together with `%>%` for multiple exclusion types.

``` r
# Mark preview and short duration rows
df <- qualtrics_text %>%
  mark_preview() %>%
  mark_duration(min_duration = 200)
#> 2 out of 100 rows were collected as previews. It is highly recommended to exclude these rows before further checking.
#> 23 out of 100 rows took less time than the minimum duration of 200 seconds.
tibble::glimpse(df)
#> Rows: 100
#> Columns: 18
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
#> $ exclusion_duration      <chr> NA, NA, NA, NA, "duration", NA, "duration", NA…
```

Use the [`collapse_exclusions()`](?collapse_exclusions) function to
collapse all of the marked columns into a single column.

``` r
# Collapse labels for preview and short duration rows
df <- qualtrics_text %>%
  mark_preview() %>%
  mark_duration(min_duration = 200) %>%
  collapse_exclusions(exclusion_types = c("preview", "duration"))
#> 2 out of 100 rows were collected as previews. It is highly recommended to exclude these rows before further checking.
#> 23 out of 100 rows took less time than the minimum duration of 200 seconds.
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
#> $ exclusions              <chr> "preview", "preview", NA, NA, "duration", NA, …
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
#> 6 out of 92 rows have duplicate IP addresses.
#> 
#> 9 out of 91 rows have duplicate locations.
#>    LocationLatitude LocationLongitude dupe_count           StartDate
#> 1          28.56411         -81.54902          2 2020-12-17 15:42:47
#> 2          28.56411         -81.54902          2 2020-12-17 15:42:18
#> 3          37.28265        -120.50248          2 2020-12-17 15:46:51
#> 4          37.28265        -120.50248          2 2020-12-17 15:48:53
#> 5          40.33554         -75.92698          2 2020-12-11 12:41:23
#> 6          40.33554         -75.92698          2 2020-12-17 15:41:17
#> 7          45.50412        -122.78665          3 2020-12-17 15:40:52
#> 8          45.50412        -122.78665          3 2020-12-17 15:40:57
#> 9          45.50412        -122.78665          3 2020-12-17 15:48:48
#> 10         37.28265        -120.50248          2 2020-12-17 15:46:51
#> 11         37.28265        -120.50248          2 2020-12-17 15:48:53
#> 12         40.33554         -75.92698          2 2020-12-11 12:41:23
#> 13         40.33554         -75.92698          2 2020-12-17 15:41:17
#> 14         28.56411         -81.54902          2 2020-12-17 15:42:47
#> 15         28.56411         -81.54902          2 2020-12-17 15:42:18
#>                EndDate     Status    IPAddress Progress Duration (in seconds)
#> 1  2020-12-17 15:46:26 IP Address  55.73.114.0      100                   236
#> 2  2020-12-17 15:48:00 IP Address  55.73.114.0      100                   526
#> 3  2020-12-17 15:51:38 IP Address   22.51.31.0      100                   872
#> 4  2020-12-17 15:53:48 IP Address   22.51.31.0      100                   246
#> 5  2020-12-11 12:44:37 IP Address  24.195.91.0      100                   177
#> 6  2020-12-17 15:45:42 IP Address  24.195.91.0      100                   521
#> 7  2020-12-17 15:43:39 IP Address 32.164.134.0      100                   375
#> 8  2020-12-17 15:48:56 IP Address   6.79.107.0      100                   397
#> 9  2020-12-17 15:54:12 IP Address 54.232.129.0      100                   149
#> 10 2020-12-17 15:51:38 IP Address   22.51.31.0      100                   872
#> 11 2020-12-17 15:53:48 IP Address   22.51.31.0      100                   246
#> 12 2020-12-11 12:44:37 IP Address  24.195.91.0      100                   177
#> 13 2020-12-17 15:45:42 IP Address  24.195.91.0      100                   521
#> 14 2020-12-17 15:46:26 IP Address  55.73.114.0      100                   236
#> 15 2020-12-17 15:48:00 IP Address  55.73.114.0      100                   526
#>    Finished        RecordedDate        ResponseId UserLanguage Browser
#> 1      TRUE 2020-12-17 15:46:26 R_7UzegytocfkyrWC           EN  Chrome
#> 2      TRUE 2020-12-17 15:48:00 R_NiK6d3RgjuJh1OI           EN  Chrome
#> 3      TRUE 2020-12-17 15:51:39 R_Gbz5en48KgnCXT7           EN Firefox
#> 4      TRUE 2020-12-17 15:53:48 R_AJfrQqClQNvWIch           EN    Edge
#> 5      TRUE 2020-12-11 12:44:37 R_LAt58JGEyKNWZlB           EN  Chrome
#> 6      TRUE 2020-12-17 15:45:42 R_GNVaLC9Sb2ZDzQP           EN  Chrome
#> 7      TRUE 2020-12-17 15:43:39 R_H5MqcQoWznreNBt           EN  Chrome
#> 8      TRUE 2020-12-17 15:48:56 R_8ezIj0X0p2lJuCQ           EN  Chrome
#> 9      TRUE 2020-12-17 15:54:12 R_Kc9BGXO793zEqHM           EN  Chrome
#> 10     TRUE 2020-12-17 15:51:39 R_Gbz5en48KgnCXT7           EN Firefox
#> 11     TRUE 2020-12-17 15:53:48 R_AJfrQqClQNvWIch           EN    Edge
#> 12     TRUE 2020-12-11 12:44:37 R_LAt58JGEyKNWZlB           EN  Chrome
#> 13     TRUE 2020-12-17 15:45:42 R_GNVaLC9Sb2ZDzQP           EN  Chrome
#> 14     TRUE 2020-12-17 15:46:26 R_7UzegytocfkyrWC           EN  Chrome
#> 15     TRUE 2020-12-17 15:48:00 R_NiK6d3RgjuJh1OI           EN  Chrome
#>          Version Operating System Resolution
#> 1   87.0.4280.88  Windows NT 10.0  1920x1080
#> 2   87.0.4280.88  Windows NT 10.0   1536x864
#> 3           83.0  Windows NT 10.0   1440x960
#> 4    84.0.522.52  Windows NT 10.0  1920x1080
#> 5  86.0.4240.198        Macintosh   1280x800
#> 6   87.0.4280.88   Windows NT 6.1   1366x768
#> 7   87.0.4280.88  Windows NT 10.0  1920x1080
#> 8   87.0.4280.88  Windows NT 10.0   1536x864
#> 9   87.0.4280.88  Windows NT 10.0  1920x1080
#> 10          83.0  Windows NT 10.0   1440x960
#> 11   84.0.522.52  Windows NT 10.0  1920x1080
#> 12 86.0.4240.198        Macintosh   1280x800
#> 13  87.0.4280.88   Windows NT 6.1   1366x768
#> 14  87.0.4280.88  Windows NT 10.0  1920x1080
#> 15  87.0.4280.88  Windows NT 10.0   1536x864
```

## Citing this package

To cite `{excluder}`, use:

> Stevens, J.R. (2021). excluder: Exclude rows to clean your data. R
> package version 0.1.0, <https://jeffreyrstevens.github.io/excluder/>.

## Contributing to this package

[Contributions](https://jeffreyrstevens.github.io/.github/CONTRIBUTING.md)
to `{excluder}` are most welcome! Feel free to check out [open
issues](https://github.com/jeffreyrstevens/excluder/issues) for ideas.
And [pull requests](https://github.com/jeffreyrstevens/excluder/pulls)
are encouraged, but you may want to [raise an
issue](https://github.com/jeffreyrstevens/excluder/issues/new/choose) or
[contact the maintainer](mailto:jeffrey.r.stevens@gmail.com) first.

Please note that the excluder project is released with a [Contributor
Code of
Conduct](https://jeffreyrstevens.github.io/excluder/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
