//////////////////////////////////////////////////
//           Program 05 Hello World             //
//////////////////////////////////////////////////
#include <cstdio>
#include <ctime>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__device__ void printInfo( int tid )
{
	printf("\t< I'm the thread (%d , %d , %d) of the block (%d , %d , %d) # %d\n" ,
	threadIdx.x , threadIdx.y , threadIdx.z , blockIdx.x , blockIdx.y , blockIdx.z , tid );
}

__global__ void case01()
{
	int tid = threadIdx.x;
	printInfo( tid );
}

__global__ void case02()
{
	int tid = blockIdx.x;
	printInfo( tid );
}

__global__ void case03()
{
	int tid = ( blockIdx.x * blockDim.x ) + threadIdx.x;
	printInfo( tid );
}

__global__ void case04()
{
	int tid = ( blockIdx.x * gridDim.y ) + blockIdx.y;
	printInfo( tid );
}

__global__ void case05()
{
	int tid = ( threadIdx.x * blockDim.y ) + threadIdx.y;
	printInfo( tid );
}

__global__ void case06()
{
	int numHilo = ( threadIdx.x * blockDim.y ) + threadIdx.y;
	int tid = ( blockIdx.x * blockDim.x * blockDim.y ) + numHilo;
	printInfo( tid );
}

__global__ void case07()
{
	int numBloque = ( blockIdx.x * gridDim.y ) + blockIdx.y;
	int tid = ( numBloque * blockDim.x ) + threadIdx.x;
	printInfo( tid );
}

__global__ void case08()
{
	int numBloque = ( blockIdx.x * gridDim.y ) + blockIdx.y;
	int numHilo = ( threadIdx.x * blockDim.y ) + threadIdx.y;
	int tid = ( numBloque * blockDim.x * blockDim.y ) + numHilo;
	printInfo( tid );
}

__global__ void case09()
{
	int numBloque = ( blockIdx.x * gridDim.y * gridDim.z ) + ( blockIdx.y * gridDim.z ) + blockIdx.z;
	int tid = numBloque + threadIdx.x;
	printInfo( tid );
}

__global__ void case10()
{
	int numBloque = ( blockIdx.x * gridDim.y * gridDim.z )  + ( blockIdx.y * gridDim.z ) + blockIdx.z;
	int tid = ( numBloque * blockDim.x ) + threadIdx.x;
	printInfo( tid );
}

__global__ void case11()
{
	int numBloque = ( blockIdx.x * gridDim.y * gridDim.z ) + ( blockIdx.y * gridDim.z ) + blockIdx.z;
	int numHilo = ( threadIdx.x * blockDim.y ) + threadIdx.y;
	int tid = ( numBloque * blockDim.x * blockDim.y ) + numHilo;
	printInfo( tid );
}

__global__ void case12()
{
	int numBloque = ( blockIdx.x * gridDim.y * gridDim.z ) + ( blockIdx.y * gridDim.z ) + blockIdx.z;
	int numHilo = ( threadIdx.x * blockDim.y * blockDim.z ) + ( threadIdx.y * blockDim.z ) + threadIdx.z;
	int tid = ( numBloque * blockDim.x * blockDim.y * blockDim.z ) + numHilo;
	printInfo( tid );
}

__host__ void printStats( clock_t timer , dim3 dimGrid , dim3 dimBlock )
{
	printf( "> The operation on the device took: %.3f ms.\n\n" , 
		( ( ( float ) timer ) / CLOCKS_PER_SEC ) * 1000 );
	cudaDeviceSynchronize(); // Synchronize the GPU preventing premature termination
	printf( "\n- Total Threads: %d\n" , 
		dimGrid.x * dimGrid.y * dimGrid.z * dimBlock.x * dimBlock.y * dimBlock.z );
	printf( "- Configuracion de ejecucion: \n");
	printf( "\t+ Grid [%d, %d, %d] Bloque [%d, %d, %d]\n", 
		dimGrid.x, dimGrid.y, dimGrid.z, dimBlock.x, dimBlock.y, dimBlock.z);
}

__host__ int printMenuOpt()
{
	int opt = ' ';
	printf( "##################################################\n" );
	printf( "+ Write the number of the case you want to run:\n" );
	printf( "\t1) Case01 - 1 Block with 1 Thread.\n" );
	printf( "\t2) Case02 - n Blocks with 1 Thread each.\n" );
	printf( "\t3) Case03 - n Blocks with m Threads each.\n" );
	printf( "\t4) Case04 - n * m Blocks with 1 Thread each.\n" );
	printf( "\t5) Case05 - 1 Block with n * m Threads each.\n" );
	printf( "\t6) Case06 - n Blocks with m * r Threads each.\n" );
	printf( "\t7) Case07 - n * m Blocks with r Threads each.\n" );
	printf( "\t8) Case08 - n * m Blocks with r * s Threads each.\n" );
	printf( "\t9) Case09 - n * m * r Blocks with 1 Thread each.\n" );
	printf( "\t10) Case10 - n * m * r Blocks with p Threads each.\n" );
	printf( "\t11) Case11 - n * m * r Blocks with p * s Threads each.\n" );
	printf( "\t12) Case 12 - n * m * r Blocks with p * s * t Threads each.\n" );
	printf("> ");
	scanf( "%d" , &opt );
	return opt;
}

int main( int argc , char* argv[] )
{
	clock_t timer;
	dim3 dimGrid;
	dim3 dimBlock;

	// set the ID of the CUDA device
	cudaSetDevice( 0 );
	
	switch ( printMenuOpt() )
	{
		case 1: // Case01 - 1 Block with 1 Thread.
				printf( "##################################################\n" );
				dimGrid = { 1 , 1 , 1 };
				dimBlock = { 1 , 1 , 1 };
				timer = clock();
				case01 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 2: // Case02 - n Blocks with 1 Thread each.
				printf( "##################################################\n" );
				dimGrid = { 20 , 1 , 1 };
				dimBlock = { 1 , 1 , 1 };
				timer = clock();
				case02 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 3: // Case03 - n Blocks with m Threads each.
				printf( "##################################################\n" );
				dimGrid = { 5 , 1 , 1 };
				dimBlock = { 4 , 1 , 1 };
				timer = clock();
				case03 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 4: // Case04 - n * m Blocks with 1 Thread each.
				printf( "##################################################\n" );
				dimGrid = { 4 , 5 , 1 };
				dimBlock = { 1 , 1 , 1 };
				timer = clock();
				case04 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 5: // Case05 - 1 Block with n * m Threads each.
				printf( "##################################################\n" );
				dimGrid = { 1 , 1 , 1 };
				dimBlock = { 4 , 5 , 1 };
				timer = clock();
				case05 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 6: // Case06 - n Blocks with m * r Threads each.
				printf( "##################################################\n" );
				dimGrid = { 5 , 1 , 1 };
				dimBlock = { 3 , 2 , 1 };
				timer = clock();
				case06 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 7: // Case07 - n * m Blocks with r Threads each.
				printf( "##################################################\n" );
				dimGrid = { 3 , 2 , 1 };
				dimBlock = { 4 , 1 , 1 };
				timer = clock();
				case07 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 8: // Case08 - n * m Blocks with r * s Threads each.
				printf( "##################################################\n" );
				dimGrid = { 3 , 3 , 1 };
				dimBlock = { 2 , 2 , 1 };
				timer = clock();
				case08 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 9: // Case09 - n * m * r Blocks with 1 Thread each.
				printf( "##################################################\n" );
				dimGrid = { 2 , 3 , 4 };
				dimBlock = { 1 , 1 , 1 };
				timer = clock();
				case09 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 10: // Case10 - n * m * r Blocks with p Threads each.
				printf( "##################################################\n" );
				dimGrid = { 2 , 3 , 4 };
				dimBlock = { 3 , 1 , 1 };
				timer = clock();
				case10 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 11: // Case11 - n * m * r Blocks with p * s Threads each.
				printf( "##################################################\n" );
				dimGrid = { 2 , 3 , 4 };
				dimBlock = { 2 , 3 , 1 };
				timer = clock();
				case11 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		case 12: // Case12 - n * m * r Blocks with p * s * t Threads each.
				printf( "##################################################\n" );
				dimGrid = { 2 , 3 , 4 };
				dimBlock = { 2 , 2 , 3 };
				timer = clock();
				case12 <<< dimGrid , dimBlock >>>();
				timer = clock() - timer;
				printStats( timer , dimGrid , dimBlock );
				printf( "##################################################\n" );
			break;
		default:
				printf(">>> INVALID OPTION <<<\n");
				return 0;
			break;
	}
	
	system( "pause" );
	return 0;
}
