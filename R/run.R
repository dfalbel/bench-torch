run_benchmark <- function(file = "bench.yaml") {
  configs <- parse_config(file)
  results <- list()
  for (i in seq_along(configs)) {
    cat("[", i, "/", length(configs), "]", configs[[i]]$name, "|",
        conf_summary(configs[[i]]))
    time <- system.time({
      results[[i]] <- execute_experiment(configs[[i]])
    })
    cat(" TOTAL_TIME_ELLAPSED:", time[["elapsed"]], "\n")
  }
  jsonlite::write_json(results, "results.json")
}

conf_summary <- function(config) {
  config <- config$config
  nms <- paste0(names(config), ":")
  values <- config
  c(rbind(nms, values))
}
