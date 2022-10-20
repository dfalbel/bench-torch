import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))
device = os.environ.get('DEVICE', "cpu")

x = torch.randn(batch_size, 784, device = device)
module = torch.nn.Linear(784, 512).to(device=device)

def f ():
  for i in range(ir):
    module(x)

if device=="cpu":
  fn = f
else:
  def fn():
    f()
    torch.cuda.synchronize()

ir = 1
fn()
ir = int(os.environ.get('ITER', "1000"))

start_time = time.time()
fn()
print((time.time() - start_time))

