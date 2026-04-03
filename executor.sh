echo $HOME

sudo apt update
sudo apt-get install libx11-6 -y
sudo apt-get install libgl1 -y
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b

/home/tiger/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
/home/tiger/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main

cd $HOME
git clone https://github.com/OrangeSodahub/sage.git

cd $HOME/sage/client
/home/tiger/miniconda3/bin/conda env update -f environment.yml
/home/tiger/miniconda3/bin/conda init
source /home/tiger/.bashrc
source /home/tiger/miniconda3/bin/activate simgen

cd $HOME
wget https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.2.0-rc.18%2Brelease.16044.3b2ed111.gl.linux-x86_64.release.zip
unzip isaac-sim-standalone@4.2.0-rc.18+release.16044.3b2ed111.gl.linux-x86_64.release.zip -d isaacsim
ln -s /home/tiger/sage/server/isaacsim/isaac.sim.mcp_extension /home/tiger/isaacsim/exts/isaac.sim.mcp_extension

cd $HOME/sage/client
bash isaac_sim_conda.sh
