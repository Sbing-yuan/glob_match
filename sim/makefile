Test_Compile:
	iverilog -g2012 -o Test.o TestTop.v

run_CASE1:
	vvp Test.o +CASE=I01_I2C

run_CASE2:
	vvp Test.o +CASE=I01_SPI

run_CASE3:
	vvp Test.o +CASE=I02_I2C

clean:
	rm -f Test.o

GTK:
	export DISPLAY=:0
	gtkwave

