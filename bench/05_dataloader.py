import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))
device = os.environ.get('DEVICE', "cpu")

class Dataset (torch.utils.data.Dataset):
  def __init__ (self, ir, batch_size):
    self.l = ir*batch_size
    self.x = torch.randn(ir*batch_size, 28, 28)
    self.y = torch.randint(10, (ir*batch_size,))
  def __getitem__ (self, i):
    return (self.x[i], self.y[i])
  def __len__ (self):
    return self.l

if device == "cpu":
  def fn ():
    for el in torch.utils.data.DataLoader(ds, batch_size = batch_size):
      x = el[0]
      y = el[1]
else:
  def fn():
    for el in torch.utils.data.DataLoader(ds, batch_size = batch_size):
      x = el[0].cuda()
      y = el[1].cuda()
    torch.cuda.synchronize()

ir = 1
ds = Dataset(ir, batch_size)

fn()

ir = int(os.environ.get('ITER', "1000"))
ds = Dataset(ir, batch_size)

start_time = time.time()
fn()
print((time.time() - start_time))

