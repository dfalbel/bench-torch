import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))
ir = int(1000*500/batch_size)

def mm ():
  x = torch.randn(batch_size, 784)
  w = torch.randn(784, 512)
  for i in range(ir):
    torch.mm(x, w)

start_time = time.time()
mm()
print((time.time() - start_time))

