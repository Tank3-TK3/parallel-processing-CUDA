//////////////////////////////////////////////////
//            Program 01 Variables              //
//////////////////////////////////////////////////
#include <iostream>

using namespace std;

int main( int argc, char* argv[] )
{
	int a = 10;
	int b = 20;
	int c;
	float f = 205.78;
	int* aPtr = &a;
	int* bPtr = &b;
	int* cPtr = &c;
	float* fPtr = &f;

	cout << "==================================================\n";

	cout << "The sum of " << a << " + " << b << " = " << a + b << "\n";
	cout << "The value of f is " << f << "\n";

	cout << "==================================================\n";

	cout << "The memory addresses of the variables are:\n";
	cout << " A) a is: " << &a << "\n";
	cout << " B) b is: " << &b << "\n";
	cout << " C) c is: " << &c << "\n";
	cout << " D) f is: " << &f << "\n";
	cout << " E) aPtr is: " << &aPtr << "\n";
	cout << " F) bPtr is: " << &bPtr << "\n";
	cout << " G) cPtr is: " << &cPtr << "\n";
	cout << " H) fPtr is: " << &fPtr << "\n";

	cout << "==================================================\n";

	cout << "The content of the pointer variables is:\n";
	cout << " A) aPtr is: " << aPtr << "\n";
	cout << " B) bPtr is: " << bPtr << "\n";
	cout << " C) cPtr is: " << cPtr << "\n";
	cout << " D) fPtr is: " << fPtr << "\n";

	cout << "==================================================\n";

	cout << "The original content of the variables referred by pointer are:\n";
	cout << " A) aPtr is: " << *aPtr << "\n";
	cout << " B) bPtr is: " << *bPtr << "\n";
	cout << " C) cPtr is: " << *cPtr << "\n";
	cout << " D) fPtr is: " << *fPtr << "\n";
	a = 345;
	*bPtr = 777;
	c = *bPtr + 13;
	*cPtr = *cPtr + 25;

	cout << "==================================================\n";

	cout << "The actual content of the variables referred to by pointer are:\n";
	cout << " A) aPtr is: " << *aPtr << "\n";
	cout << " B) bPtr is: " << *bPtr << "\n";
	cout << " C) cPtr is: " << *cPtr << "\n";
	cout << " D) fPtr is: " << *fPtr << "\n";

	cout << "==================================================\n";
	
	system( "pause" );
	return 0;
}
