#include<stdio.h>

__global__ void addvar(int *a, int *b, int *c)
{
    *c = *a + *b;
}



int main()
{
  int h_a=5;
  int h_b=8;
  int h_c;

  int *d_a, *d_b, *d_c;

  cudaMalloc(&d_a, sizeof(int));
  cudaMalloc(&d_b, sizeof(int));
  cudaMalloc(&d_c, sizeof(int));
  
  cudaMemcpy(d_a, &h_a, sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, &h_b, sizeof(int), cudaMemcpyHostToDevice);

  addvar<<<1,1>>>(d_a, d_b, d_c);
  
  cudaMemcpy(&h_c, d_c, sizeof(int), cudaMemcpyDeviceToHost);
  
  printf("Ans: %d \n",h_c);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
  return 0;
}

/*

malloc ---

(int *) malloc(sizeof(int))

malloc dynamically allocates a block of memory with the specified size. It returns a pointer of type void which can be casted into a pointer of any form. This pointer points to the beginning of the block.   


cudaMalloc ---  

cudaMalloc(&d_a, sizeof(int))

cudaMalloc dynamically allocates a block of memory in the device memory. It returns a pointer that points to the allocated memory in the device.


cudaMemcpy ---

cudaMemcpy(d_a, &h_a, sizeof(int), cudaMemcpyHostToDevice)

cudaMemcpy copies sizeof(int) bytes of data from memory area pointed by pointer &h_a to memory area pointed by pointer d_b. 

*/

