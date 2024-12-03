#include<stdio.h>
#include<time.h>
#define N 4

__global__ void matrix_multiply(int *da, int *db, int *dc){
  
  int row = blockIdx.x*blockDim.x+threadIdx.x;
  int col = blockIdx.y*blockDim.y+threadIdx.y;


  if (row<N && col<N){
    dc[row*N + col] = 0;
    
    for (int k=0;k<N;k++){
        dc[row*N + col] += da[row*N+k]*db[k*N+col]; 
    }
  }
  
}


int main(){
  
  srand((unsigned int) time(NULL));

  int a[N][N], b[N][N], c[N][N];  
    
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
       a[i][j] = rand()%N;
       b[i][j] = rand()%N;
    }
  }  

  int *da, *db, *dc;  
 
  cudaMalloc(&da, N*N*sizeof(int));
  cudaMalloc(&db, N*N*sizeof(int));
  cudaMalloc(&dc, N*N*sizeof(int));
 

  cudaMemcpy(da, a, N*N*sizeof(int), cudaMemcpyHostToDevice);   
  cudaMemcpy(db, b, N*N*sizeof(int), cudaMemcpyHostToDevice);   

  
  int threadsperblockx = N;
  int threadsperblocky = N;

  dim3 threadsperblock(threadsperblockx, threadsperblocky, 1);

  int blockspergridx = (N + threadsperblockx - 1)/threadsperblockx;
  int blockspergridy = (N + threadsperblocky - 1)/threadsperblocky;

  dim3 blockspergrid(blockspergridx, blockspergridy, 1); 

  matrix_multiply<<<threadsperblock,blockspergrid>>>(da, db, dc);
     
  cudaMemcpy(c, dc, N*N*sizeof(int), cudaMemcpyDeviceToHost);


  printf("\n a: \n");
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
       printf("%d ",a[i][j]);
    }
    printf("\n");
  }  


  printf("\n b: \n");
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
       printf("%d ",b[i][j]);
    }
    printf("\n");
  }  


  printf("\n c: \n");
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
       printf("%d ",c[i][j]);
    }
    printf("\n");
  }  


  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  return 0;
}


