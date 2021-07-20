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
	double sum = 0;
	for (double i = 1; i < iterations; ++i)
	{
		sum += (1 / (i * i));
	}
	return sqrt(sum * 6);
}

int main(int argc, char* argv[])
{
	cudaSetDevice(0);

	int maxHilos = printDevProp();

	printf("\t\t<<<<< CPU >>>>>\n");
	clock_t timer1 = clock();
	printf(" - The value of PI in CPU is: %.8lf\n", piCPU()); /*MAX DEC: 51*/
	timer1 = clock() - timer1;
	printf(" - Total CPU time: %f ms.\n", ((((double)timer1) / CLOCKS_PER_SEC) * 1000));
	printf("==================================================\n");

	system("pause");
	return 0;
}
