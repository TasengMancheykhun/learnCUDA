#include<stdio.h>
#include<stdlib.h>
#define N 10

__global__ void addarray(int *d_a, int *d_b, int *d_c){

  int idx = blockIdx.x*blockDim.x + threadIdx.x;

  if (idx<N){
    d_c[idx] = d_a[idx] + d_b[idx];
  }
}


int main(){
  
  int *d_a, *d_b, *d_c;

  cudaMallocManaged(&d_a, N*sizeof(int));
  cudaMallocManaged(&d_b, N*sizeof(int));
  cudaMallocManaged(&d_c, N*sizeof(int));
  
  for(int i=0;i<N;i++){
    d_a[i] = i+1;
    d_b[i] = i+2;
  } 

  printf("a: ");
  for(int i=0;i<N;i++){
    printf("%d ",d_a[i]);
  }
  printf("\n");

  printf("b: ");
  for(int i=0;i<N;i++){
    printf("%d ",d_b[i]);
  }
  printf("\n");


  int threadsperblock=32;
  int blockspergrid = (N+threadsperblock-1)/threadsperblock;
  addarray<<<blockspergrid,threadsperblock>>>(d_a, d_b, d_c);
  cudaDeviceSynchronize();  

  for(int i=0;i<N;i++){
      printf("%d ",d_c[i]);
  }  
  printf("\n");

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;
}
