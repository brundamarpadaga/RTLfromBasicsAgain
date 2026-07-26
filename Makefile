SHELL=/bin/bash

# Directories
DESIGN_DIR = design
TB_DIR = testbench
BUILD_DIR = build

# Which module to build/simulate, e.g. `make TOP=counter` or `make TOP=counter wave`
TOP ?= counter

# Sources: only the design files under design/$(TOP)/ plus its testbench
VERILOG_SOURCES = $(shell find $(DESIGN_DIR)/$(TOP) -name '*.sv') $(TB_DIR)/$(TOP)_tb.sv

# Output
VCD_FILE = $(BUILD_DIR)/$(TOP)_tb.vcd
SIM_OUT = $(BUILD_DIR)/$(TOP)_tb.out

.PHONY: all sim wave clean
all: sim

sim: $(VCD_FILE)

$(VCD_FILE): $(VERILOG_SOURCES)
	@mkdir -p $(BUILD_DIR)
	iverilog -g2012 -o $(SIM_OUT) -I $(DESIGN_DIR)/$(TOP) $(VERILOG_SOURCES)
	vvp $(SIM_OUT)
	@mv $(TOP)_tb.vcd $(VCD_FILE)

wave: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

clean:
	rm -rf $(BUILD_DIR)
