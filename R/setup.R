get_r_install_command <- function(version) {
  if (stringr::str_detect(version, "CRAN")) {
    v <- stringr::str_replace_all(version, stringr::fixed("CRAN-v"), "")
    cat(paste0("remotes::install_version('torch', '", v, "')"))
  } else {
    v <- version
    cat(paste0("remotes::install_github('mlverse/torch@", v, "')"))
  }
}
