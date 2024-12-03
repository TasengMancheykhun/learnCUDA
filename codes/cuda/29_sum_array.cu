// nvcc -std=c++11 -o exe 29_sum_array.cu




#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <chrono>


__global__ void sumArraysOnGPU(int *A, int *B, int *C, const int N){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid < N)
        C[tid] = A[tid] + B[tid];
}


void sumArraysOnHost(int *A, int *B, int *C, const int N){
    for (int idx=0; idx<N; idx++)
        C[idx] = A[idx] + B[idx];    
}


int main(){
   int N=1<<25;
//   int N=1000;
   
   printf("Vector size %d\n", N);

   size_t nBytes = N*sizeof(int);
   printf("nBytes = %zu \n", nBytes);

   int *h_A, *h_B, *h_C, *h_device_result;
   int *d_A, *d_B, *d_C;

   h_A = (int *) malloc(nBytes);
   h_B = (int *) malloc(nBytes);
   h_C = (int *) malloc(nBytes);

   h_device_result = (int *) malloc(nBytes);

   cudaMalloc((int **) &d_A, nBytes);
   cudaMalloc((int **) &d_B, nBytes);
   cudaMalloc((int **) &d_C, nBytes);

   for (int i=0; i<N; i++){
      h_A[i] = i+1;
      h_B[i] = i+1;
      h_C[i] = 0;
      h_device_result[i]=0;
   }

    // CPU addition

    auto start_time = std::chrono::high_resolution_clock::now();
    sumArraysOnHost(h_A, h_B, h_C, N);
    auto end_time = std::chrono::high_resolution_clock::now();

    auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds > (end_time - start_time).count();
    
    double seconds_cpu = duration_ns/1000000000.0;
    
    std::cout<<"Time taken by cpu : "<< seconds_cpu <<" seconds"<<std::endl;
    std::cout<<"Time taken by cpu : "<< duration_ns <<" nanoseconds"<<std::endl;
    
    int time_host = (int) duration_ns; 
    
    // transfer data from host to device
    cudaMemcpy(d_A, h_A, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, nBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_C, h_C, nBytes, cudaMemcpyHostToDevice);
    
    // GPU addition
    int threadsPerBlock = 1024;
    int blocksPerGrid = (N + threadsPerBlock -1)/threadsPerBlock;
    
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    
    cudaEventRecord(start);
    sumArraysOnGPU<<<blocksPerGrid,threadsPerBlock>>>(d_A, d_B, d_C, N);
    cudaEventRecord(stop);
   
    cudaEventSynchronize(stop);
 
    float milliseconds_device;

    cudaEventElapsedTime(&milliseconds_device, start, stop);


    long long nanoseconds_device = static_cast<long long>(milliseconds_device * 1e6);

    printf("\nTime taken by device (GPU): %lld nanoseconds\n", nanoseconds_device);
    
//  printf("Time taken by device(gpu):%.0f seconds\n",milliseconds_device/1000);
    
    //copy kernel result back to host side
    cudaMemcpy(h_device_result, d_C, nBytes,cudaMemcpyDeviceToHost);
 
    int time_device = (int) nanoseconds_device;    
   

    int diff = time_host-time_device;
 
    printf("Difference: %d nanoseconds \n",diff);

    float percent_gain=(float(diff)/float(time_host))*100;

    printf("Percent gain: %f % \n",percent_gain);


//    printf("Printing Result\n");    
//    for(int i=0;i<5;i++){
//    printf("i=%d,sum=%d\n",i,h_device_result[i]);
//    }
    
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    
    free(h_A);
    free(h_B);
    free(h_C);
    
    return 0;
    
}



