#include<stdio.h>
#include<time.h>
#define N 16
   
__global__ void add(int *da, int *db, int *dc){
  
  int idx = blockIdx.x*blockDim.x+threadIdx.x;
  
  int stride = blockDim.x * gridDim.x;
  
  for(int i=idx; i<N; i+=stride){
    dc[i] = da[i] + db[i];
  }
 
}

int main(){

  int ha[N];
  int hb[N];
  int hc[N];

  int *da, *db, *dc;

  
  srand((unsigned int) time (NULL));

  for (int i=0; i<N; i++){
    ha[i] = rand()%N;
    hb[i] = rand()%N;
  }

  cudaMalloc(&da, N*sizeof(int));
  cudaMalloc(&db, N*sizeof(int));
  cudaMalloc(&dc, N*sizeof(int));


  cudaMemcpy(da, ha, N*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(db, hb, N*sizeof(int), cudaMemcpyHostToDevice);

  int threadsperblock = 4;
  int blockspergrid = (N+threadsperblock-1)/threadsperblock;

  add<<<blockspergrid,threadsperblock>>>(da, db, dc);
  
  cudaMemcpy(hc, dc, N*sizeof(int), cudaMemcpyDeviceToHost);


  printf("a: \n");
  for (int i=0; i<N; i++){
    printf("%d ",ha[i]);
  } 
  printf("\n");


  printf("b: \n");
  for (int i=0; i<N; i++){
    printf("%d ",hb[i]);
  } 
  printf("\n");



  printf("Result: \n");
  for (int i=0; i<N; i++){
    printf("%d ",hc[i]);
  } 
  printf("\n");

 
  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  return 0;
}


