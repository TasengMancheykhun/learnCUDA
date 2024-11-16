# These are my notes for CUDA 
To practice CUDA, you can go to Google Collab and change runtime type to > Python3, Hardware accelerator T4 GPU




## Static global memory variables

* Create static variable using the qualifier __device__
* The unique thing about static variable is that it does not require a cudaMalloc(). The variable is accessible by both device function and host function.
* 
