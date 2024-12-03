#include<stdio.h>
#include<stdlib.h>
#define N 100

__global__ void evenodd(int *d_arr, int *d_even, int *d_odd){
  
  __shared__ int shareddata[N/4];  

  int idx = blockIdx.x*blockDim.x+threadIdx.x;

  if(idx<N){
      shareddata[threadIdx.x] = d_arr[idx];
  }
  else{
     shareddata[threadIdx.x] = 0;
  }
  
  __syncthreads();

  if (threadIdx.x==0){
      int neven=0, nodd=0;
      for(int i=0; i<N/4; i++){
          if (shareddata[i]%2==0){
              neven++;
          }
          else{
              nodd++;
          }
      }
      d_even[blockIdx.x]=neven;
      d_odd[blockIdx.x]=nodd; 
  } 
  
}


int main(){

  int h_arr[N];
  for (int i=0; i<N; i++){
      h_arr[i] = i+1;  
  }

  int *d_arr, *d_even, *d_odd;
  
  cudaMalloc(&d_arr, N*sizeof(int));
  cudaMalloc(&d_even, N/25*sizeof(int));  
  cudaMalloc(&d_odd, N/25*sizeof(int));  

  cudaMemcpy(d_arr, h_arr, N*sizeof(int), cudaMemcpyHostToDevice);
  
  int threadperblock = 25;
  int blockpergrid = (N + threadperblock - 1)/threadperblock;

  evenodd<<<blockpergrid, threadperblock>>>(d_arr, d_even, d_odd);
  cudaDeviceSynchronize(); 
 

  int *h_even = (int *)malloc(N/25*sizeof(int));
  int *h_odd = (int *)malloc(N/25*sizeof(int));
  
  cudaMemcpy(h_even, d_even, N/25*sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(h_odd, d_odd, N/25*sizeof(int), cudaMemcpyDeviceToHost);

   
  printf("Even \n");
  for(int i=0;i<N/25;i++){
      printf("%d ",h_even[i]);
  } 
  printf("\n");


  printf("Odd \n");
  for(int i=0;i<N/25;i++){
      printf("%d ",h_odd[i]);
  } 
  printf("\n");
 



 
  int heven=0, hodd=0;
  for(int i=0;i<N/25;i++){
      heven += h_even[i];
      hodd += h_odd[i];
  } 

  printf("No. of even is: %d\n", heven);
  printf("No. of odd is: %d\n", hodd);

  cudaFree(d_arr);
  cudaFree(d_even);
  cudaFree(d_odd);

  free(h_even);
  free(h_odd);
  return 0;
}
