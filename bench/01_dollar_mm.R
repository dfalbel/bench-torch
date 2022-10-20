library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", unset = "cpu")

w <- torch_randn(784, 512, device=device)
x <- torch_randn(batch_size, 784, device=device)

f <- function() {
  for (i in 1:iter) {
    x$mm(w)
  }
  invisible(NULL)
}

if (device == "cpu") {
  fn <- f
} else {
  fn <- function() {
    f()
    torch:::cuda_synchronize()
  }
}

iter <- 1
fn()
iter <- as.numeric(Sys.getenv("ITER", unset = "1000"))

cat(system.time(fn())[["elapsed"]])
