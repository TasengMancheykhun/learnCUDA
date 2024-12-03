/* 
Create an array containing 1024 elements
Initialize it with values 1 to 1024 on the host
In the kernel code, add values of all the array elements to calculate the sum of all the array elements

result = array[0] + array[1] + array[2] + ... array[1023]

In the host code, display the result
*/


#include <stdio.h>
#include <cuda_runtime.h>
#define N 1024

__global__ void atomicKernel(int *shared_counter, int *d_array)
{
  int idx = blockIdx.x*blockDim.x + threadIdx.x;

  if (idx < N)
      {
      atomicAdd(shared_counter, d_array[idx]);
      }
//  *shared_counter++;
}



int main()
{
    int h_array[N];
    int *d_array;
    int *d_result;
    int h_result;

    for (int i=0;i<N;i++)
    {
      h_array[i]=i+1;
    }

    cudaMalloc(&d_array, N*sizeof(int));
    cudaMemcpy(d_array, h_array, N*sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc(&d_result, sizeof(int));

    atomicKernel<<<1, 1024>>> (d_result, d_array);

    cudaDeviceSynchronize();

    cudaMemcpy(&h_result, d_result, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Final value: %d\n", h_result);

    cudaFree(d_array);
    cudaFree(d_result);

    return 0;
}
