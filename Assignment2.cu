
#include <iostream>
#include <math.h>
#include <vector>
#include <string>
#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cuda.h>
#include <cuda_runtime.h>


#include "jbutil.h"


using namespace std;




using namespace std;



//First Iteration function global fucntion

__global__ void firstIteration ( int*array, int rows, int columns,bool state){

       int blackPixCounter;



       for (int i = 0; i < rows; i++){
                  for (int j  = 0; j < columns; j++)  {



                    //If the pixel is black

                    if(array[i*columns+j] == 1){



                    //Black pixel counter
                       blackPixCounter=0;

                    ///Counting number of black neighbors



                    //If north is black, increase black neighbor pixel counter
                    if((i-1)>0){

                          if( array[(i-1)*columns+j] ==0){

                                  blackPixCounter++;
                            }

                    }

                    //If south is black,increase pixel neighbor counter
                    if((i+1)<rows){


                        if(array[(i+1)*columns+j] == 0){
                            blackPixCounter++;
                        }
                    }


                    //If east is black,increase pixel neighbor counter
                    if((j+1)<columns){


                         if (array[i*columns+(j+1)]==0){
                           blackPixCounter++;
                        }



                    }


                    //If west is black,increase pixel neighbor counter
                    if((j-1)>0){


                          if(array[i*columns+(j-1)]==0){

                             blackPixCounter++;
                          }

                      }


                    if( blackPixCounter > 2 && blackPixCounter <= 6){
                        state = true;

                    }



                    }


                  //Set element to 0 if condition holds
                        if(state){
                          array[i*columns+j] = 0;
                        }

                  state = false;

                  }


          }








}




//Second Iteration function global function

__global__ void secondIteration ( int*array, int rows, int columns,bool state){



         int blackPixCounter;



         for (int i = 0; i < rows; i++){
                    for (int j  = 0; j < columns; j++)  {



                      //If the pixel is black

                      if(array[i*columns+j] == 1){



                      //Black pixel counter
                         blackPixCounter=0;

                      ///Counting number of black neighbors



                      //If north is black, increase black neighbor pixel counter
                      if((i-1)>0){

                            if( array[(i-1)*columns+j] ==0){

                                    blackPixCounter++;
                              }

                      }

                      //If south is black,increase pixel neighbor counter
                      if((i+1)<rows){


                          if(array[(i+1)*columns+j] == 0){
                              blackPixCounter++;
                          }
                      }


                      //If east is black,increase pixel neighbor counter
                      if((j+1)<columns){


                           if (array[i*columns+(j+1)]==0){
                             blackPixCounter++;
                          }



                      }


                      //If west is black,increase pixel neighbor counter
                      if((j-1)>0){


                            if(array[i*columns+(j-1)]==0){

                               blackPixCounter++;
                            }

                        }


                      if( blackPixCounter >= 2 && blackPixCounter <= 6){
                          state = true;

                      }



                      }


                    //Set element to 0 if condition holds
                          if(state){
                            array[i*columns+j] = 0;
                          }

                    state = true;

                    }


            }






}
















//Executes Zhang Suen Thinning Algorithm on each pixel
int ZhangSuenThinningAlgorithm( int*array, int rows, int columns){

    cout <<" The Output is "<<endl;
    bool state = true;



    //First iteration


  // firstIteration(array,rows, columns, state);


   // Executing kernel
  firstIteration<<<1,1>>>(array, rows, columns, state);


    //Second iteration



    // Executing kernel
   secondIteration<<<1,1>>>(array, rows, columns, state);


//  secondIteration(array,rows, columns, state);





    return 0;

}


//vector<vector<int> > &array
int printRestults(int*array, int rows, int columns,string filename){


       ofstream myfile;
       myfile.open (filename+"Results");




       //Displaying pixel values
        for (int i = 0; i < rows; i++){
                for (int j  = 0; j < columns; j++)  {
                //   cout<< array[i][j]<<" ";
              //     myfile<< array[i][j]<<" ";

              //  arr1[rowCounter*columns+columnCounter]

                cout<< array[i*columns+j]<<" ";
                myfile<< array[i*columns+j]<<" ";


                }
                cout <<endl;
                myfile << endl;

        }

        myfile.close();
        return 0;
}


bool isZeroOrOne(string word){
    if( ! (word.compare("0") || word.compare("1"))){
        return false;
    }

    return true;
}



bool isDigit(const string s){
    return !s.empty() && std::all_of(s.begin(), s.end(), ::isdigit);

}




//Main Program
int main(int argc, char *argv[]){


        //Request file name to be passed
        if(argc < 2){
            cout << "Enter a filename and reload" <<endl;
            return 0;
        }


        //Read filename
        string Filename = argv[1];

        //Create a file read stream
        ifstream File (Filename);




        //Return error message if file could not be opened

        if(!File.is_open()){
            cout<<"File not found"<<endl;
            return 0;
        }


        //Read first line, which should contain number of rows and columns.
        string Line;
        getline (File,Line);


        //Read first string in line
        istringstream iss(Line);


        //Get number of rows
        string word;
        iss >> word;

        //Initialization of row and column variables
        size_t rows = 0;
        size_t columns = 0;


        //check validity of word
        if(!isDigit(word)){
            cout << "Row value is not a number"<<endl;
            return 0;
        }
        rows = stoi(word);



        //Get number of columns
        iss >> word;
        if(!isDigit(word)){
            cout << "Column value is not a number"<<endl;
            return 0;
        }
        columns = stoi(word);

      //  cout<<"number of columns:";
    //    cout<<columns<<endl;

    //    cout<<"number of Rows:";
    //    cout<<rows<<endl;

        //Initialization of vector of vectors to hold pixel values
       vector <vector <int> > arr(rows, vector<int>(columns));



       //Allocation of host memory
        int *arr1;

    //    int *d_rows;
    //    int *d_columns;


        //const int size = rows * columns * sizeof(int);
        arr1  = (int*)malloc(sizeof(int) * rows * columns);
      //  d_rows = (int*)malloc(sizeof(int));
      //  d_columns = (int*)malloc(sizeof(int));




        // Allocate device memory
        int *d_a;
        cudaMalloc((void**)&d_a, sizeof(int) * rows * columns);
    //    cudaMalloc((void**)&d_rows, sizeof(int));
    //    cudaMalloc((void**)&d_columns, sizeof(int));















        //Get remaining lines



          int columnCounter = 0;
          int rowCounter = 0;

        //while there are still more lines to read get words
        while(File.eof() != true){
            getline(File,Line);
            istringstream iss(Line);

                while(iss >> word){




                    //Return error message if a non digit is read

                  //  cout<<word;

                    if(!isZeroOrOne(word)){
                        cout<<"Invalid number detected in input"<<endl;
                        return 0;
                    }

                    //Convert to string and store value
                    arr[rowCounter][columnCounter] = stoi(word);

                    arr1[rowCounter*columns+columnCounter] = stoi(word);
                    columnCounter++;


                  }

            //       cout<<"columnCounter:"<<endl;
              //     cout<<columnCounter<<endl;

            //       cout<<"Moving to next Row"<<endl;
                    //Raise error if number of columns read does not match column number input
                    if(columnCounter != columns){
                        cout << " Column value does not match number of columns read"<<endl;
                       return 0;
                    }

                    //Reset Column counter
                    columnCounter = 0;


                    rowCounter++;


      }

           //Raise error if number of rows read does not match column number input
        if(rowCounter != rows ){
                cout << "Row value do noes not match number of rows read" <<endl;
                return 0;
        }




      // Transfer data from host to device memory
      cudaMemcpy(d_a, arr1, sizeof(int) * rows * columns, cudaMemcpyHostToDevice);


//Start Timer

double time = jbutil::gettime();

        //Applying thinning algorithm on each pixel value
       ZhangSuenThinningAlgorithm(arr1, rows, columns);






       // Transfer data back to host memory
       cudaMemcpy(arr1, d_a, sizeof(int), cudaMemcpyDeviceToHost);



           printf("PASSED\n");








//Stop timer

time = jbutil::gettime() - time;
       //Display results and store in file
       printRestults(arr1,rows, columns,Filename);

       cout<<"Time taken is:"<<time<<"s"<<endl;



       // Deallocate device memory
       cudaFree(d_a);

       // Deallocate host memory
       free(arr1);



       return 1;

}
