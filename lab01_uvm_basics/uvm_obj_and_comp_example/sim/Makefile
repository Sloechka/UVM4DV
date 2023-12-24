#print verbosity level
# UVM_VERBOSITY := UVM_HIGH
# UVM_VERBOSITY := UVM_MEDIUM
# UVM_VERBOSITY := UVM_LOW
# UVM_VERBOSITY := UVM_FULL
# UVM_VERBOSITY := UVM_DEBUG
 UVM_VERBOSITY := UVM_NONE

# report options
LOG_FILENAME=simulation.log

TEST_NAME:=test_example

#top level name
TOP_LEVEL_NAME:=tb_top


#random SEED generation for test
ifndef SEED
    SEED:=$(shell date +%s )
endif


# --------------  compile and simulation tools  -------------------------------------

all: clean sim

clean:
	rm -rf ./xcelium.d
	rm -rf ./*.log
	rm -rf ./*.history
	clear;

sim:
	echo SEED==$(SEED); \
	xrun -64BIT -sv -uvm -errormax 150 +access+rwc \
	-incdir ./../tb/ \
	-svseed $(SEED) -logfile $(LOG_FILENAME) \
	+UVM_VERBOSITY=$(UVM_VERBOSITY)  +UVM_TESTNAME=$(TEST_NAME) \
	-top $(TOP_LEVEL_NAME) \
	./../tb/test_pkg.sv \
	./../tb/tb_top.sv

#----------------------- help ---------------------------------------------
help:
	@printf "help \n"








