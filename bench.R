library(tidyverse)

execute_r <- function(path) {
  fs::path_ext(path) <- "R"
  processx::run(
    command = "Rscript",
    args = path,
    cleanup_tree = TRUE
  )
}

execute_py <- function(path) {
  fs::path_ext(path) <- "py"
  processx::run(
    command = reticulate::py_config()$python,
    args = path,
    cleanup_tree = TRUE
  )
}

parse_result <- function(out) {
  as.numeric(out$stdout)
}

run_bench <- function(name, language) {

  execute <- if (language == "r") execute_r else execute_py

  tibble::tibble(
    bench = fs::path_file(name),
    time = parse_result(execute(name)),
  )
}

get_version <- function(language) {
  version <- if (tolower(language) == "r") {
    execute_r("tools/version")$stdout
  } else {
    execute_py("tools/version")$stdout
  }
  stringr::str_trim(version)
}

CRAN_TORCH_LIB <- "/Library/Frameworks/R.framework/Versions/4.2/Resources/library"

config <- list(
  list(BATCH_SIZE = 32,   ITER = 2000, R_LIBS_USER = ""),
  list(BATCH_SIZE = 32,   ITER = 2000, R_LIBS_USER = CRAN_TORCH_LIB),
  list(BATCH_SIZE = 256,  ITER = 1000, R_LIBS_USER = ""),
  list(BATCH_SIZE = 256,  ITER = 1000, R_LIBS_USER = CRAN_TORCH_LIB),
  list(BATCH_SIZE = 512,  ITER = 1000, R_LIBS_USER = ""),
  list(BATCH_SIZE = 512,  ITER = 1000, R_LIBS_USER = CRAN_TORCH_LIB),
  list(BATCH_SIZE = 1024, ITER = 500,  R_LIBS_USER = ""),
  list(BATCH_SIZE = 1024, ITER = 500,  R_LIBS_USER = CRAN_TORCH_LIB),
  list(BATCH_SIZE = 2048, ITER = 500,  R_LIBS_USER = ""),
  list(BATCH_SIZE = 2048, ITER = 500,  R_LIBS_USER = CRAN_TORCH_LIB)
)

# for (conf in config) {
#   Sys.setenv("R_LIBS_USER" = conf$R_LIBS_USER)
#   print(get_version("r"))
# }
#
if (fs::file_exists("results.rds")) {
  results <- readRDS("results.rds")
} else {
  results <- tibble::tibble(
    language = character(),
    version = character(),
    bench = character(),
    batch_size = numeric(),
    iter = numeric(),
    time = numeric()
  )
}

for (conf in config) {

  Sys.setenv("BATCH_SIZE" = conf$BATCH_SIZE)
  Sys.setenv("ITER" = conf$ITER)
  Sys.setenv("R_LIBS_USER" = conf$R_LIBS_USER)

  benchmarks <- fs::dir_ls(path = "bench", glob = "*.R")

  for (language in c("r", "py")) {
    version <- get_version(language)
    for (bench in benchmarks) {

      bench_res <- results %>%
        filter(bench == fs::path_file(.env[["bench"]])) %>%
        filter(version == .env[["version"]]) %>%
        filter(language == .env[["language"]]) %>%
        filter(batch_size == conf$BATCH_SIZE) %>%
        filter(iter == conf$ITER)

      if (nrow(bench_res) == 0) {
        for (i in 1:10) {

          res <- run_bench(bench, language)
          res$version <- version
          res$batch_size <- conf$BATCH_SIZE
          res$iter <- conf$ITER
          res$language <- language

          results <- results %>%
            dplyr::add_row(res)
        }
      }

    }
  }
}

saveRDS(results, "results.rds")
