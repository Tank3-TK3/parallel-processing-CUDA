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
	printf("==================================================\n");
	printf(" Calculation of PI on CPU and GPU.\n");
	printf(" > Number of iterations: %.1lf\n", iterations);
	printf("==================================================\n");
	printf("\t\t<<<CPU>>>\n");
	clock_t timer1 = clock();
	printf("The value of PI in CPU is: %.8lf\n", piCPU()); /*MAX DEC: 51*/
	timer1 = clock() - timer1;
	printf("Total CPU time: %f ms.\n", ((((double)timer1) / CLOCKS_PER_SEC) * 1000));
	printf("==================================================\n");

	system("pause");
	return 0;
}
