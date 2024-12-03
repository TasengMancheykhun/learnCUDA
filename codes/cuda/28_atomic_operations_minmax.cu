/*
3) Find the minimum/maximum in an array without allowing for race conditions to occur:
   atomicMax(max_val, arr[idx]);
*/


#include <stdio.h>
#include <cuda_runtime.h>
#define N 1024

__global__ void atomicKernel(int *shared_counter_max, int *shared_counter_min, int *d_array)
{
    int idx = blockIdx.x*blockDim.x+threadIdx.x;
    
    if (idx < N)
        {
            atomicMax(shared_counter_max, d_array[idx]);
            
            atomicMin(shared_counter_min, d_array[idx]);            

            shared_counter_max++;
            shared_counter_min++;

        }
}


int main()
{
    int h_array[N];
    int *d_array;
    int *d_result_max;
    int *d_result_min;
    int h_result_max;
    int h_result_min;
    

    for (int i=0; i<N; i++)
    {
        h_array[i]=i+10;
    }

    cudaMalloc(&d_array, N*sizeof(int));
    cudaMemcpy(d_array, h_array, N*sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc(&d_result_max, sizeof(int));
    cudaMalloc(&d_result_min, sizeof(int));

    atomicKernel<<<1, 1024>>> (d_result_max, d_result_min, d_array);

    cudaDeviceSynchronize();

    cudaMemcpy(&h_result_max, d_result_max, sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(&h_result_min, d_result_min, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Max value: %d\n", h_result_max);
    printf("Min value: %d\n", h_result_min);

    cudaFree(d_array);
    cudaFree(d_result_max);
    cudaFree(d_result_min);

    return 0;
}
