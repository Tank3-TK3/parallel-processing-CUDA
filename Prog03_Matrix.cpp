//////////////////////////////////////////////////
//              Program 03 Matrix               //
//////////////////////////////////////////////////
#include <iostream>
#include <time.h>

using namespace std;

const int numRow = 2;
const int numCol = 3;
const int numDep = 4;

int main( int argc , char* argv[] )
{
	int pos;
	float matrix1[numRow][numCol];
	float *matrix2;
	float matrix3[numRow][numCol][numDep];
	float *mat1Ptr;
	float *mat3Ptr;

	mat1Ptr = &matrix1[0][0];
	matrix2 = ( float * ) malloc( numRow * numCol * sizeof( float ) );
	mat3Ptr = &matrix3[0][0][0];
	srand( ( unsigned ) time( NULL ) );

	for( int i = 0 ; i < numRow ; ++i ) 
	{
		for( int j = 0 ; j < numCol ; ++j ) 
		{
			pos = ( i * numCol ) + j;
			matrix1[i][j] = ( ( float ) rand() / ( float ) RAND_MAX ) * 100;
			matrix2[pos] = ( ( float ) rand() / ( float ) RAND_MAX ) * 100;
		}
	}

	for( int i = 0 ; i < numRow ; ++i )
	{
		for( int j = 0 ; j < numCol ; ++j )
		{
			for( int k = 0 ; k < numDep ; ++k )
			{
				matrix3[i][j][k] = ( ( float ) rand() / ( float ) RAND_MAX ) * 100;
			}
		}
	}

	cout << "==================================================\n";

	cout << "The memory addresses of the variables are:\n";
	cout << " A) matrix1 is: " << &matrix1[0][0] << "\n";
	cout << " B) mat1Ptr is: " << &mat1Ptr << "\n";
	cout << " C) matrix2 is: " << &matrix2 << "\n";
	cout << " D) matrix3 is: " << &matrix3[0][0][0] << "\n";
	cout << " E) mat3Ptr is: " << &mat3Ptr << "\n";

	cout << "==================================================\n";

	cout << "The contents of the pointer variables are:\n";
	cout << " A) mat1Ptr is: " << mat1Ptr << "\n";
	cout << " B) matrix2 is: " << matrix2 << "\n";
	cout << " C) mat3Ptr is: " << mat3Ptr << "\n";

	cout << "==================================================\n";

	cout << "The contents of the matrices are:\n";

	for( int i = 0 ; i < numRow ; ++i )
	{
		for( int j = 0 ; j < numCol ; ++j )
		{
			pos = ( i * numCol ) + j;
			cout << pos + 1 << ") matrix1["<< i <<"][" << j << "]: ";
			cout << matrix1[i][j] << " -- matrix2[" << pos << "]: ";
			cout << matrix2[pos] << "\n";
		}
	}

	cout << "==================================================\n";

	cout << "The updated content of the matrices are:\n";

	for( int i = 0 ; i < numRow ; ++i )
	{
		for( int j = 0 ; j < numCol ; ++j )
		{
			pos = ( i * numCol ) + j;
			matrix1[i][j] = matrix1[i][j] + 10;
			*( mat1Ptr + pos ) = *( mat1Ptr + pos ) + 20;
			matrix2[pos] = matrix2[pos] + 20;
			*( matrix2 + pos ) = *( matrix2 + pos ) + 30;
			cout << pos + 1 << ") matrix1["<< i <<"][" << j << "]: ";
			cout << *( mat1Ptr + pos ) << " -- matrix2[" << pos << "]: ";
			cout << matrix2[pos] << "\n";
		}
	}

	cout << "==================================================\n";

	cout << "The content of the 3D matrix is:\n";

	for( int i = 0 ; i < numRow ; ++i )
	{
		for( int j = 0 ; j < numCol ; ++j )
		{
			for( int k = 0 ; k < numDep ; ++k )
			{
				pos = i * ( numCol * numDep ) + j * ( numDep ) + k;
				cout << pos + 1 << ") matrix3[" << i << "][" << j << "][";
				cout << k << "]: " << matrix3[i][j][k] << " -- matrix3[";
				cout << pos << "]: " << mat3Ptr[pos] << "\n";
			}
		}
	}

	cout << "==================================================\n";

	cout << "The updated content of the matrix is:\n";

	for( int i = 0 ; i < numRow ; ++i )
	{
		for( int j = 0 ; j < numCol ; ++j )
		{
			for( int k = 0 ; k < numDep ; ++k )
			{
				pos = i * ( numCol * numDep ) + j * ( numDep ) + k;
				matrix3[i][j][k] = matrix3[i][j][k] + 10;
				mat3Ptr[pos] = mat3Ptr[pos] + 20;
				*( mat3Ptr + pos ) = *( mat3Ptr + pos ) + 20;
				cout << "%d) matrix3[%d][%d][%d]: %10.5f -- matrix3[%d]: %10.5f-- matrix3[%d]: %10.5f\n",
				pos + 1, i, j, k, matrix3[i][j][k],
				pos, mat3Ptr[pos],
				pos, *(mat3Ptr + pos);
			}
		}
	}

	cout << "==================================================\n";

	free( matrix2 );
	system( "pause" );
	return 0;
}
