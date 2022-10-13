get_r_install_command <- function(version) {
  if (stringr::str_detect(version, "CRAN")) {
    v <- stringr::str_replace_all(version, stringr::fixed("CRAN-v"), "")
    cat(paste0("remotes::install_version('torch', '", v, "')"))
  } else {
    v <- version
    cat(paste0("remotes::install_github('mlverse/torch@", v, "')"))
  }
  invisible(NULL)
}

required_r_versions <- function(file = "bench.yaml") {
  file |>
    parse_config() |>
    purrr::keep(~.x$config['LANGUAGE'] == "r") |>
    purrr::map_chr(~.x$config['VERSION']) |>
    unique() %>%
    cat()
  invisible(NULL)
}

required_py_versions <- function(file = "bench.yaml") {
  file |>
    parse_config() |>
    purrr::keep(~.x$config['LANGUAGE'] == "py") |>
    purrr::map_chr(~.x$config['VERSION']) |>
    unique() %>%
    cat()
  invisible(NULL)
}
