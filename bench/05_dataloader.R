library(torch)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", unset = "cpu")

Dataset <- dataset(
  initialize = function(ir, batch_size) {
    self$len <- ir*batch_size
    self$x <- torch_randn(self$len, 28, 28)
    self$y <- torch_randint(1, 10, size = c(self$len))
  },
  .getbatch = function(i) {
    list(
      self$x[i],
      self$y[i]
    )
  },
  .length = function() {
    self$len
  }
)

if (device == "cpu") {
  fn <- function() {
    coro::loop(for(el in dataloader(ds, batch_size = batch_size)) {
      x <- el[[1]]
      y <- el[[2]]
    })
    invisible(NULL)
  }
} else {
  fn <- function() {
    coro::loop(for(el in dataloader(ds, batch_size = batch_size)) {
      x <- el[[1]]$cuda()
      y <- el[[2]]$cuda()
    })
    cuda_synchronize()
    invisible(NULL)
  }
}

iter <- 1
ds <- Dataset(iter, batch_size)

fn()

iter <- as.numeric(Sys.getenv("ITER", unset = "100"))
ds <- Dataset(iter, batch_size)

cat(system.time(fn())[["elapsed"]])
