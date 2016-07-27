
`logentries` : R interface to LogEntries API

The following functions are implemented:

-   `le_acct_key`: Get or set LOGENTRIES\_ACCOUNT\_KEY value
-   `le_read_log`: Read log data from LogEntries
-   `le_ro_key`: Get or set LOGENTRIES\_READ\_ONLY\_KEY value
-   `le_write_log`: Post log data to LogEntries

### Installation

``` r
devtools::install_github("hrbrmstr/logentries")
```

### Usage

``` r
library(logentries)

# current verison
packageVersion("logentries")
```

    ## [1] '0.1.0'

### Test Results

``` r
library(logentries)
library(testthat)

date()
```

    ## [1] "Wed Jul 27 16:04:51 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
