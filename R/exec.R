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
    path = file.path("bench", experiment$name),
    env = experiment$config
  )
  experiment$time <- as.numeric(out$stdout)
  experiment$version <- get_version(experiment$config)
  experiment$platform <- sessionInfo()[["platform"]]
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

  # we special case the VERSION env var here.
  version <- env[["VERSION"]]
  r_libs <- glue::glue("./RLIBS/{version}/")
  env <- c(env, R_LIBS_USER = r_libs)

  processx::run(
    command = Sys.which("Rscript"),
    args = path,
    cleanup_tree = TRUE,
    env = env
  )
}

execute_py <- function(path, env) {
  fs::path_ext(path) <- "py"

  # we special case the VERSION env var here.
  version <- env[["VERSION"]]
  py_interpreter <- glue::glue("./PYENV/torch-v{version}/bin/python")

  processx::run(
    command = py_interpreter,
    args = path,
    cleanup_tree = TRUE,
    env = c("current", env)
  )
}

get_version <- function(env) {
  execute(
    "tools/version",
    env
  )$stdout
}

get_language <- function(env) {
  language <- env["LANGUAGE"]

  if (is.null(language))
    stop("env var `LANGUAGE` must be set.")

  tolower(language)
}
