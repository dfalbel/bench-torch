library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))

module <- nn_linear(784, 512)
x <- torch_randn(batch_size, 784)

f <- function() {
  for (i in 1:iter) {
    module(x)
  }

  invisible(NULL)
}

iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "1000"))

cat(system.time(f())[["elapsed"]])
