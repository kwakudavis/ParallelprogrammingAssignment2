
#include <iostream>
#include <math.h>
#include <vector>
#include <string>
#include <algorithm>
#include "jbutil.h"


using namespace std;


//Main Program



__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main(int argc, char *argv[]) {
    cuda_hello<<<1,1>>>();
    return 0;
}
