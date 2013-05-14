# To include this makefile you should define the following variable before
# include directive
# # The targeted device
# DEVICE=xc6slx45-3csg324

# # The project name, can be pretty much anything
# PROJECT=project_name.prj
# # The name of the top module vhdl file
# TOP_MODULE=top_module
# # VHDL source files
# VHDL=$(wildcard *.vhd)
# # Name of the output image
# OUTPUT=$(PROJECT:.prj=.bit)


# You should not have to edit anything beyond this line
NGC=$(PROJECT:.prj=.ngc)
NGD=$(PROJECT:.prj=.ngd)
UCF=$(PROJECT:.prj=.ucf)
NCD=$(PROJECT:.prj=.ncd)
PAR_NCD=$(PROJECT:.prj=_par.ncd)


.PHONY: clean mrproper

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
	map -detail -pr b -w $^
to_clean+=$(NCD) $(NCD:.ncd=.map) $(NCD:.ncd=.mrp) $(NCD:.ncd=.ngm) $(NCD:.ncd=.pcf) $(NCD:.ncd=_summary.xml) $(NCD:.ncd=_usage.xml) $(VHDL:.vhd=_map.xrpt)

# Place and route to fully route fpga design
$(PAR_NCD): $(NCD)
	par -w $^ $@ $(NCD:.ncd=.pcf)
to_clean+=$(PAR_NCD) $(VHDL:.vhd=_par.xrpt) $(PAR_NCD:.ncd=.pad) $(PAR_NCD:.ncd=_pad.csv) $(PAR_NCD:.ncd=_pad.txt) $(PAR_NCD:.ncd=.par) $(PAR_NCD:.ncd=.ptwx) $(PAR_NCD:.ncd=.unroutes) $(PAR_NCD:.ncd=.xpi) par_usage_statistics.html

$(OUTPUT): $(PAR_NCD)
	bitgen -w -g CRC:Enable -g StartUpClk:CClk -g Compress $^ $@ $(PROJECT:.prj=.pcf)
to_clean+=$(OUTPUT:.bit=.bgn) $(OUTPUT:.bit=_bitgen.xwbt) $(OUTPUT:.bit=.drc) webtalk.log usage_statistics_webtalk.html
program: $(OUTPUT)
	djtgcfg prog -d Atlys -i 0 -f $(OUTPUT)

clean:
	$(RM) -r $(to_clean) *~

mrproper: clean
	$(RM) $(OUTPUT)
