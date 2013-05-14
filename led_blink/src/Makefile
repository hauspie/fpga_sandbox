# The targeted device
DEVICE=xc6slx45-3csg324

# The project name, can be pretty much anything
PROJECT=led_blink.prj
# The name of the top module vhdl file
TOP_MODULE=clock_divider

VHDL=$(wildcard *.vhd)
NGC=$(PROJECT:.prj=.ngc)
NGD=$(PROJECT:.prj=.ngd)
UCF=$(PROJECT:.prj=.ucf)

OUTPUT=$(PROJECT:.prj=.bit)

.PHONY: $(PROJECT)

all: $(OUTPUT)


# A project file is a list a vhdl files to process
# For each vhdl file, the project file include the line
# vhdl work "vhdl_file"
$(PROJECT): $(VHDL)
	@echo "Generating project file ($+)"
	@echo -n '' > $@
	@for src in $+; do echo "vhdl work \"$$src\"" >> $@ ; done
to_clean+=$(PROJECT)

# Synthesization step. VHDL files included in the project file will be synthesized 
# to a netlist file with ngc extension
$(NGC): $(PROJECT)
	echo "run -ifn $< -ofn $@ -p $(DEVICE) -opt_mode Speed -opt_level 1 -top $(TOP_MODULE)" | xst
to_clean+=$(NGC) xst _xmsgs $(PROJECT:.prj=.ngc_xst.xrpt) $(VHDL:.vhd=.lso)

$(NGD): $(UCF) $(NGC) 
	ngdbuild -p $(DEVICE) -uc $^
to_clean+=$(NGD:.ngd=_ngdbuild.xrpt) $(NGD) $(NGD:.ngd=.bld) netlist.lst xlnx_auto_0_xdb

%.ncd: %.ngd
	map -detail -pr b $^
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
	rm -rf $(to_clean)
