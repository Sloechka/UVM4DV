`timescale 1ps/1ps

module axis_dummy(
  axis_if.receiver aif
);

// Very important activity
always @(posedge aif.clk or negedge aif.rst_n) begin
  if(~aif.rst_n) aif.ready <= 0;
  else aif.ready <= 1'b1;
end

endmodule: axis_dummy