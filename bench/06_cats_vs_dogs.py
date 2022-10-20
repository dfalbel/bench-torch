import torch
import torchvision
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "250"))
device = os.environ.get('DEVICE', "cpu")

ds = torchvision.datasets.ImageFolder(
  "cats-dogs/PetImages/",
  transform = torchvision.transforms.Compose([
    torchvision.transforms.ToTensor(),
    torchvision.transforms.Resize(size=(224,224))
  ])
)

def f ():
    i = 0
    for el in torch.utils.data.DataLoader(ds, batch_size = batch_size):
      x = el[0].to(device=device)
      y = el[1].to(device=device)
      i = i + 1
      if i > ir:
        break

if device=="cpu":
  fn = f
else:
  def fn():
    f()
    torch.cuda.synchronize()

ir = 1
fn()
ir = int(os.environ.get('ITER', "10"))

start_time = time.time()
fn()
print((time.time() - start_time))
