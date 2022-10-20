import torch
import torchvision
import time
import os

batch_size = int(os.environ.get('BATCH_SIZE', "128"))
device = os.environ.get('DEVICE', "cpu")

mnist_dataset = torchvision.datasets.MNIST(
  download = True, 
  root = "mnist-py",
  transform = torchvision.transforms.ToTensor()
)

class Net(torch.nn.Module):
  
  def __init__(self):
    super().__init__()
    self.conv1 = torch.nn.Conv2d(1, 32, 3, 1)
    self.conv2 = torch.nn.Conv2d(32, 64, 3, 1)
    self.dropout1 = torch.nn.Dropout(0.25)
    self.dropout2 = torch.nn.Dropout(0.5)
    self.fc1 = torch.nn.Linear(9216, 128)
    self.fc2 = torch.nn.Linear(128, 10)
  
  def forward(self, x):
    x = self.conv1(x)
    x = torch.nn.functional.relu(x)
    x = self.conv2(x)
    x = torch.nn.functional.relu(x)
    x = torch.nn.functional.max_pool2d(x, 2)
    x = self.dropout1(x)
    x = torch.flatten(x, start_dim = 1)
    x = self.fc1(x)
    x = torch.nn.functional.relu(x)
    x = self.dropout2(x)
    output = self.fc2(x)
    return output

model = Net().to(device)
optimizer = torch.optim.SGD(model.parameters(), lr = 0.01)
dl = torch.utils.data.DataLoader(mnist_dataset, batch_size = batch_size)

def f():
  i = 0
  for x, y in dl:
    optimizer.zero_grad()
    output = model(x.to(device=device))
    loss = torch.nn.functional.cross_entropy(output, y.to(device=device))
    loss.backward()
    optimizer.step()
    i = i+1
    if i > ir: break

if device=="cpu":
  fn = f
else:
  def fn():
    f()
    torch.cuda.synchronize()

ir = 1
fn()

ir = int(os.environ.get('ITER', "20"))

start_time = time.time()
fn()
print((time.time() - start_time))
