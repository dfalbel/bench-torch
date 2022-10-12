#' Takes a bench.yaml file and lists all the experiments that need to run.
#'
#' @param file path to configuration file.
#'
#' @export
parse_config <- function(file = "bench.yaml") {
  file <- yaml::read_yaml(file)
  benchmarks <- names(file$bench)

  file$bench |>
    purrr::map(~purrr::cross(.x$matrix)) |>
    purrr::imap(function(configs, name) {
      purrr::map(configs, function(config) {
        list(name = name, config = config)
      })
    }) |>
    purrr::flatten() |>
    purrr::map(~purrr::modify_at(.x, "config", flatten_config))
}

required_r_versions <- function(file = "bench.yaml") {
  file |>
    parse_config() |>
    purrr::keep(~.x$config['LANGUAGE'] == "r") |>
    purrr::map_chr(~.x$config['VERSION']) |>
    unique()
}

required_py_versions <- function(file) {
  file |>
    parse_config() |>
    purrr::keep(~.x$config['LANGUAGE'] == "py") |>
    purrr::map_chr(~.x$config['VERSION']) |>
    unique()
}

flatten_config <- function(config) {
  out <- list()

  if (any(names(config) == ""))
    stop("Every element must be named.")

  for (el in names(config)) {
    if (is.list(config[[el]])) {
      out[[length(out) + 1]] <- flatten_config(config[[el]])
    } else {
      out[[el]] <- config[[el]]
    }
  }
  unlist(out)
}
