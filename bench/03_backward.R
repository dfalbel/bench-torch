library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", "cpu")

f <- function() {
  w <- torch_randn(784, 512, requires_grad = TRUE, device = device)
  x <- torch_randn(batch_size, 784, device = device)

  for (i in 1:iter) {
    loss <- torch_sum(torch_mm(x, w))
    loss$backward()
    w$grad$zero_()
  }

  invisible(NULL)
}

# res <- torch_randn(10000,10000, device = "cuda")
# rm(res)
iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "500"))

cat(system.time(f())[["elapsed"]])
