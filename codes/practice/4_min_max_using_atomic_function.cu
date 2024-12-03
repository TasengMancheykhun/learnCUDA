#include<stdio.h>
#include<cuda_runtime.h>
#define N 1000

__global__ void minmax(int *d_A, int *d_result_min, int *d_result_max)
{

    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx<N)
    {
        atomicMin(d_result_min, d_A[idx]);
        atomicMax(d_result_max, d_A[idx]);
    }
}


int main(){
  int h_A[N], h_result_min = 0, h_result_max = 0;

  // Initialize array
  for (int i = 0; i < N; i++)
  {
    h_A[i] = i+1;     // Array values: 1,2,3,....N
  }

  int *d_A, *d_result_min, *d_result_max;

  cudaMalloc(&d_A, N*sizeof(int));
  cudaMalloc(&d_result_min, sizeof(int));  
  cudaMalloc(&d_result_max, sizeof(int));

  cudaMemcpy(d_A, h_A, N*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_result_min, &h_A[0], sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_result_max, &h_A[0], sizeof(int), cudaMemcpyHostToDevice);

  int threadsperblock = 1024;
  int blockspergrid = (N + threadsperblock - 1)/threadsperblock;
  printf("t=%d, b=%d\n", threadsperblock, blockspergrid);

  minmax<<<blockspergrid, threadsperblock>>>(d_A, d_result_min, d_result_max);
  cudaDeviceSynchronize();

  cudaMemcpy(&h_result_min, d_result_min, sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(&h_result_max, d_result_max, sizeof(int), cudaMemcpyDeviceToHost);
  
  printf("Min is %d\n", h_result_min);
  printf("Max is %d\n", h_result_max);


  cudaFree(d_A);
  cudaFree(d_result_min);
  cudaFree(d_result_max);

  return 0;
}
