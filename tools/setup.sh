
# Create R libraries for each version that exists.
for version in $(Rscript -e "benchtorch:::required_r_versions()"); do
  mkdir -p "./RLIBS/$version"
  install_command=$(Rscript -e "benchtorch:::get_r_install_command('$version')")
  R_LIBS_USER="./RLIBS/$version" TORCH_INSTALL=1 Rscript \
      -e "install.packages(c('remotes', 'sessioninfo'))" \
      -e "$install_command" \
      -e "library(torch)" \
      -e "install.packages('torchvision')"
done

# Create python venvs
for version in $(Rscript -e "benchtorch:::required_py_versions()"); do
  python3 -m venv --copies "./PYENV/torch-v$version"
  "./PYENV/torch-v$version/bin/python" -m pip install -U torch==$version torchvision --extra-index-url https://download.pytorch.org/whl/cu113
done

# download and unzip image data
wget https://storage.googleapis.com/torch-datasets/cats-dogs.zip
unzip cats-dogs.zip
