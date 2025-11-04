.SILENT:

ZIGOUTPUT=lilang

make: info build

info:
	echo "[\033[35mBUILD\033[0m]: Program requires fasm, so install it if you don't"

build:
	zig build-exe --name $(ZIGOUTPUT) src/main.zig
	echo "[\033[35mBUILD\033[0m]: Complete"

run: build
	-./$(ZIGOUTPUT) test.il -o output.asm
	echo "========================================"
	echo "[\033[35mBUILD\033[0m]: Assembly output:"
	cat output.asm
