#include <stdio.h>
#include <cuda.h>

__global__ void add_arrays(int *c, const int *a, const int *b, int size){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i<size){                                                                        // for handling the error of more threads than array elements
        c[i] = a[i] + b[i];
        printf("This thread has done processing... Thread is %d \n",i);
    }
    else{
         printf("This thread has NOT done processing... Thread is %d \n",i);
    }
}


int main()
{
   const int size = 5;
//   int a[size] = {1,2,3,4,5};
//   int b[size] = {1,2,3,4,5};

   int a[size], b[size];
   printf("Enter 5 elements for array 'a': \n");
   for(int i = 0; i < size; i++){
       scanf("%d",&a[i]);
   }

   printf("Enter 5 elements for array 'b': \n");
   for(int i = 0; i < size; i++){
       scanf("%d",&b[i]);
   }


   //Allocate memory on the device for array C
   int *d_c;
   cudaMalloc((void **)&d_c, size * sizeof(int));

   //Allocate memory on the device for array A and B
   int *d_a, *d_b;
   cudaMalloc((void **)&d_a, size * sizeof(int));
   cudaMalloc((void **)&d_b, size * sizeof(int));

   cudaMemcpy(d_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
   cudaMemcpy(d_b, b, size * sizeof(int), cudaMemcpyHostToDevice);

   // Launch the kernel with one block and size threads
//   add_arrays<<<1,5>>>(d_c, d_a, d_b, size);    // thread equal to number of array elements
//   add_arrays<<<1,3>>>(d_c, d_a, d_b, size);    // thread number less than number of array elements, no error
   add_arrays<<<1,8>>>(d_c, d_a, d_b, size);      // thread number larger than number of array elements, gives error


   // Add synchronization to ensure kernel execution completes
   cudaDeviceSynchronize();

   //copy the result back from the device to the host
   int *c = (int*)malloc(size * sizeof(int));

   cudaMemcpy(c, d_c, size * sizeof(int), cudaMemcpyDeviceToHost);

   //Print the result;
   for(int i = 0; i < size; i++)
   {
       printf("%d + %d = %d \n", a[i], b[i], c[i]);
   }

   //Free the memory on device
   cudaFree(c);
   cudaFree(d_a);
   cudaFree(d_b);
   cudaFree(d_c);

   return 0;
}


