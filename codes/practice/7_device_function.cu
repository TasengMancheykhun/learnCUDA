#include <stdio.h>


__device__ int reduce_sum(int marks[])
{
  int sum=0;

  for (int i=0; i<3; i++){
      sum += marks[i];
  }
  
  return sum;
}


__global__ void sum(int *d_marks, int *total){
    int idx = blockIdx.x*blockDim.x + threadIdx.x;

    if (idx<5){
        int marks[3];
        for (int i=0;i<3;i++){
          marks[i] = d_marks[idx*3+i];
        }
        total[idx] = reduce_sum(marks);
    }
}


int main(){
  int marks[5][3] = {
                {55,60,70},
                {71,81,76},
                {74,65,64},
                {78,80,77},
                {72,75,67}
                };

  int *d_marks;
  int *total;
  int result[5];

  cudaMalloc(&d_marks, 5*3*sizeof(int));
  cudaMalloc(&total, 5*sizeof(int));
    
  cudaMemcpy(d_marks, marks, 5*3*sizeof(int), cudaMemcpyHostToDevice);

  sum<<<1,5>>>(d_marks, total);

  cudaMemcpy(result, total, 5*sizeof(int), cudaMemcpyDeviceToHost); 
  
  printf("Result: \n");
  for (int i=0; i<5; i++){
    printf("%d ",result[i]);
  }
  printf("\n");

  return 0;
}
