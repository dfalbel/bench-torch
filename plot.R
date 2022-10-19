library(tidymodels)
library(jsonlite)

prepare_line <- function(x) {
  x %>%
    modify_at("config", list) %>%
    as_tibble()
}

results <- read_json("results/2022-10-19/0a6f752-results.json") %>%
  map_dfr(prepare_line) %>%
  unnest_wider(config, transform = as.character) %>%
  mutate(
    name = as.character(name),
    time = as.numeric(time),
    version = as.character(version),
    BATCH_SIZE = as.numeric(BATCH_SIZE),
    ITER = as.numeric(ITER)
  ) %>%
  mutate(time = time/ITER*100)

py_reference <- results %>%
  filter(LANGUAGE == "py") %>%
  group_by(name, BATCH_SIZE) %>%
  summarise(
    time_py = mean(time, trim = 0.2),
    .groups = "drop"
  )

r_results <- results %>%
  filter(LANGUAGE == "r") %>%
  group_by(VERSION, name, BATCH_SIZE) %>%
  summarise(
    time_r = mean(time, trim = 0.2),
    .groups = "drop"
  ) %>%
  left_join(py_reference, by = c("name", "BATCH_SIZE")) %>%
  mutate(time_rel = time_r/time_py)

r_results %>%
  ggplot(aes(x = BATCH_SIZE, y = time_rel, color = VERSION)) +
  geom_point() +
  geom_line() +
  facet_wrap(~name, ncol = 3, scales = "free") +
  geom_hline(yintercept = 1, aes(color = "python"), linetype = "dashed")

