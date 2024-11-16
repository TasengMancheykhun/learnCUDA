# These are my notes for CUDA 
Basic idea of CUDA is that, using CUDA, we can send a time consuming portion of our code in CPU to the GPU, so that this portion of the calculation will utilize the parallelization capability of the GPU. After the calculation, we will copy back the result from the GPU to our CPU.  

## Pre requisite: </br>

HARDWARE:</br> 
If you have Nvidia's GPU in your system, install `nvcc`, the CUDA compiler. If not, to practice CUDA, you can go to Google Collab and utilise T4 GPU for free by going to `change runtime type`, `Hardware accelerator` : `T4 GPU` </br>
</br>
Note that usage of this T4 GPU in Google Collab is limited. It can only be used for small calculations. If it is ON for too long without usage, Google will STOP your usage of this GPU for some hours.</br>

PROGRAMMING: </br>
C: functions, pointers


## Basics
A GPU as a whole is referred as a Grid.

![screenshot](screenshot.png)



A simple c program to print `Hello World!`<br/>
Since I am writing the code in google collab. So, putting `%%writefile filename` at the top of a cell in Google Colab will write the contents of that cell to a specified filename.
```
%%writefile hello.c

#include <stdio.h>

int main(){
   printf("Hello World! \n");
   return 0;
}
```

Compile in google collab using (`!` mark is needed) 
```
! gcc -o exe hello.c
! ./exe
```

Now, lets change this to a CUDA program. CUDA programs have extensions `.cu` </br> 
CPU is referred as Host and GPU is referred as Device. </br>
When someone says device function, they are referring to the function written to run in GPU.  

```
%%writefile prog.cu

#include <stdio.h>
#include <cuda_runtime.h>

__global__ void print_text(){                   
    printf("Hello from GPU! \n");
}


__host__ int main(){

   print_text<<<1,1>>>();             // calling the GPU function from the Host

   printf("Hello from CPU! \n");
   return 0;
}
```
Compile in google collab using 
```
! nvcc -o exe prog.cu
! ./exe
```

Explanation:
* `__global__`, `__host__` are called qualifiers.
* `__global__` qualifier denotes that the function after `__global__` is written for the GPU. The calculation inside this function will be done in the GPU
* Here, we are printing out `Hello from GPU!` from the GPU
* `print_text()` is a function, just how you make a function in C. Here, it is a device function.
* `__host__` qualifier denotes that the function after `__host__` will run in the CPU. It contains the main function of the usual C program.
* In the `main()` function, we call the `print_text` device function using `<<<gridDim,blockDim>>>`
* `gridDim` = Number of blocks in the GPU. `blockDim` = Number of threads in a block.
*     



<!---

## Static global memory variables

* Create static variable using the qualifier __device__
* The unique thing about static variable is that it does not require a cudaMalloc(). The variable is accessible by both device function and host function.
--->
