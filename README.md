
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

This package provides seven types of exclusions based on Qualtrics
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
such as
[`check_duplicates()`](https://jeffreyrstevens.github.io/excluder/reference/check_duplicates.html),
[`exclude_ip()`](https://jeffreyrstevens.github.io/excluder/reference/exclude_ip.html),
and
[`mark_duration()`](https://jeffreyrstevens.github.io/excluder/reference/mark_duration.html).
Multiple functions can be linked together using the
[`{magrittr}`](https://magrittr.tidyverse.org/) pipe `%>%`. For datasets
downloaded directly from Qualtrics, use
[`remove_label_rows()`](https://jeffreyrstevens.github.io/excluder/reference/remove_label_rows.html)
to remove the first two rows of labels and convert date and numeric
columns in the metadata and use
[`deidentify()`](https://jeffreyrstevens.github.io/excluder/reference/deidentify.html)
to remove standard Qualtrics columns with identifiable information.

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

Use the
[`collapse_exclusions()`](https://jeffreyrstevens.github.io/excluder/reference/collapse_exclusions.html)
function to collapse all of the marked columns into a single column.

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

## Citing this package

To cite `{excluder}`, use:

> Stevens, J.R. (2021). excluder: Exclude rows to clean your data. R
> package version 0.2.0, <https://jeffreyrstevens.github.io/excluder/>.

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
