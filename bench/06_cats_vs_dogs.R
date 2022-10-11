library(torch)
library(torchvision)

batch_size <- as.numeric(Sys.getenv("BATCH_SIZE", unset = "1000"))

ds <- torchvision::image_folder_dataset(
  "cats-dogs/PetImages/",
  transform = function(x) {
    x |>
      transform_to_tensor() |>
      transform_resize(c(224, 224))
  }
)

f <- function() {
  i <- 1
  coro::loop(for(el in dataloader(ds, batch_size = batch_size)) {
    x <- el[[1]]
    y <- el[[2]]
    i <- i + 1
    if (i > iter) break
  })
  invisible(NULL)
}

iter <- 1
f()
iter <- as.numeric(Sys.getenv("ITER", unset = "10"))
cat(system.time(f())[["elapsed"]])
