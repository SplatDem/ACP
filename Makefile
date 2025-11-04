.SILENT:

make: info build

info:
	echo "[\033[35mBUILD\033[0m]: Program requires fasm, so install it if you don't"

build:
	zig build-exe src/main.zig
	echo "[\033[35mBUILD\033[0m]: Complete"

run: build
	-./main test.il -o output.asm
	echo "========================================"
	echo "[\033[35mBUILD\033[0m]: Assembly output:"
	cat output.asm
