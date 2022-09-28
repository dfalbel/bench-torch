library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", "cuda")

f <- function() {

  w <- torch_randn(784, 512, device = device)
  x <- torch_randn(batch_size, 784, device = device)

  for (i in 1:iter) {
    x$mm(w)$cpu()
  }

  invisible(NULL)
}

x <- torch_randn(10000, 10000, device = "cuda")
res <- torch_mm(x, x)
x <- torch_randn(10000, 10000, device = "cuda")
res <- torch_mm(x, x)
x <- torch_randn(10000, 10000, device = "cuda")
res <- torch_mm(x, x)

iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "1000"))

cat(system.time(f())[["elapsed"]])
