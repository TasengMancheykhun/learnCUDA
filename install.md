* Reference
  * https://www.youtube.com/watch?v=8i3BiWa5AZ4
  * https://docs.nvidia.com/cuda/cuda-installation-guide-linux  

* My Machine configuration
  * Acer Predator Helios 300
  * NVIDIA GeForce RTX 3060

* Install CUDA in Ubuntu
  * Verify that your GPU is CUDA-capable
    * lspci | grep -i nvidia
  * Check which machine you have x86_64
    * uname -a
  * check gcc version
    * gcc --version

  * Go to https://developer.nvidia.com/cuda-downloads
    * Select--> LINUX > x86_64 > Ubuntu > 24.04 > deb(local)

    * Follow the Installation Instructions under `CUDA Toolkit Installer`
    * After installing, in directory `/usr/local/`, you must see cuda folders and files created

    * Also NVIDIA Driver installation under `Driver Installer`
      * Choose option: Install the legacy kernel module flavor
      * `sudo apt-get install -y cuda-drivers`

  * Add PATH in ~/.bashrc
    * export PATH=/usr/local/cuda-12.8/bin${PATH:+:${PATH}}
    * export LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} 

  * Check `nvcc --version`

  * Reboot for safety

  * Check `nvidia-smi`
    * In ACER laptop if this gives error, that 'it failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running'
    * Disable `Secure boot` 
