#include<stdio.h>
#define N 16 


int main(){

  int a[N], b[N], c[N];

  for (int i=0;i<N;i++){
    a[i] = i;
    b[i] = i+1;
  }


  printf("a: \n");
  for (int i=0; i<N; i++){
    printf("%d ", a[i]);
  }
  printf("\n");


  printf("b: \n");
  for (int i=0; i<N; i++){
    printf("%d ", b[i]);
  }
  printf("\n");


  #pragma acc data copyin(a[0:N]) copyin(b[0:N]) copyout(c[0:N])
  {
    #pragma acc parallel loop vector
    for (int i=0; i<N; i++){
      c[i] = a[i] + b[i];
    }
  }

  printf("c: \n");
  for (int i=0; i<N; i++){
    printf("%d ", c[i]);
  }
  printf("\n");

  return 0;
}
