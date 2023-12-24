`timescale 1ns/1ps

`define DEBUG

typedef enum logic { 
    DSTREAM_PHASE_A = 0,
    DSTREAM_PHASE_D = 1
  } dstream_phase_e;

`define CTRL_ADDR       32'h1000
`define VALID_ADDR      32'h1004
`define SEARCH_REG_ADDR 32'h1008
`define RESULT_REG_ADDR 32'h100c
`define MEM_BASE_ADDR   32'h2000
`define MEM_ADDR_MASK   32'hffffff00


module cam (
    input          clk,
    input          rst_n,
    input   [31:0] d_master,  // data from master
    output  [31:0] d_slave,   // data from slave
    input          d_valid    // indicate active tranfer 
);

    //  ---------------- DSTREAM to address access statemachine ------------------//
    reg        dstream_phase;
    reg [31:0] bus_addr_captured;
    reg        bus_write;

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            dstream_phase <= DSTREAM_PHASE_A;
        end else begin
          if (d_valid == 1)
              dstream_phase <= !dstream_phase;          
        end    

    wire add_capture_condition = ((dstream_phase == DSTREAM_PHASE_A) && (d_valid == 1));
    always @(posedge clk)
      if (add_capture_condition) bus_addr_captured <= d_master[23:0];

    always @(posedge clk)
      if ((dstream_phase == DSTREAM_PHASE_A) && (d_valid == 1)) bus_write <= d_master[24];
      else                                                      bus_write <= 1'b0;

    `ifdef DEBUG 
    always @(posedge clk) begin
      if (dstream_phase == DSTREAM_PHASE_D && bus_write == 1) 
        $display("%t DUT BUS WRITE addr=%8x data=%8x", $time, bus_addr_captured, d_master);
      if (dstream_phase == DSTREAM_PHASE_D && bus_write == 0)
        $display("%t DUT BUS READ addr=%8x data=%8x", $time, bus_addr_captured, d_slave);
    end
    `endif

    //  ----------------        address decode        ------------------//
    wire cs_ctrl       = (bus_addr_captured == `CTRL_ADDR);
    wire cs_valid      = (bus_addr_captured == `VALID_ADDR);
    wire cs_search_reg = (bus_addr_captured == `SEARCH_REG_ADDR);
    wire cs_result_reg = (bus_addr_captured == `RESULT_REG_ADDR);
    wire cs_mem        = ((bus_addr_captured & `MEM_ADDR_MASK) == `MEM_BASE_ADDR);


    //  ----------------      CAM regiesters and mem  ------------------//
    reg [1:0]  mode;
    reg [3:0]  valid;
    reg [31:0] search_reg;
    reg [31:0] result_reg;

    reg [31:0] mem [3:0];

    always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
        mode <= 2'b0;
    end else begin
      if (cs_ctrl && bus_write)
        mode <= d_master;
    end
    
    always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
        valid <= 4'b0;
    end else begin
      if (cs_valid && bus_write)
        valid <= d_master;
      else if (cs_mem && bus_write)
        valid[bus_addr_captured[3:2]] <= 1;
    end

    always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
        search_reg <= 32'b0;
    end else begin
      if (cs_search_reg && bus_write)
        search_reg <= d_master;
    end

    always @(posedge clk)    
      if (cs_mem && bus_write)
        mem[bus_addr_captured[3:2]] <= d_master;

    reg [31:0] hit_index;
    integer i;
    always @(posedge clk) begin
        hit_index = 32'hffffffff;
        for (i = 0; i < 4; i = i +1) begin
            if (mem[i] == search_reg && valid[i]) begin                
                if (mode == 2) hit_index <= i;
            end
        end
    end

    wire [31:0] mem_data_by_index = mem[search_reg[1:0]];
    always @(posedge clk) begin        
        if      (mode==1) result_reg <= mem_data_by_index;
        else if (mode==2) result_reg <= hit_index;
    end


   `ifdef DEBUG 
    initial begin
      if (dstream_phase == DSTREAM_PHASE_D && bus_write == 1) 
        $display("%t DUT BUS WRITE addr=%8x data=%8x", $time, bus_addr_captured, d_master);
      if (dstream_phase == DSTREAM_PHASE_D && bus_write == 0)
        $display("%t DUT BUS READ addr=%8x data=%8x", $time, bus_addr_captured, d_slave);
    end
    `endif

    //  ----------------        data to dstream        ------------------//
    assign   d_slave = cs_ctrl       ? mode       : 
                       cs_valid      ? valid      :
                       cs_search_reg ? search_reg :
                       cs_result_reg ? result_reg :
                       mem[bus_addr_captured[3:2]];

endmodule