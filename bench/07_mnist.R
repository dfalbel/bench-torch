library(torch)
library(torchvision)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "128"))
vectorized <- Sys.getenv("VECTORIZED_DS", unset = "yes")
device <- Sys.getenv("DEVICE", unset = "cpu")

if (vectorized == "no") {
  mnist_dataset <- torchvision::mnist_dataset(
    root = "./mnist-r",
    download = TRUE,
    transform = transform_to_tensor
  )
} else {
  mnist_dataset <- torch::dataset(
    initialize = function(...) {
      mnist_dataset <- torchvision::mnist_dataset(...)
      self$data <- torch_tensor(mnist_dataset$data, dtype = torch_float())$div(255)$unsqueeze(2)
      self$classes <- mnist_dataset$targets
    },
    .getbatch = function(i) {
      list(self$data[i], self$classes[i])
    },
    .length = function() {
      self$data$size(1)
    }
  )(root = "./mnist-r",
    download = TRUE)
}

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

model <- net()$to(device=device)
optimizer <- optim_sgd(model$parameters, lr = 0.01)
dl <- dataloader(mnist_dataset, batch_size = batch_size)

f <- function() {
  i <- 0
  coro::loop(for (b in dl) {
    optimizer$zero_grad()
    output <- model(b[[1]]$to(device=device))
    loss <- nnf_cross_entropy(output, b[[2]]$to(device=device))
    loss$backward()
    optimizer$step()
    i <- i + 1
    if (i > iter)
      break
  })

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

iter <- as.numeric(Sys.getenv("ITER", unset = "20"))
cat(system.time(fn())[["elapsed"]])
