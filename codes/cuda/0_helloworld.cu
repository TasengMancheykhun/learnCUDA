#include <stdio.h>
#include <cuda_runtime.h>

__global__ void kernel(void){
    printf("Hello from GPU 1 !... \n");
    printf("Hello from GPU 2 !... \n");
    printf("Hello from GPU 3 !... \n");
    printf("Hello from GPU 4 !... \n");
    printf("Hello from GPU 5 !... \n");
    printf("Hello from GPU 6 !... \n");
}


int main(){
   kernel<<<1,1>>> ();
   printf("Hello from CPU 1 !... \n");
   printf("Hello from CPU 2 !... \n");
   printf("Hello from CPU 3 !... \n");
   printf("Hello from CPU 4 !... \n");
   printf("Hello from CPU 5 !... \n");
   printf("Hello from CPU 6 !... \n");


   return 0;

}
