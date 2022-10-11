import torch
import torchvision
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "250"))

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
    x = el[0]
    y = el[1]
    i = i + 1
    if i > ir:
      break

ir = 1
f()
ir = int(os.environ.get('ITER', "10"))

start_time = time.time()
f()
print((time.time() - start_time))
