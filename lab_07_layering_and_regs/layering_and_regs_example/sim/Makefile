#print verbosity level
# UVM_VERBOSITY := UVM_HIGH
# UVM_VERBOSITY := UVM_MEDIUM
# UVM_VERBOSITY := UVM_LOW
# UVM_VERBOSITY := UVM_FULL
# UVM_VERBOSITY := UVM_DEBUG
 UVM_VERBOSITY := UVM_NONE

# report options
LOG_FILENAME=simulation.log

TEST_NAME:=lab_test_example

#top level name
TOP_LEVEL_NAME:=tb_top

DUMPDB:=0
COV:=0

#random SEED generation for test
ifndef SEED
    SEED:=$(shell date +%s )
endif

ifeq ($(GUI), 1)
    gui:=-gui
else
    gui:=
endif

LAB_HOME=$(shell pwd)/../

# --------------  compile and simulation tools  -------------------------------------

all: clean sim

clean:
	#common
	rm -rf *~
	rm -rf *.shm
	rm -rf *.log
	rm -rf *.diag
	rm -rf *.history
	rm -rf *.shm
	rm -rf xcelium.d
	rm -rf .simvision
	rm -rf xrun.key
	clear;

sim:
	TOP_LEVEL_NAME=$(TOP_LEVEL_NAME) \
	DUMPDB=$(DUMPDB) \
	xrun -64BIT -sv -uvm -errormax 150 +access+rwc -input simulate.tcl \
	-incdir $(LAB_HOME)/tb \
	-incdir $(LAB_HOME)/dstream_uvc \
	-incdir $(LAB_HOME)/a_layer_uvc \
	-incdir $(LAB_HOME)/cam_ral \
	$(gui) -svseed $(SEED) -logfile $(LOG_FILENAME) \
	+UVM_VERBOSITY=$(UVM_VERBOSITY)  +UVM_TESTNAME=$(TEST_NAME) \
	-top $(TOP_LEVEL_NAME) \
    $(LAB_HOME)/rtl/cam.sv \
	$(LAB_HOME)/dstream_uvc/dstream_pkg.sv \
	$(LAB_HOME)/a_layer_uvc/a_layer_pkg.sv \
	$(LAB_HOME)/cam_ral/cam_ral_pkg.sv \
	$(LAB_HOME)/tb/lab_test_pkg.sv \
    $(LAB_HOME)/tb/tb_top.sv


report: res=S
report: eres=$(shell if [ "$$(grep "UVM_ERROR :" simulation.log)"   != "UVM_ERROR :    0"   ]; then echo E; else echo $(res) ;fi)
report: rpt_status=$(shell if [ "$$(grep "UVM_FATAL :" simulation.log)"   != "UVM_FATAL :    0"   ]; then echo F; else echo $(eres); fi)
report:
	if [ "$(rpt_status)" != "S" ]; then \
		echo "exiting with error";\
		exit 1;\
	else \
		echo "all ok!";\
	fi;\

# --------------  test debug tools  ---------------------------------------
view:
	simvision -64BIT -waves -nocopyright  $(TOP_LEVEL_NAME).shm/ &

#----------------------- help ---------------------------------------------
help:
	@printf "help \n"








