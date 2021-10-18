# excluder 0.3.0

### NEW FEATURES

* The `mark_durations()` function now marks fast and slow durations separately.
* The primary functionality of the package has moved from the `check_*()` functions to the `mark_*()` functions. Thus, `check_*()` and `exclude_*()` now first call `mark_*()` to mark the rows with exclusion criteria, then filter the excluded rows. The documentation for `check_*()` and `exclude_*()` now inherit the arguments from `mark_*()`. This change has been updated in the README and Getting Started vignette.

### MINOR IMPROVEMENTS

* `exclude__*()` functions now have `print = FALSE` and `quiet = TRUE` set as default argument values.
* Calls to `rbind()` have been replaced with `bind_cols()` and `dplyr::pull()` has been replaced with `[[]]`.
* Calls to `all_of()` and `any_of()` now refer to {tidyselect} rather than {dplyr}.
* `if()` statements are now more robust by using `identical()` rather than `==` and `&&` instead of `&`.
* The {stringr} package is now imported instead of suggested.
* All mark, check, and exclude functions for a particular exclusion type have been combined into a single R file. So now each exclusion type has its own R file. Similarly, data file scripts have been combined into a single file.

### BUG FIXES

* The `*_ip()` functions and documentation have been updated to fix a bug/typo to clarify that they mark, check, and exclude rows with IP addresses outside of the specified country.

### DEPRECATED AND DEFUNCT

* `collapse_exclusions()` has been renamed `unite_exclusions()` to match {tidyverse} terminology. `collapse_exclusions()` is now deprecated and will be removed in a future version, use `unite_exlusions()`. `unite_exlusions()` also switched from using NA to "" for rows with no exclusions. Combined columns now no longer have leftover separators.

### DOCUMENTATION FIXES

* Package links are replaced with external URLs.


# excluder 0.2.2

* Lifecycle has been updated to Stable, and the repo status of Active has been added.
* There is now a Getting Started Excluding Data vignette that gives an overview of package usage.
* Users can now specify the separator used between exclusion types in the `collapse_exclusions()` function. They can also opt to not remove the excluded columns.
* A bug in the `collapse_exclusions()` function was fixed, so now a subset of exclusion columns can be collapsed into a single column.
* A bug in the `remove_label_rows()` function was fixed, so now the Finished column is converted to a logical vector.
* A codemeta.json file was created.
* URLs have been replaced or tweaked to address CRAN package check warnings.
* Functions are now organized by topic in the Reference page of the website.

# excluder 0.2.1

* The argument name for the data frame switched from `.data` to `x` to avoid confusion with the `{rlang}` use of `.data`.
* Instead of using `quo()` and `sym()` to create new names for columns used as arguments, `.data[[var]]` is now used.
* The `dupe_count` column was removed from `check_duplicates()` output. Tests were adjusted to account for the new number of columns.
* `check_duplicates()` now specifies the number of NA columns.
* URLs have been replaced or tweaked to address CRAN package check warnings.
* Links function reference pages have been added to the README.

# excluder 0.2.0

* The `deidentify()` function was added, which removes IP address, location, and computer information columns.

# excluder 0.1.0

* The `check_qualtrics` argument was removed from `remove_label_rows()` because the functionality did not make sense. This breaks backwards compatability.
* `remove_label_rows()` now only filters out label rows if label rows are present and outputs invisibly.
* Tests were added for the `qualtrics_raw` dataset and the `remove_label_rows()` function.
* Package-level documentation was created.

# excluder 0.0.1

* `remove_label_rows()` now converts character columns to dates for multiple date formats, including YYYY-MM-DD HH:MM:SS, YYYY-MM-DD HH:MM, MM:DD:YYYY HH:MM:SS, and MM:DD:YYYY HH:MM (#1).
* Code of Conduction and Contributor Guide are added.
* Citation and Contributor sections are added to README.

# excluder 0.0.0.1

* Initial GitHub release
