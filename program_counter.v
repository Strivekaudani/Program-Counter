`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Munya Kaudani 
// Program Counter for MIPS processor
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
		       input wire	clk,
		       input wire	rst_n,
		       input wire	update_msbs,
		       input wire	update_lsbs,
		       input wire	jump,
		       input wire [5:0]	jump_destination,
		       input wire	brancher,
		       input wire [5:0] branch_offset,
		       output reg [7:0] mem_addr
		       );
    
    // internal combinational registers
    reg [7:0] mem_addr_next;
    
    
    // sequential logic    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
            mem_addr <= 8'h00;
        end else begin
            mem_addr <= mem_addr_next;
        end   
    end

   // combinational logic
    always @(*)
    begin
        mem_addr_next = mem_addr;
        
        if (update_msbs == 1'b1) begin
            // use "update_msbs" to progress one instruction, each instruction is 4 memory addresses 
            //    so it counts in increments of 4
            mem_addr_next[7:2] = mem_addr[7:2] + 1'b1;
            mem_addr_next[1:0] = 2'b00;
        end else if (update_lsbs == 1'b1) begin
            // use "update_lsbs" to progress to the next memory address, use it to advance to the next
            //    8 bits of an instruction
            mem_addr_next[1:0] = mem_addr[1:0] + 1'b1;
        end else if (jump == 1'b1) begin
            // use "jump" for the jump command, jumps to the instruction indicated. 
            mem_addr_next[7:2] = jump_destination;
            mem_addr_next[1:0] = 2'b00;
        end else if (brancher == 1'b1) begin
            // use "brancher" for the "branch if equal" command, branches to 
            //    current instruction number + branch_offset
            mem_addr_next[7:2] = mem_addr[7:2] + branch_offset;
            mem_addr_next[1:0] = 2'b00;
        end
     end
       
endmodule
