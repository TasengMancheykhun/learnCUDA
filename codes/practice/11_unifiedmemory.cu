#include<stdio.h>
#include<iostream>
#include<cuda_runtime.h>
#define N 32

__global__ void add(int *d_a,int *d_b,int *d_c){
  int idx = blockDim.x*blockIdx.x+threadIdx.x;

  if (idx<N){
    d_c[idx] = d_a[idx] + d_b[idx];
  }


}



int main(){

   int *d_a, *d_b, *d_c;

   cudaMallocManaged(&d_a, N*sizeof(int));
   cudaMallocManaged(&d_b, N*sizeof(int));
   cudaMallocManaged(&d_c, N*sizeof(int));
   
   for(int i=0; i<N; i++){
     d_a[i] = i+1;
     d_b[i] = i+1;
   }
   
   int threadsperblock = 8;
   int blockspergrid = (N+threadsperblock-1)/threadsperblock;
   
   add<<<blockspergrid,threadsperblock>>>(d_a, d_b, d_c);
   cudaDeviceSynchronize();

   printf("Result: \n");
   for(int i=0; i<N; i++){
       printf("%d ",d_c[i]);
   }
   printf("\n");

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;
}

