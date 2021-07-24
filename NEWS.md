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
