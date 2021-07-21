//////////////////////////////////////////////////
//          Project 01 PI Calculation           //
//////////////////////////////////////////////////
// C++
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <cmath>
// CUDA C / C++
#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#include <cuda.h>

const double iterations = 90000000; /*MAX: 94906264*/

__host__ int printDevProp()
{
	cudaDeviceProp devProp;
	cudaGetDeviceProperties(&devProp, 0);
	printf("==================================================\n");
	printf(" >>>>>>> PI Calculation with CPU and GPU <<<<<<<\n");
	printf(" - Device Name: %s\n", devProp.name);
	printf(" - Maximum number of threads per block: %d\n", devProp.maxThreadsPerBlock);
	printf(" - Number of iterations: %.1lf\n", iterations);
	printf("==================================================\n");
	return devProp.maxThreadsPerBlock;
}

__host__ double piCPU()
{
	printf("\t\t<<<<< CPU >>>>>\n");
	double sum = 0;
	clock_t timer1 = clock();
	for (double i = 1; i < iterations; ++i)
	{
		sum += (1 / (i * i));
	}
	timer1 = clock() - timer1;
	double pi = sqrt(sum * 6);
	printf(" - The value of PI in CPU is: %.8lf\n", pi); /*MAX DEC: 51*/
	printf(" - Total CPU time: %f ms.\n", ((((double)timer1) / CLOCKS_PER_SEC) * 1000.0));
	printf("==================================================\n");
	return pi;
}

__host__ int printMenuOpt()
{
	int opt = ' ';
	printf(" - Write the number of the case you want to run:\n");
	printf("   1) Case01 - 1 Block with m Thread.\n");
	printf("   2) Case02 - x Blocks with 1 Thread each.\n");
	printf("   3) Case03 - x Blocks with m Threads each.\n");
	printf("   4) Case04 - x * y Blocks with 1 Thread each.\n");
	printf("   5) Case05 - 1 Block with m * n Threads each.\n");
	printf("   6) Case06 - x * y Blocks with m * n Threads each.\n");
	printf("> ");
	scanf("%d", &opt);
	return opt;
}

__global__ void sum01GPU01(double* arrayGPU, double iter)
{
	int tid = threadIdx.x;
	double segment = ((iter / 1024) * tid) + 1;
	for (double i = segment; i < (segment + (iter / 1024)) - 1; ++i)
	{
		arrayGPU[tid] = arrayGPU[tid] + (1 / (i * i));
	}
}

__global__ void sum02GPU01(double* arrayGPU, double* numpiGPUCPU)
{
	for (int i = 1; i < 1024; ++i)
	{
		arrayGPU[0] = arrayGPU[0] + arrayGPU[i];
	}
	numpiGPUCPU[0] = sqrt(arrayGPU[0] * 6);
}

__global__ void piGPU02()
{

}

__global__ void piGPU03()
{

}

__global__ void piGPU04()
{

}

__global__ void piGPU05()
{

}

__global__ void piGPU06()
{

}

__host__ void printStats(clock_t timer, dim3 dimGrid, dim3 dimBlock)
{
	printf(" - Total Threads: %d\n",
		dimGrid.x * dimGrid.y * dimGrid.z * dimBlock.x * dimBlock.y * dimBlock.z);
	printf(" - Configuracion de ejecucion: \n");
	printf("   + Grid [%d, %d, %d] Bloque [%d, %d, %d]\n",
		dimGrid.x, dimGrid.y, dimGrid.z, dimBlock.x, dimBlock.y, dimBlock.z);
}

int main(int argc, char* argv[])
{
	clock_t timer;
	dim3 dimGrid;
	dim3 dimBlock;
	cudaError_t cudaStatus;
	double* numpiCPUGPU[1];
	double* numpiGPUCPU;

	cudaFree(0);
	cudaSetDevice(0);

	int maxHilos = printDevProp();

	switch (printMenuOpt())
	{
	case 1: // Case01 - 1 Block with m Thread.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		double* arrayCPU[87891];
		double* arrayGPU;
		cudaMalloc((void**)&arrayGPU, (87891) * sizeof(double));
		cudaMalloc((void**)&numpiGPUCPU, 1 * sizeof(double));
		cudaMemset(arrayGPU, 0, (87891) * sizeof(double));
		cudaMemcpy(arrayGPU, arrayCPU, iterations * sizeof(double), cudaMemcpyHostToDevice);
		dimGrid = { 1 , 1 , 1 };
		dimBlock = { 1024 , 1 , 1 };
		timer = clock();
		sum01GPU01 << <dimGrid, dimBlock >> > (arrayGPU, iterations);
		cudaDeviceSynchronize();
		dimBlock = { 1 , 1 , 1 };
		cudaMemcpy(numpiGPUCPU, numpiCPUGPU, sizeof(double), cudaMemcpyHostToDevice);
		sum02GPU01 << <dimGrid, dimBlock >> > (arrayGPU, numpiGPUCPU);
		cudaDeviceSynchronize();
		dimBlock = { 1024 , 1 , 1 };
		timer = clock() - timer;
		cudaMemcpy(numpiCPUGPU, numpiGPUCPU, sizeof(double), cudaMemcpyDeviceToHost);
		printf(" - The value of PI in GPU is: %.8lf\n", numpiCPUGPU[0]); /*MAX DEC: 51*/
		printf(" - Total GPU time: %f ms.\n", ((((double)timer) / CLOCKS_PER_SEC) * 1000.0));
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		cudaFree(arrayGPU);
		break;
	case 2: // Case02 - x Blocks with 1 Thread each.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		dimGrid = { 1024 , 1 , 1 };
		dimBlock = { 1 , 1 , 1 };
		timer = clock();
		piGPU02 << <dimGrid, dimBlock >> > ();
		timer = clock() - timer;
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		break;
	case 3: // Case03 - x Blocks with m Threads each.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		dimGrid = { 1024 , 1 , 1 };
		dimBlock = { 1024 , 1 , 1 };
		timer = clock();
		piGPU03 << <dimGrid, dimBlock >> > ();
		timer = clock() - timer;
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		break;
	case 4: // Case04 - x * y Blocks with 1 Thread each.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		dimGrid = { 1024 , 1024 , 1 };
		dimBlock = { 1 , 1 , 1 };
		timer = clock();
		piGPU04 << <dimGrid, dimBlock >> > ();
		timer = clock() - timer;
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		break;
	case 5: // Case05 - 1 Block with m * n Threads each.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		dimGrid = { 1 , 1 , 1 };
		dimBlock = { 30 , 30 , 1 };
		timer = clock();
		piGPU05 << <dimGrid, dimBlock >> > ();
		timer = clock() - timer;
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		break;
	case 6: // Case06 - x * y Blocks with m * n Threads each.
		printf("==================================================\n");
		printf("\t\t<<<<< GPU >>>>>\n");
		dimGrid = { 1024 , 1024 , 1 };
		dimBlock = { 30 , 30 , 1 };
		timer = clock();
		piGPU06 << <dimGrid, dimBlock >> > ();
		timer = clock() - timer;
		printStats(timer, dimGrid, dimBlock);
		printf("==================================================\n");
		break;
	default:
		printf(">>> INVALID OPTION <<<\n");
		return 0;
		break;
	}

	double numpiCPU = piCPU();

	system("pause");
	return 0;
}
