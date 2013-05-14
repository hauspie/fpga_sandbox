# The targeted device
DEVICE=xc6slx45-3csg324

# The project name, can be pretty much anything
PROJECT=led_blink.prj
# The name of the top module vhdl file
TOP_MODULE=clock_divider
# VHDL source files
VHDL=$(wildcard *.vhd)
# Name of the output image
OUTPUT=$(PROJECT:.prj=.bit)


# You should not have to edit anything beyond this line


NGC=$(PROJECT:.prj=.ngc)
NGD=$(PROJECT:.prj=.ngd)
UCF=$(PROJECT:.prj=.ucf)
NCD=$(PROJECT:.prj=.ncd)
PAR_NCD=$(PROJECT:.prj=_par.ncd)


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

# This rule decomposes the synthesized design into FPGA elements
# (flip-flops, gates...)
$(NGD): $(UCF) $(NGC) 
	ngdbuild -p $(DEVICE) -uc $^
to_clean+=$(NGD:.ngd=_ngdbuild.xrpt) $(NGD) $(NGD:.ngd=.bld) netlist.lst xlnx_auto_0_xdb

# This rule maps the previously made generic elements to the specific elements
# of the target
$(NCD): $(NGD)
	map -detail -pr b $^
to_clean+=$(NCD) $(NCD:.ncd=.map) $(NCD:.ncd=.mrp) $(NCD:.ncd=.ngm) $(NCD:.ncd=.pcf) $(NCD:.ncd=_summary.xml) $(NCD:.ncd=_usage.xml) $(VHDL:.vhd=_map.xrpt)

# Place and route to fully route fpga design
$(PAR_NCD): $(NCD)
	par $^ $@ $(NCD:.ncd=.pcf)
to_clean+=$(PAR_NCD) $(VHDL:.vhd=_par.xrpt) $(PAR_NCD:.ncd=.pad) $(PAR_NCD:.ncd=_pad.csv) $(PAR_NCD:.ncd=_pad.txt) $(PAR_NCD:.ncd=.par) $(PAR_NCD:.ncd=.ptwx) $(PAR_NCD:.ncd=.unroutes) $(PAR_NCD:.ncd=.xpi) par_usage_statistics.html

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
