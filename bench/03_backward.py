import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "32"))
device = os.environ.get('DEVICE', "cpu")

x = torch.randn(batch_size, 784, device=device)
w = torch.randn(784, 512, requires_grad = True, device=device)

def f ():
  for i in range(ir):
    loss = torch.sum(torch.mm(x, w))
    loss.backward()
    w.grad.zero_()

if device=="cpu":
  fn = f
else:
  def fn():
    f()
    torch.cuda.synchronize()

ir = 1
fn()
ir = int(os.environ.get('ITER', "1000000"))

start_time = time.time()
fn()
print((time.time() - start_time))
