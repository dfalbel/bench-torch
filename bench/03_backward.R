library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
iter <- 250*1000/batch_size

f <- function() {
  w <- torch_randn(784, 512, requires_grad = TRUE)
  x <- torch_randn(batch_size, 784)

  for (i in 1:iter) {
    loss <- torch_sum(torch_mm(x, w))
    loss$backward()
    w$grad$zero_()
  }

  invisible(NULL)
}

cat(system.time(f())[["elapsed"]])
