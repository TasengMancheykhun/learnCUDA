#include<stdio.h>
#define N 5

__global__ void varadd(int *a, int *b, int *c)
{
   int idx = blockIdx.x*blockDim.x+threadIdx.x;

   if (idx < N)
       c[idx] = a[idx] + b[idx];   

}


int main()
{
  int h_a[N]={1,2,3,4,5};
  int h_b[N]={5,4,3,2,1};
  int h_c[N];

  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, N*sizeof(int));
  cudaMalloc(&d_b, N*sizeof(int));
  cudaMalloc(&d_c, N*sizeof(int));
 
  cudaMemcpy(d_a, &h_a, N*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, &h_b, N*sizeof(int), cudaMemcpyHostToDevice);

  varadd<<<1,5>>>(d_a, d_b, d_c);
    
  cudaMemcpy(&h_c, d_c, N*sizeof(int), cudaMemcpyDeviceToHost);    

  for (int i=0;i<N;i++)
  {
    printf("%d ",h_c[i]);
  }
  printf("\n"); 
 
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;
}
