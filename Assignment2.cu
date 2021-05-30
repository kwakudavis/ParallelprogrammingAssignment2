
#include <iostream>
#include <math.h>
#include <vector>
#include <string>
#include <algorithm>
#include "jbutil.h"


using namespace std;


//Main Program



__global__ void cuda_hello(int argc, char *argv[]){
    printf("Hello World from GPU!\n");
}

int main() {
    cuda_hello<<<1,1>>>();
    return 0;
}
