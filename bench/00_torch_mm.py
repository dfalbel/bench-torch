import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))

def mm ():
  x = torch.randn(batch_size, 784)
  w = torch.randn(784, 512)
  for i in range(ir):
    torch.mm(x, w)

    
ir = 1    
mm()
ir = int(os.environ.get('ITER', "1000"))

start_time = time.time()
mm()
print((time.time() - start_time))

