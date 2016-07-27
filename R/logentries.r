#' Read log data from LogEntries
#'
#' This is the simple interface to LogEntries
#' @param logs_set,log_name names of the set & log
#' @param start,end start and end timestamps (ms from epoch)
#' @param filter keyword filter
#' @param limit how many entries to return?
#' @param acct_key LogEntries account key
#' @export
le_read_log <- function(log_set="DemoSet", log_name="Usage_trail",
                     start=NULL, end=NULL, filter=NULL, limit=NULL,
                     acct_key=le_acct_key()) {
  le_url <- sprintf("https://pull.logentries.com/%s/hosts/%s/%s/", acct_key,
                    log_set, log_name)
  res <- GET(le_url,
             query=list(start=start,
                        end=end,
                        filter=filter,
                        limit=limit,
                        format="json"))
  stop_for_status(res)
  ret <- content(res, as="text", encoding="UTF-8")
  fromJSON(ret, flatten=TRUE)
}

#' @export
leql <- function(log_id, query, from, to, per_page=NULL, sequence_number=NULL,
                 ro_key=le_ro_key()) {

  le_url <- sprintf("https://rest.logentries.com/query/logs/%s", log_id)

  res <- GET(le_url,
             add_headers(`x-api-key`=ro_key),
             query=list(query=query,
                        from=from,
                        to=to,
                        per_page=per_page,
                        sequence_number=sequence_number))

  stop_for_status(res)

  ret <- content(res, as="text", encoding="UTF-8")
  fromJSON(ret, flatten=TRUE)

}

#' Post log data to LogEntries
#'
#' You need to setup a \href{https://docs.logentries.com/docs/input-token}{log token}
#' which should be supplied as the \code{log_token} parameter.
#'
#' @param log_data the text to log. No conversion is done but LogEntries expectes
#'        the content to be textual and 8192 characters or less.
#' @param log_token api token for the log
#' @export
le_write_log <- function(log_data, log_token) {

  post_url <- sprintf("https://webhook.logentries.com/noformat/logs/%s", log_token)

  res <- POST(post_url, encode="json", body=list(data=log_data))
  stop_for_status(res)
  invisible(status_code(res) == 204)

}

#' Get or set LOGENTRIES_ACCOUNT_KEY value
#'
#' The API wrapper functions in this package all rely on a LogEntries account API
#' key residing in the environment variable \code{LOGENTRIES_ACCOUNT_KEY}. The
#' easiest way to accomplish this is to set it in the `.Renviron` file in your
#' home directory.
#'
#' @param force force setting a new LogEntries account API key for the current environment?
#' @return atomic character vector containing the LOGENTRIES_ACCOUNT_KEY API key
#' @export
le_acct_key <- function(force = FALSE) {

  env <- Sys.getenv('LOGENTRIES_ACCOUNT_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var LOGENTRIES_ACCOUNT_KEY to your LogEntries API key",
      call. = FALSE)
  }

  message("Couldn't find env var LOGENTRIES_ACCOUNT_KEY See ?le_acct_key for more details.")
  message("Please enter your LogEntries account API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("LogEntries account API key entry failed", call. = FALSE)
  }

  message("Updating LOGENTRIES_ACCOUNT_KEY env var to PAT")
  Sys.setenv(LOGENTRIES_ACCOUNT_KEY = pat)

  pat

}

#' Get or set LOGENTRIES_READ_ONLY_KEY value
#'
#' The API wrapper functions in this package all rely on a LogEntries read only API
#' key residing in the environment variable \code{LOGENTRIES_READ_ONLY_KEY}. The
#' easiest way to accomplish this is to set it in the `.Renviron` file in your
#' home directory.
#'
#' @param force force setting a new LogEntries read only API key for the current environment?
#' @return atomic character vector containing the LOGENTRIES_READ_ONLY_KEY API key
#' @export
le_ro_key <- function(force = FALSE) {

  env <- Sys.getenv('LOGENTRIES_READ_ONLY_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var LOGENTRIES_READ_ONLY_KEY to your LogEntries read only key",
      call. = FALSE)
  }

  message("Couldn't find env var LOGENTRIES_READ_ONLY_KEY See ?le_ro_key for more details.")
  message("Please enter your LogEntries read only API key and press enter:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("LogEntries read only key entry failed", call. = FALSE)
  }

  message("Updating LOGENTRIES_READ_ONLY_KEY env var to PAT")
  Sys.setenv(LOGENTRIES_ACCOUNT_KEY = pat)

  pat

}