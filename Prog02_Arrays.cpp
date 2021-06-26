//////////////////////////////////////////////////
//              Program 02 Arrays               //
//////////////////////////////////////////////////
#include <iostream>
#include <time.h>

using namespace std;

const int numRen = 5;

int main( int argc , char* argv[] )
{
	float array1[numRen];
	float *array2;
	float *array1Ptr;
	array1Ptr = &array1[0];
	array2 = ( float * ) malloc( numRen * sizeof( float ) );
	srand( ( unsigned ) time( NULL ) );
	for ( int i = 0 ; i < numRen ; i++ )
    {
		array1[i] = ( ( float ) rand() / ( float ) RAND_MAX ) * 100;
		array2[i] = ( ( float ) rand() / ( float ) RAND_MAX ) * 100;
	}
	cout << "==================================================\n";
	cout << "The memory addresses of the variables are:\n";
	cout << "A ) array1 is: " << &array1[0] << "\n";
	cout << "A') array1 is: " << &array1    << "\n";
	cout << "B ) array2 is: " << &array2    << "\n";
	cout << "==================================================\n";
	cout << "The contents of the pointer variables are:\n";
	cout << "A) array1Ptr is: " << array1Ptr << "\n";
	cout << "B) array2 is: "    << array2    << "\n";
	cout << "==================================================\n";
	cout << "The memory addresses of the elements of the arrays are:\n";
	for ( int i = 0 ; i < numRen ; ++i )
    {
		cout << i + 1 << ") array1[" << i << "]: " << &array1[i];
		cout << " -- array2[" << i << "]: " << &array2[i] << "\n";
	}
	cout << "==================================================\n";
	cout << "The content of the arrays are:\n";
	for ( int i = 0 ; i < numRen ; ++i )
	{
		cout << i + 1 << ") array1[" << i << "]: " << array1[i];
		cout << " -- array2[" << i << "]: " << array2[i] << "\n";
	}
	cout << "==================================================\n";
	cout << "The content of the arrays using index are:\n";
	for ( int i = 0 ; i < numRen ; ++i )
	{
		array1[i] = array1[i] + 100;
		array2[i] = array2[i] + 100;
		cout << i + 1 << ") array1[" << i << "]: " << array1[i];
		cout << " -- array2[" << i << "]: " << array2[i] << "\n";
	}
	cout << "==================================================\n";
	cout << "The content of the arrays using pointers are:\n";
	for ( int i = 0 ; i < numRen ; ++i ) 
	{
		*( array1 + i ) = *( array1 + i ) + 20;
		*( array1Ptr + i ) = *( array1Ptr + i ) + 20;
		*( array2 + i ) = *( array2 + i ) + 20;
		cout << i + 1 << ") array1[" << i << "]: " << array1[i];
		cout << " -- array2[" << i << "]: " << array2[i] << "\n";
	}
	cout << "==================================================\n";
    free( array2 );
    system( "pause" );
	return 0;
}
