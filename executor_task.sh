
echo $HOME
echo $PWD

# landing path is /opt/tiger/sage-host
sudo apt update
sudo apt-get install libx11-6 -y
sudo apt-get install libgl1 -y
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b  # will be installed to /home/tiger/miniconda3

/home/tiger/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
/home/tiger/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main

cd ./client
/home/tiger/miniconda3/bin/conda env create -f environment.yml
/home/tiger/miniconda3/bin/conda init
source $HOME/.bashrc
source $HOME/miniconda3/bin/activate simgen

cd ../
wget https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.2.0-rc.18%2Brelease.16044.3b2ed111.gl.linux-x86_64.release.zip
unzip isaac-sim-standalone@4.2.0-rc.18+release.16044.3b2ed111.gl.linux-x86_64.release.zip -d isaacsim
ln -s /opt/tiger/sage-host/server/isaacsim/isaac.sim.mcp_extension /opt/tiger/sage-host/isaacsim/exts/isaac.sim.mcp_extension

bash client/isaac_sim_conda.sh
