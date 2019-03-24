//`include "random_test.sv"

module tbench_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;

  logic [4:0] output_val;
  logic       out_valid;
  logic       out_rdy;

  logic [4:0] input_val;
  logic       in_valid;
  logic       in_rdy;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end

  initial begin
    input_val = 0;
    in_valid = 2;
    out_rdy = 1;
    #10
    @(posedge clk)
    in_valid = 1;
    @(posedge clk)
    in_valid = 0;
    end
    
  
  //DUT instance, interface signals are connected to the DUT ports
  pipeline DUT (

    .output_val(output_val),
    .pipe_out_valid(out_valid),
    .pipe_out_rdy(out_rdy),

    .input_val(input_val),
    .pipe_in_valid(in_valid),
    .pipe_in_rdy(in_rdy),

    .clk_i(clk),
    .reset_i(reset)
   );
  
endmodule
