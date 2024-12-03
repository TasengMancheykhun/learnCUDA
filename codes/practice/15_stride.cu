#include<stdio.h>
#include<time.h>
#define N 16


__global__ void add(int *da, int *db, int *dc){
  
  int idx = blockIdx.x*blockDim.x+threadIdx.x;
  int stride = blockDim.x*gridDim.x;  

  if (idx<N){
     for (int i=idx; i<N; i+=stride){
     dc[i] = da[i]+db[i];
     }
  }
}


int main(){
  
  int a[N];
  int b[N];
  int c[N];

  srand((unsigned int) time (NULL));

  for (int i=0;i<N;i++){
    a[i] = rand()%N;
    b[i] = rand()%N;
  }

  printf("a: \n");
  for (int i=0; i<N; i++){
    printf("%d ",a[i]);
  } 
  printf("\n"); 

  printf("b: \n");
  for (int i=0; i<N; i++){
    printf("%d ",b[i]);
  }  
  printf("\n"); 

  
  int *da, *db, *dc;

  cudaMalloc(&da,N*sizeof(int));
  cudaMalloc(&db,N*sizeof(int));
  cudaMalloc(&dc,N*sizeof(int));

  cudaMemcpy(da,a,N*sizeof(int),cudaMemcpyHostToDevice);
  cudaMemcpy(db,b,N*sizeof(int),cudaMemcpyHostToDevice);

  int threadsperblock = 4; 
  int blockspergrid = (N+threadsperblock-1)/threadsperblock;

  add<<<threadsperblock, blockspergrid>>>(da, db, dc);   
  cudaDeviceSynchronize();

  cudaMemcpy(c,dc,N*sizeof(int),cudaMemcpyDeviceToHost); 

  printf("c: \n");
  for (int i=0; i<N; i++){
    printf("%d ",c[i]);
  }  
  printf("\n"); 

  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  return 0;
}
