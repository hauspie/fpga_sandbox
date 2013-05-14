Installing development tools for using the Digilent ATLYS board
===============================================================
* Download and install Xilinx ISE Webpack
* Install Digilent's adept (available in an AUR package on archlinux)


Atlys board
===========
These samples are designed to work on the ATLYS board by digilent [1]

A set of lectures for VHDL code and using the digilent board are available in [2]

Board setup
-----------
* Family: Spartan 6
* Device: XC6SLX45
* Package: CSG324
* Timing: -3
* This result in the name `xc6slx45-3csg324` to be used as the `DEVICE` variable in the makefile

Using ISE from command line
===========================

The provided makefile allows the use of the ISE tool chain from the command
line. I made the makefile after reading a nice tutorial on this subject [3]

To create a new project, you just have to create a makefile that defines five
variable:
* `DEVICE` : is the device you compile for. See the documentation of your board to know what xilinx package to use
* `PROJECT` : the name of your project. Can be anything, but must end with the `.prj` extension
* `TOP_MODULE` : the name of the top level module in your vhdl files
* `VHDL` : the list of vhdl files of your project
* `OUTPUT`: the final output file that will be flashed on the board

VHDL tutorials
==============
As stated before, [1] is a full course on VHDL using lab exercices on Digilent board.
[4] is a free book on designing hardware using VHDL.

References
==========
* [1] http://www.digilentinc.com/Products/Detail.cfm?NavPath=2,400,836&Prod=ATLYS&CFID=1671565&CFTOKEN=32775819
* [2] http://www.dejazzer.com/ee478/
* [3] http://www.demandperipherals.com/docs/CmdLineFPGA.pdf
* [4] http://www.freerangefactory.org/dl/free_range_vhdl.pdf

Acknowledgment
==============
The fourbit adder sample is not mine but borrowed from the course
available on [2]

