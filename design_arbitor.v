//design
module arbiter(clk,rst,req,gnt); 
input clk; 
input rst; 
input [3:0] req; //request signals 
output [3:0] gnt; //grant signals 
wire beg; // BEGIN SIGNAL 
wire [1:0] lgnt_encode; // LATCHED ENCODED GRANT 
wire lcomreq; // BUS STATUS 
reg [3:0] lgnt; // LATCHED GRANTS 
reg mask_enable; 
reg [1:0] lmask; 

always @(posedge clk) 
if(rst) 
begin 
lgnt[0]<=0; 
lgnt[1]<=0; 
lgnt[2]<=0; 
lgnt[3]<=0; 
end 
else 
begin 
lgnt[0] <=(~lcomreq & ~lmask[1] & ~lmask[0] & ~req[3] & ~req[2] & ~req[1] & req[0]) 
     |(~lcomreq & ~lmask[1] & lmask[0] & ~req[3] & ~req[2] & req[0]) 
	  |(~lcomreq & lmask[1] & ~lmask[0] & ~req[3] & req[0]) 
	  |(~lcomreq & lmask[1] & lmask[0] & req[0]) |(lcomreq & lgnt[0]); 
lgnt[1] <=(~lcomreq & ~lmask[1] & ~lmask[0] & req[1]) 
     |(~lcomreq & ~lmask[1] & lmask[0] & ~req[3] & ~req[2] & req[1] & ~req[0]) 
	  |(~lcomreq & lmask[1] & ~lmask[0] & ~req[3] & req[1] & ~req[0]) 
	  |(~lcomreq & lmask[1] & lmask[0] & req[1] & ~req[0]) 
	  |(lcomreq & lgnt[1]); 
lgnt[2] <=(~lcomreq & ~lmask[1] & ~lmask[0] & req[2] & ~req[1]) 
     |(~lcomreq & ~lmask[1] & lmask[0] & req[2]) 
	  |(~lcomreq & lmask[1] & ~lmask[0] & ~req[3] & req[2] & ~req[1] & ~req[0]) 
	  |(~lcomreq & lmask[1] & lmask[0] & req[2] & ~req[1] & ~req[0]) 
	  |(lcomreq & lgnt[2]); 
lgnt[3] <=(~lcomreq & ~lmask[1] & ~lmask[0] & req[3] & ~req[2] & ~req[1]) 
     |(~lcomreq & ~lmask[1] & lmask[0] & req[3] & ~req[2]) 
	  |(~lcomreq & lmask[1] & ~lmask[0] & req[3]) 
	  |(~lcomreq & lmask[1] & lmask[0] & req[3] & ~req[2] & ~req[1] & ~req[0]) 
	  |(lcomreq & lgnt[3]); 
end 

//initialize ur begin signal 
assign beg=(req[3]|req[2]|req[1]|req[0]) & ~lcomreq; 

//comreq bus logic 
assign lcomreq=(req[3] & lgnt[3])|(req[2] & lgnt[2])|(req[1] & lgnt[1])|(req[0] & lgnt[0]); 

//encoder 
assign lgnt_encode={(lgnt[3]|lgnt[2]),(lgnt[3]|lgnt[1])}; 

//lmask reg 
always @(posedge clk) 
if(rst) 
begin 
lmask[1]<=0; 
lmask[0]<=0; 
end 

else if(mask_enable) 
begin 
lmask[1]<=lgnt[1]; 
lmask[0]<=lgnt[0]; 
end 

else 
begin 
lmask[1]<=lmask[1]; 
lmask[0]<=lmask[0]; 
end 

assign comreq=lcomreq; 
assign gnt=lgnt; //drive inputs to outputs  
endmodule