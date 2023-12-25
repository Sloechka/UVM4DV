/*!
 * @author radigast
 */

import lab_test_pkg::lab_test_example;

module tb_top();

    reg        RST_N = 1;
    reg        REF_CLK = 0;


    always #5000 REF_CLK = ~REF_CLK;

    initial begin
        #13000 RST_N <= 0;
        #20000 RST_N <= 1;
    end

    //interface instance
    dstream_if dstream_if0(.clk(REF_CLK), .rst_n(RST_N));
    initial begin
        uvm_pkg::uvm_config_db #(virtual dstream_if)::set(null, "tb_top.dstream_if0", "dstream_vif", dstream_if0);
    end

    cam dut(
        .clk(REF_CLK),
        .rst_n(RST_N),
        .d_master(dstream_if0.d_master),
        .d_slave(dstream_if0.d_slave),
        .d_valid(dstream_if0.d_valid)
    );

    initial begin
        uvm_pkg::run_test("");
    end

endmodule