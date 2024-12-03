#include<stdio.h>
#include<time.h>
#define N 16

int main(){
  int a[N];
  int b[N];

  srand((unsigned int) time (NULL));
  
  for(int i=0; i<N; i++){
    a[i] = i;        //rand()%N;
    b[i] = i+2;      //rand()%N;
  }


  printf("a: ");
  for(int i=0;i<N;i++){
    printf("%d ",a[i]);
  }
  printf("\n");

  printf("b: ");
  for(int i=0;i<N;i++){
    printf("%d ",b[i]);
  }
  printf("\n");

  return 0;
}
