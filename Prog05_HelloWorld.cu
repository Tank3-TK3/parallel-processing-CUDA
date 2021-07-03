//////////////////////////////////////////////////
//           Program 05 Hello World             //
//////////////////////////////////////////////////
#include <stdio.h>
#include <time.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <iostream>

using namespace std;

__global__ void hello_kernel()
{
	// Caso 1
	int tid = threadIdx.x;

	// Caso 2
	//int tid = blockIdx.x;

	// Caso 3
	//int tid = (blockIdx.x*blockDim.x)+threadIdx.x;

	// Caso 4
	//int numBloque = (blockIdx.x * gridDim.y) + blockIdx.y;
	//int tid = numBloque;

	// Caso 5
	//int numHilo = (threadIdx.x * blockDim.y) + threadIdx.y;
	//int tid = numHilo;

	// Caso 6
	//int numBloque = blockIdx.x;
	//int numHilo = (threadIdx.x * blockDim.y) + threadIdx.y;
	//int tid = (numBloque * blockDim.x * blockDim.y) + numHilo;

	// Caso 7
	//int numBloque = (blockIdx.x*gridDim.y)+blockIdx.y;
	//int numHilo =threadIdx.x;
	//int tid = (numBloque * blockDim.x) + numHilo;

	// Caso 8
	//int numBloque = (blockIdx.x*gridDim.y) + blockIdx.y;
	//int numHilo = (threadIdx.x * blockDim.y) + threadIdx.y;
	//int tid = (numBloque * blockDim.x * blockDim.y) + numHilo;

	// Caso 9
	//int numBloque = (blockIdx.x*gridDim.y*gridDim.z) + 
	//				(blockIdx.y*gridDim.z)+
	//				 blockIdx.z;
	//int numHilo = threadIdx.x;
	//int tid = numBloque + numHilo;

	// Caso 10
	//int numBloque = (blockIdx.x*gridDim.y*gridDim.z) +
	//	(blockIdx.y*gridDim.z) +
	//	blockIdx.z;
	//int numHilo = threadIdx.x;
	//int tid = (numBloque*blockDim.x) + numHilo;

	// Caso 11
	//int numBloque = (blockIdx.x*gridDim.y*gridDim.z) +
	//	(blockIdx.y*gridDim.z) +
	//	blockIdx.z;
	//int numHilo = (threadIdx.x * blockDim.y) + threadIdx.y;
	//int tid = (numBloque * blockDim.x * blockDim.y) 
	//	+ numHilo;

	// Caso 12
	// int numBloque = (blockIdx.x * gridDim.y * gridDim.z) +
	//     (blockIdx.y * gridDim.z) +
	//     blockIdx.z;
	// int numHilo = (threadIdx.x * blockDim.y * blockDim.z) +
	//     (threadIdx.y * blockDim.z) +
	//     threadIdx.z;
	// int tid = (numBloque * blockDim.x * blockDim.y * blockDim.z)
	//     + numHilo;

	// print a greeting message
	printf("Soy el hilo (%2d, %2d, %2d) del bloque (%2d, %2d, %2d) # %2d\n", threadIdx.x, threadIdx.y, threadIdx.z, blockIdx.x, blockIdx.y, blockIdx.z, tid);
	//printf("Hello from thread %d!\n", tid);
}

int main( int argc , char* argv[] )
{
	// Saludos desde el Host
	cout << "##################################################\n";
	cout << "\tHello, world from the host (CPU)!\n";
	cout << "##################################################\n";

	// set the ID of the CUDA device
	cudaSetDevice( 0 );

	// Caso 1 - 1 Bloque con 1 Hilo
	dim3 dimGrid(1);
	dim3 dimBlock(1);

	// Caso 2 - n Bloques con 1 Hilo c/u
	//dim3 dimGrid(20);
	//dim3 dimBlock(1);

	// Caso 3 - n Bloques con m Hilos c/u
	//dim3 dimGrid(5);
	//dim3 dimBlock(4);

	// Caso 4 - n x m Bloques con 1 Hilo c/u
	//dim3 dimGrid(4,5);
	//dim3 dimBlock(1);

	// Caso 5 - 1 Bloque con n x m Hilos c/u
	//dim3 dimGrid(1);
	//dim3 dimBlock(4,5);

	// Caso 6 - n Bloques con m x r Hilos c/u
	//dim3 dimGrid(5);
	//dim3 dimBlock(3, 2);

	// Caso 7 - n x m Bloques con r Hilos c/u
	//dim3 dimGrid(3, 2);
	//dim3 dimBlock(4);

	// Caso 8 - n x m Bloques con r x s Hilos c/u
	//dim3 dimGrid(3, 3);
	//dim3 dimBlock(2, 2);

	// Caso 9 - n x m x r Bloques con 1 Hilo c/u
	//dim3 dimGrid(2, 3, 4);
	//dim3 dimBlock(1);

	// Caso 10 - n x m x r Bloques con p Hilos c/u
	//dim3 dimGrid(2, 3, 4);
	//dim3 dimBlock(3);

	// Caso 11 - n x m x r Bloques con p x s Hilos c/u
	//dim3 dimGrid(2, 3, 4);
	//dim3 dimBlock(2, 3);

	// Caso 12 - n x m x r Bloques con p x s x t Hilos c/u
	// dim3 dimGrid(2, 3, 4);
	// dim3 dimBlock(2, 2, 3);

	clock_t timer1 = clock();
	// invoke kernel using 4 threads executed in 1 thread block
	hello_kernel << < dimGrid, dimBlock >> > ();

	timer1 = clock() - timer1;
	printf("Operacion en Device toma %10.3f ms.\n", (((float)timer1) / CLOCKS_PER_SEC) * 1000);

	// synchronize the GPU preventing premature termination
	cudaDeviceSynchronize();

	printf("\n");
	printf("Hilos totales: %d\n", dimGrid.x * dimGrid.y * dimGrid.z * dimBlock.x * dimBlock.y * dimBlock.z);

	printf("\n");
	printf("Configuracion de ejecucion: \n");
	printf("Grid [%d, %d, %d] Bloque [%d, %d, %d]\n", dimGrid.x, dimGrid.y, dimGrid.z, dimBlock.x, dimBlock.y, dimBlock.z);

	system( "pause" );
	return 0;
}
