`include "pipeFlow_pkg.svh"

module pipeline
(
     output logic [4:0] output_val,
     output logic       pipe_out_valid,
     input  logic       pipe_out_rdy,

     input  logic [4:0] input_val,
     input  logic       pipe_in_valid,
     output logic       pipe_in_rdy,

     input  logic       clk_i,
     input  logic       reset_i
);

   logic [4:0] q0, q1, q2, q3, q4;

   //   [] -> [] -> [] -> [] -> [] ->
   always_ff @(posedge clk_i)
   begin

     `pipeFlow(pipe_in, pipe_out, 5)

     if (update_pipe[0]) begin
       q0 <= input_val;
     end
     if (update_pipe[1]) begin
       q1 <= q0;
     end
     if (update_pipe[2]) begin
       q2 <= q1;
     end
     if (update_pipe[3]) begin
       q3 <= q2;
     end
     if (update_pipe[4]) begin
       q4 <= q3;
     end

   end


endmodule

