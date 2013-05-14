DEVICE=xc6slx45-3csg324

PROGRAM=clock_divider

VHDL=$(PROGRAM).vhd
NGC=$(VHDL:.vhd=.ngc)
UCF=$(PROGRAM).ucf

all: $(PROGRAM).bit

%.ngc: %.vhd
	echo "run -ifn $< -ifmt VHDL -ofn $@ -p $(DEVICE) -opt_mode Speed -opt_level 1" | xst

%.ngd: $(UCF) $(NGC) 
	ngdbuild -p $(DEVICE) -uc $^
counter.ncd: counter.ngd
	map -k 6 -detail -pr b counter.ngd
counter.pcf: counter.ngd
	map -k 6 -detail -pr b counter.ngd
parout.ncd: counter.ncd
	par counter.ncd parout.ncd counter.pcf
counter.bit: parout.ncd
	bitgen -g CRC:Enable -g StartUpClk:CClk -g Compress \
	parout.ncd counter.bit counter.pcf
counter.bin: counter.bit
	promgen -w -p bin -o counter.bin -u 0 counter.bit
install: counter.bin
	stty --file=/dev/ttyUSB0 -opost # We want raw output
	cat counter.bin > /dev/ttyUSB0
clean:
	rm -rf counter.bgn counter.bin counter.bit counter.bld \
	counter.drc counter.map counter_map.xrpt counter.mrp \
	counter.ncd counter.ngc counter.ngd counter_ngdbuild.xrpt \
	counter.ngm counter_par.xrpt counter.pcf counter.prm \
	counter_summary.xml counter_usage.xml counter_xst.xrpt \
	netlist.lst parout.ncd parout.pad parout_pad.csv \
	parout_pad.txt parout.par parout.ptwx parout.unroutes \
	parout.xpi xlnx_auto_0.ise xlnx_auto_0_xdb xst
