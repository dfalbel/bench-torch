library(torch)
library(torchvision)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))
device <- Sys.getenv("DEVICE", unset = "cpu")

ds <- torchvision::image_folder_dataset(
  "cats-dogs/PetImages/",
  transform = function(x) {
    x |>
      transform_to_tensor() |>
      transform_resize(c(224, 224))
  }
)

f <- function() {
  i <- 0
  coro::loop(for(el in dataloader(ds, batch_size = batch_size)) {
    x <- el[[1]]$to(device=device)
    y <- el[[2]]$to(device=device)
    i <- i + 1
    if (i > iter) break
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
iter <- as.numeric(Sys.getenv("ITER", unset = "10"))
cat(system.time(fn())[["elapsed"]])
