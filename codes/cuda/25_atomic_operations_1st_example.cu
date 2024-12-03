#include <stdio.h>
#include <cuda_runtime.h>

__global__ void atomicKernel(int* shared_counter)
{
  // Each thread tries tp increment the shared shared_counter
  atomicAdd(shared_counter,1);
  *shared_counter++;
}

int main()
{
    int h_counter = 0;
    int* d_counter;

    cudaMalloc((void**)&d_counter, sizeof(int));
    cudaMemcpy(d_counter, &h_counter, sizeof(int), cudaMemcpyHostToDevice);

    atomicKernel<<<1, 1024>>> (d_counter);

    cudaDeviceSynchronize();

    cudaMemcpy(&h_counter, d_counter, sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_counter);

    printf("Final counter value: %d\n", h_counter);

    return 0;
}
