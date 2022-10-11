import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "32"))

x = torch.randn(batch_size, 784)
w = torch.randn(784, 512, requires_grad = True)

def mm ():
  for i in range(ir):
    loss = torch.sum(torch.mm(x, w))
    loss.backward()
    w.grad.zero_()

ir = 1
mm()
ir = int(os.environ.get('ITER', "1000000"))

start_time = time.time()
mm()
print((time.time() - start_time))
