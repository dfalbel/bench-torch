library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
iter <- 1000*500/batch_size

f <- function() {

  w <- torch_randn(784, 512)
  x <- torch_randn(batch_size, 784)

  for (i in 1:iter) {
    x$mm(w)
  }

  invisible(NULL)
}

cat(system.time(f())[["elapsed"]])
