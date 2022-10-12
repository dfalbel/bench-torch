#' Execute experiment
#'
#' @param experiment is a list with the name of a file to be executed and a
#'   config fields with ENV vars that must be set before the execution.
#'
#' The language env var must be set so we can decide which language to use
#' when executing the experiment.
#'
execute_experiment <- function(experiment) {
  out <- execute(
    name = file.path("bench", experiment$name),
    config = experiment$config
  )
  experiment$time <- as.numeric(out$stdout)
  experiment$version <- get_version(experiment$config)
  experiment
}

execute <- function(path, env) {
  language <- get_language(env)

  if (tolower(language) == "r") {
    execute_r(path, env)
  } else if (tolower(language) == "py") {
    execute_py(path, env)
  } else {
    stop("unknown language ", language)
  }
}

execute_r <- function(path, env) {
  fs::path_ext(path) <- "R"
  processx::run(
    command = "Rscript",
    args = path,
    cleanup_tree = TRUE
  )
}

execute_py <- function(path, env) {
  fs::path_ext(path) <- "py"
  processx::run(
    command = reticulate::py_config()$python,
    args = path,
    cleanup_tree = TRUE
  )
}

get_version <- function(env) {
  execute(
    "tools/version",
    env
  )
}

get_language <- function(env) {
  language <- env$LANGUAGE

  if (is.null(language))
    stop("env var `LANGUAGE` must be set.")

  tolower(language)
}
