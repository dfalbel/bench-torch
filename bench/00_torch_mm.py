import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))
device = os.environ.get("DEVICE", "cuda")

def mm ():
  x = torch.randn(batch_size, 784, device = device)
  w = torch.randn(784, 512, device = device)
  for i in range(ir):
    torch.mm(x, w).cpu()

    
ir = 1    
mm()
ir = int(os.environ.get('ITER', "1000"))

start_time = time.time()
mm()
print((time.time() - start_time))

