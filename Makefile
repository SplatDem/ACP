.SILENT:

GCCOUTPUT=lilang

make: info build

info:
	echo "[\033[35mBUILD\033[0m]: Program requires fasm, so install it if you don't"

build:
	gcc -o $(GCCOUTPUT) src/*.c
	echo "[\033[35mBUILD\033[0m]: Complete; Output: lilang"
