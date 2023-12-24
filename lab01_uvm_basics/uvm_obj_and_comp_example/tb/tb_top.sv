/*!
 * @author radigast
 */

`timescale 1ps/1ps

module tb_top();

    import test_pkg::test_example;
    reg        RST_N = 1;
    reg        REF_CLK = 0;    

    always #5000 REF_CLK = ~REF_CLK;

    initial begin
        #13000 RST_N <= 0;
        #20000 RST_N <= 1;
	#20000;
    end

    initial begin
        uvm_pkg::run_test("");
    end

endmodule
