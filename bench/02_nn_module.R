library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", "cpu")

f <- function() {
  module <- nn_linear(784, 512)
  module$to(device = device)
  x <- torch_randn(batch_size, 784, device = device)

  for (i in 1:iter) {
    module(x)
  }

  invisible(NULL)
}

iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "10000"))

cat(system.time(f())[["elapsed"]])
