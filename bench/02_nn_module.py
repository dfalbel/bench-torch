import torch
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "1000"))

def mm ():
  x = torch.randn(batch_size, 784)
  module = torch.nn.Linear(784, 512)
  for i in range(ir):
    module(x)

ir = 1
mm()
ir = int(os.environ.get('ITER', "1000"))

start_time = time.time()
mm()
print((time.time() - start_time))

