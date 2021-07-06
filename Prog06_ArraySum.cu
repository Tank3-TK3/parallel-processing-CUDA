// suma de vectores
// Caso 1 length bloques con 1 hilo c/u  -- Maximo 63000
// Caso 2 1,length bloque con 1 hilo c/u -- Maximo 63000
// Restringido por numero maximo de hilos x bloque
// Caso 3 1 bloque con length hilos c/u  -- Maximo 1024
// Caso 4 length/1024 bloques con 1024 hilos c/u
// Caso 5 Maximizar el num de hilos por bloque cercano a 1024
// Caso 6 length/(1024 x ElemxHilo) bloques con 1024 hilos c/u
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////
//            Program 06 Array Sum              //
//////////////////////////////////////////////////

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <cstdio>
#include <iostream>
#include <cstdlib>
#include <ctime>

#define length 100 //63000
#define epsilon float(0.0000001)
#define elemxHilo 5 // caso 6

__global__ void add(float *a, float *b, float *c) {

	// Caso 1
	//int tid = blockIdx.x;  
	//c[tid] = a[tid] + b[tid];

	// Caso 2
	//int tid = blockIdx.y;
	//c[tid] = a[tid] + b[tid];

	// Caso 3
	//int tid = threadIdx.x;
	//c[tid] = a[tid] + b[tid];

	// Caso 4 y 5
	//int tid = (blockIdx.x*blockDim.x)+ threadIdx.x; 
	//if (tid < length) 
	//	c[tid] = a[tid] + b[tid];  

	// Caso 6
	//int tid = (blockIdx.x*blockDim.x*elemxHilo) +
	//	(threadIdx.x*elemxHilo);
	int tid = ((blockIdx.x*blockDim.x) + threadIdx.x) *
		elemxHilo;
	for (int i = 0; i < elemxHilo; i++) {
		if ((tid + i) < length)
			c[tid + i] = a[tid + i] + b[tid + i];
	}
}

float comparar(float *var1, float *var2, int *numDifer) {
	float diferencia = 0;
	float difActual = 0;
	int cont = 0;
	for (int i = 0; i < length; i++) {
		difActual = abs(var1[i] - var2[i]);
		diferencia += difActual;
		if (difActual>epsilon)
			cont++;
	}
	*numDifer = cont;
	return diferencia;
}

void imprimir(float *var1, float *var2,
	float *result1, float *result2) {
	//display results
	for (int i = 0; i<length; i++) {
		printf("%5d. %10.3f + %10.3f = CPU %10.3f   GPU %10.3f\n",
			i + 1, var1[i], var2[i], result1[i], result2[i]);
	}
}

int divEntera(int n, int m) {
	int valor = 0;
	if ((n%m) == 0)
		valor = n / m;
	else
		valor = (n / m) + 1;
	return valor;
}

void addCPU(float *a, float *b, float *c) {
	for (int i = 0; i<length; i++) {
		c[i] = a[i] + b[i];
	}
}

int main(void) {
	float a[length], b[length], gpu_c[length];
	float cpu_c[length];
	float *dev_a, *dev_b, *dev_c;

	memset(gpu_c, 0, length * sizeof(float));
	memset(cpu_c, 0, length * sizeof(float));

	cudaSetDevice(0);

	// Obtiene las propiedades de la primer tarjeta
	cudaDeviceProp devProp;
	cudaGetDeviceProperties(&devProp, 0);
	int maxHilos = devProp.maxThreadsPerBlock;

	printf("Propiedad de la tarjeta de video\n");
	printf("Hilos maximos por bloque: %d\n", maxHilos);
	printf("======================================================================\n");

	// allocate memory - GPU
	cudaMalloc((void**)&dev_a, length * sizeof(float));
	cudaMalloc((void**)&dev_b, length * sizeof(float));
	cudaMalloc((void**)&dev_c, length * sizeof(float));
	cudaMemset(dev_c, 0, length * sizeof(float));

	srand((unsigned)time(NULL)); // semilla de aleatorios dinamica

								 //fill arrays a and b on the CPU
	for (int i = 0; i<length; i++) {
		a[i] = (((float)rand() / (float)RAND_MAX) * 100) - 20;
		b[i] = (((float)rand() / (float)RAND_MAX) * 100) - 20;
	}

	printf("Suma de vector con %d elementos.\n", length);
	clock_t timer1 = clock();

	addCPU(a, b, cpu_c);

	timer1 = clock() - timer1;
	printf("Operacion en CPU toma %10.3f ms.\n", (((float)timer1) / CLOCKS_PER_SEC) * 1000);

	//copy arrays from host to device
	// (destino, origen, tamaño datos, dirección de copiado)
	cudaMemcpy(dev_a, a, length * sizeof(float),
		cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, length * sizeof(float),
		cudaMemcpyHostToDevice);

	clock_t timer2 = clock();

	// Caso 1
	//dim3 dimGrid(length);
	//dim3 dimBlock(1);

	// Caso 2
	//dim3 dimGrid(1, length);
	//dim3 dimBlock(1);

	//Caso 3 
	//dim3 dimGrid (1);
	//dim3 dimBlock(length);

	//Caso 4
	//dim3 dimGrid(divEntera(length, maxHilos));
	//dim3 dimBlock(maxHilos);

	//Caso 5
	//int numBloques = divEntera(length, maxHilos);
	//int numHilos = divEntera(length, numBloques);
	//dim3 dimGrid(numBloques);
	//dim3 dimBlock(numHilos);

	//Caso 6
	int numBloques = divEntera(length, maxHilos*elemxHilo);
	dim3 dimGrid(numBloques);
	dim3 dimBlock(maxHilos);

	cudaError_t cudaStatus;
	add << <dimGrid, dimBlock >> >(dev_a, dev_b, dev_c);
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "Kernel launch FAILED: %s\n",
			cudaGetErrorString(cudaStatus));
	}

	timer2 = clock() - timer2;
	printf("Operacion en Device toma %10.3f ms.\n", (((float)timer2) / CLOCKS_PER_SEC) * 1000);

	printf("Configuracion de ejecucion: \n");
	printf("Grid [%d, %d, %d] Bloque [%d, %d, %d]\n",
		dimGrid.x, dimGrid.y, dimGrid.z,
		dimBlock.x, dimBlock.y, dimBlock.z);
	printf("Elementos por hilo: %d\n", elemxHilo);

	//copy results back - device to host
	// (destino, origen, tamaño datos, dirección de copiado)
	cudaMemcpy(gpu_c, dev_c, length * sizeof(float),
		cudaMemcpyDeviceToHost);

	imprimir(a, b, cpu_c, gpu_c);

	float diferencia = 0;
	int nDiferentes = 0;

	diferencia = comparar(gpu_c, cpu_c, &nDiferentes);

	printf("Elementos diferentes %d (%.3f %%) Con valor de %.20f\n", nDiferentes, ((nDiferentes / float(length)) * 100), diferencia);
	printf("======================================================================\n");

	//free memory - GPU
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	printf("\nPresione cualquier tecla para salir...");
	char tecla;
	scanf("%c", &tecla);
}