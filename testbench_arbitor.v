//testbench 
module top (); 
reg clk; 
reg rst; 
reg [3:0] req; 
wire [3:0] gnt; 

// Clock generator 
always #1 clk =~clk; 
initial 
begin 
$dumpfile ("arbiter.vcd"); 
$dumpvars(); 
clk = 0; 
rst = 1; 
req = 0; 
#10 rst = 0; 
repeat (1) @ (posedge clk); 
req[0] <= 1; 
repeat (1) @ (posedge clk); 
req[0] <= 0; 
repeat (1) @ (posedge clk); 
req[0] <= 1; 
req[1] <= 1; 
repeat (1) @ (posedge clk); 
req[2] <= 1; 
req[1] <= 0; 
repeat (1) @ (posedge clk); 
req[3] <= 1; 
req[2] <= 0; 
repeat (1) @ (posedge clk); 
req[3] <= 0; 
repeat (1) @ (posedge clk); 
req[0] <= 0; 
repeat (1) @ (posedge clk) 
#10 $finish; 
end 

// Connect the DUT 
arbiter U (clk,rst,req,gnt); 

endmodule