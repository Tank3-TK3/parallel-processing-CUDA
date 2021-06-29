//////////////////////////////////////////////////
//           Program 04 Query Device            //
//////////////////////////////////////////////////
#include <iostream>
#include <cuda_runtime.h>

using namespace std;

char* getDeviceArchitecture( cudaDeviceProp devProp )
{
	char* sign = "";
	switch( devProp.major )
	{
	case 2:
		sign = "Fermi";
		break;
	case 3:
		sign = "Kepler";
		break;
	case 5:
		sign = "Maxwell";
		break;
	case 6:
		sign = "Pascal";
		break;
	case 7:
		sign = "Volta or Turing";
		break;
	case 8:
		sign = "Ampere";
	default:
		sign = "Unknown device type";
		break;
	}
	return sign;
}

int getSPcores( cudaDeviceProp devProp )
{
    int cores = 0;
    int mp = devProp.multiProcessorCount;
    switch( devProp.major )
    {
        case 2:
            if( devProp.minor == 1 ) cores = mp * 48;
            else cores = mp * 32;
            break;
        case 3:
            cores = mp * 192;
            break;
        case 5:
            cores = mp * 128;
            break;
        case 6:
            if( ( devProp.minor == 1 ) || ( devProp.minor == 2 ) ) cores = mp * 128;
            else if( devProp.minor == 0 ) cores = mp * 64;
            else cout << "Unknown device type\n";
            break;
        case 7:
            if( ( devProp.minor == 0 ) || ( devProp.minor == 5 ) ) cores = mp * 64;
            else cout << "Unknown device type\n";
            break;
        case 8:
            if( devProp.minor == 0 ) cores = mp * 64;
            else if( devProp.minor == 6 ) cores = mp * 128;
            else cout << "Unknown device type\n";
            break;
        default:
            cout << "Unknown device type\n"; 
            break;
    }
    return cores;
}

void printDevProp( int i )
{
	cudaDeviceProp devProp;
	cudaGetDeviceProperties( &devProp, i );
	cout << " - ASCII string identifying device: " << devProp.name << "\n";
	cout << " - Device architecture name: " << getDeviceArchitecture( devProp ) << "\n";
	cout << " - Major compute capability: " << devProp.major << "\n";
	cout << " - Minor compute capability: " << devProp.minor << "\n";
	cout << " - Number of multiprocessors on device: " << devProp.multiProcessorCount << "\n";
	cout << " - Cores CUDA: %d\n" << getSPcores(devProp);
	cout << "Total de memoria global:           %u\n" << devProp.totalGlobalMem;
	cout << "Total de memoria compartida por bloque: %u\n" << devProp.sharedMemPerBlock;
	cout << "Total de registros por bloque:     %d\n" << devProp.regsPerBlock;
	cout << "Tamaño del warp:                     %d\n" << devProp.warpSize;
	cout << "Pitch maximo de memoria:          %u\n" << devProp.memPitch;
	cout << "Hilos maximos por bloque:     %d\n" << devProp.maxThreadsPerBlock;
	for ( int i = 0 ; i < 3 ; ++i )
		cout << "Dimension maxima %d de grid:   %d\n" << i, devProp.maxGridSize[i];
	for ( int i = 0 ; i < 3 ; ++i )
		cout << "Dimension maxima %d de bloque:  %d\n" << i, devProp.maxThreadsDim[i];
	cout << "Velocidad del reloj:                    %d\n" << devProp.clockRate;
	cout << "Memoria constante total:         %u\n" << devProp.totalConstMem;
	cout << "Alineamiento de textura:             %u\n" << devProp.textureAlignment;
	cout << "Copiado y ejecucion concurrente: %s\n" << (devProp.deviceOverlap ? "Si" : "No");
	cout << "Numero de multiprocesadores:     %d\n" << devProp.multiProcessorCount;
	cout << "Timeout de ejecucion del Kernel:      %s\n" << (devProp.kernelExecTimeoutEnabled ? "Si" : "No");
}

int main( int argc, char* argv[] )
{
	int devCount;
	cudaGetDeviceCount( &devCount );

	cout << "##################################################\n";
	cout << "\t  > CUDA Device Specifications <\n";
	cout << "\t     (Total CUDA devices: " << devCount << ")\n";

	for ( int i = 0 ; i < devCount ; ++i )
	{
		cout << "##################################################\n";
		// Get device properties
		cout << "+ CUDA device: " << i << "\n";
		printDevProp( i );
		cout << "##################################################\n\n";
	}

	system( "pause" );
	return 0;
}
