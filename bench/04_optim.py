import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))
ir = int(500*1000/batch_size)

def mm ():
  x = torch.randn(batch_size, 784)
  w = torch.randn(784, 512, requires_grad = True)
  opt = torch.optim.SGD([w], lr = 0.01)
  for i in range(ir):
    loss = torch.sum(torch.mm(x, w))
    loss.backward()
    opt.step()
    opt.zero_grad()

start_time = time.time()
mm()
print((time.time() - start_time))

