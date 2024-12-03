#include<stdio.h>


__global__ void varadd(int *a, int *b, int *c)
{
   *c=*a+*b;   

}


int main()
{
  int h_a=6;
  int h_b=9;
  int h_c;
  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, sizeof(int));
  cudaMalloc(&d_b, sizeof(int));
  cudaMalloc(&d_c, sizeof(int));
 
  cudaMemcpy(d_a, &h_a, sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, &h_b, sizeof(int), cudaMemcpyHostToDevice);

  varadd<<<1,1>>>(d_a, d_b, d_c);
    
  cudaMemcpy(&h_c, d_c, sizeof(int), cudaMemcpyDeviceToHost);    

  printf("Sum: %d",h_c);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  return 0;
}
