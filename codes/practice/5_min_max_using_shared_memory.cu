#include<stdio.h>
#define N 48

// 8 blocks, with 6 threads each

__global__ void minmax(int *d_input, int *d_output_min, int *d_output_max){
  
    __shared__ int shareddata[N/6];
  
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
  
    if (idx<N)
    {
       shareddata[threadIdx.x] = d_input[idx];
    }
    else
    {
       shareddata[threadIdx.x] = 0;
    }    
  
    __syncthreads();
  
    if (threadIdx.x == 0){
       int min = shareddata[0];
       int max = shareddata[0];
       for (int i=0; i<blockDim.x; i++)
       {
          if (shareddata[i]<min)
               min = shareddata[i]; 
  
          if (shareddata[i]>max)
              max = shareddata[i];  
       }
       d_output_min[blockIdx.x] = min;
       d_output_max[blockIdx.x] = max;
    }

}



int main()
{
    int h_input[N];
    int *d_input, *d_output_min, *d_output_max;
    int h_output_min[N/6], h_output_max[N/6];
  
    for (int i=0; i<N; i++){
       h_input[i] = i+1;
    } 
  
    cudaMalloc(&d_input, N*sizeof(int));
    cudaMalloc(&d_output_min, N/6*sizeof(int));
    cudaMalloc(&d_output_max, N/6*sizeof(int));
  
    cudaMemcpy(d_input, h_input, N*sizeof(int), cudaMemcpyHostToDevice);
    
    int threadsperblock=6;
    int blockspergrid=(N+threadsperblock-1)/threadsperblock;
    
    minmax<<<blockspergrid, threadsperblock>>>(d_input, d_output_min, d_output_max);
    
    cudaDeviceSynchronize();
     
    cudaMemcpy(h_output_min, d_output_min, N/6*sizeof(int), cudaMemcpyDeviceToHost);  
    cudaMemcpy(h_output_max, d_output_max, N/6*sizeof(int), cudaMemcpyDeviceToHost);  
  
    int min = h_output_min[0];
    int max = h_output_max[0];
  
    for (int i=0; i<N/6; i++){
      if (h_output_min[i]<min){
          min = h_output_min[i];
      }
  
      if (h_output_max[i]>max){
          max = h_output_max[i];
      }     
    } 
    
    
    printf("Max value is %d \n",max);
    printf("Min value is %d \n",min);
  
    return 0;
}
