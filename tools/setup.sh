
# Create R libraries for each version that exists.
for version in $(Rscript -e "benchtorch:::required_r_versions()"); do
  mkdir -p "./RLIBS/$version"
  install_command=$(Rscript -e "benchtorch:::get_r_install_command('$version')")
  R_LIBS_USER="./RLIBS/$version" TORCH_INSTALL=1 Rscript -e "install.packages('remotes')" -e "$install_command" -e "library(torch)"
done

# Create python venvs
for version in $(Rscript -e "benchtorch:::required_py_versions()"); do
  python -m venv "./PYENV/torch-v$version"
  "./PYENV/torch-v$version/bin/python" -m pip install -U torch==$version
done
