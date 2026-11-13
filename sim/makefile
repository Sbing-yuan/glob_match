Test.o: TestTop.v
	iverilog -g2012 -o $@ TestTop.v

run_CASE1: Test.o
	vvp Test.o +CASE=I01_I2C

run_CASE2: Test.o
	vvp Test.o +CASE=I01_SPI

run_CASE3: Test.o
	vvp Test.o +CASE=I02_I2C

clean:
	rm -f Test.o

GTK:
	export DISPLAY=:0
	gtkwave

