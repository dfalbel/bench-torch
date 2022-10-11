library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "32"))

w <- torch_randn(784, 512, requires_grad = TRUE)
x <- torch_randn(batch_size, 784)

f <- function() {
  for (i in 1:iter) {
    loss <- torch_sum(torch_mm(x, w))
    loss$backward()
    w$grad$zero_()
  }

  invisible(NULL)
}

iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "500"))

cat(system.time(f())[["elapsed"]])
