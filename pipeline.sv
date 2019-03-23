
module pipeline
(
     output logic [4:0] output_val,
     output logic       output_valid,
     input  logic       output_rdy,

     input  logic [4:0] input_val,
     input  logic       input_valid,
     output logic       input_rdy,

     input  logic       clk_i,
     input  logic       reset_i
);

   logic [4:0] q0, q1, q2, q3, q4;

   //   [] -> [] -> [] -> [] -> [] ->
   parameter NUM_STAGES = 5;

   always_ff @(posedge clk_i)
   begin

     static    logic [NUM_STAGES-1:0] stage_valid = '0;
     automatic logic [NUM_STAGES-1:0] update_pipe = '0;
     automatic logic update_regs = output_rdy;

     if (NUM_STAGES > 1) begin
       for(int i=NUM_STAGES-1; i>0; i--) begin
         if (!update_regs) begin 
           update_regs = !stage_valid[i];
         end else begin
           stage_valid[i] = stage_valid[i-1];
           update_pipe[i] = 1;
         end
       end
     end

     if ((update_regs) || (!stage_valid[0])) begin
       stage_valid[0] = input_valid;
       update_pipe[0] = input_valid;
     end

     input_rdy    <= output_rdy || !(stage_valid == '1);
     output_valid <= stage_valid[NUM_STAGES-1];

     if (update_pipe[0]) begin
       q0 <= input_val + 1;
     end
     if (update_pipe[1]) begin
       q1 <= q0 + 1;
     end
     if (update_pipe[2]) begin
       q2 <= q1 + 1;
     end
     if (update_pipe[3]) begin
       q3 <= q2 + 1;
     end
     if (update_pipe[4]) begin
       q4 <= q3 + 1;
     end

   end


endmodule

