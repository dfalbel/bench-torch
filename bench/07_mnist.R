library(torch)
library(torchvision)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
mnist_dataset <- torchvision::mnist_dataset(
  root = "./mnist-r",
  download = TRUE,
  transform = transform_to_tensor
)

net <- nn_module(
  "Net",
  initialize = function() {
    self$conv1 <- nn_conv2d(1, 32, 3, 1)
    self$conv2 <- nn_conv2d(32, 64, 3, 1)
    self$dropout1 <- nn_dropout(0.25)
    self$dropout2 <- nn_dropout(0.5)
    self$fc1 <- nn_linear(9216, 128)
    self$fc2 <- nn_linear(128, 10)
  },
  forward = function(x) {
    x <- self$conv1(x)
    x <- nnf_relu(x)
    x <- self$conv2(x)
    x <- nnf_relu(x)
    x <- nnf_max_pool2d(x, 2)
    x <- self$dropout1(x)
    x <- torch_flatten(x, start_dim = 2)
    x <- self$fc1(x)
    x <- nnf_relu(x)
    x <- self$dropout2(x)
    output <- self$fc2(x)
    output
  }
)

dl <- dataloader(mnist_dataset, batch_size = batch_size)

f <- function() {
  i <- 0
  model <- net()
  optimizer <- optim_sgd(model$parameters, lr = 0.01)

  coro::loop(for (b in dl) {
    optimizer$zero_grad()
    output <- model(b[[1]])
    loss <- nnf_cross_entropy(output, b[[2]])
    loss$backward()
    optimizer$step()
    i <- i + 1
    if (i > iter)
      break
  })

  invisible(NULL)
}

iter <- 1
f()

iter <- as.numeric(Sys.getenv("ITER", unset = "100"))
cat(system.time(f())[["elapsed"]])
