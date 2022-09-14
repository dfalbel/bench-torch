library(torch)

batch_size <- 32
module <- nn_linear(784, 512)


f <- function() {

  x <- torch_randn(batch_size, 784)

  for (i in 1:iter) {
    module(x)
  }

  invisible(NULL)
}

library(proffer)
pprof(interval = 0.01,{
  f()
})

