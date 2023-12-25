UVM_VERBOSITY := UVM_NONE

# GUI := +gui

LOG_FILENAME := simulation.log

TEST_NAME := dummy_test
TOP_LEVEL_NAME := lab6_tb

TB_HOME := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

ifndef SEED
    SEED:=$(shell date +%s )
endif

.PHONY: all clean

clean:
	rm -rf ./xcelium.d
	rm -rf ./*.log
	rm -rf ./*.history

sim:
	echo SEED==$(SEED); \
	xrun -64BIT -sv -uvm -errormax 150 +access+rwc $(GUI) \
	-incdir $(TB_HOME) \
	-incdir ${TB_HOME}/reset_agent \
	-incdir ${TB_HOME}/axis_agent \
	-svseed $(SEED) -logfile $(LOG_FILENAME) \
	+UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_TESTNAME=$(TEST_NAME) \
	-top $(TOP_LEVEL_NAME) \
	${TB_HOME}/reset_agent/reset_pkg.sv \
	${TB_HOME}/axis_agent/axis_pkg.sv \
	${TB_HOME}/reset_if.sv \
	${TB_HOME}/axis_if.sv \
	${TB_HOME}/axis_dummy.sv \
	${TB_HOME}/test_pkg.sv \
	${TB_HOME}/tb.sv 
