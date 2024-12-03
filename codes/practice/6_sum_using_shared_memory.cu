#include<stdio.h>
#define N 48

__global__ void sum(int *d_input, int *d_output){
  
  int idx = blockIdx.x*blockDim.x + threadIdx.x;

  __shared__ int shareddata[N/8];

  if (idx < N)
  {
     shareddata[threadIdx.x] = d_input[idx]; 
  }
  else
  {
     shareddata[threadIdx.x] = 0;
  }

  __syncthreads();

  if (threadIdx.x == 0)
  {
     int sum=0;
     for (int i=0;i<blockDim.x;i++)
     {
         sum+=shareddata[i];
     }
     d_output[blockIdx.x] = sum;
  }

}


int main()
{
  int h_input[N];
  
  for(int i=0; i<N; i++){
     h_input[i] = i+1;
  }  
  
  cudaMalloc(&d_input, N*sizeof(int));
  cudaMalloc(&d_output, N/6*sizeof(int));
  cudaMemcpy(d_input, h_input, N*sizeof(int), cudaMemcpyHostToDevice);

  int threadsperblock = 8;
  int blockspergrid = (N + threadsperblock - 1)/threadsperblock;
  
  sum<<<blockspergrid, threadsperblock>>>(d_input,d_output);
  
  cudaMemcpy(h_output, d_output, N/6*sizeof(int), cudaMemcpyDeviceToHost);
  
      
  
 
  return 0;
}
