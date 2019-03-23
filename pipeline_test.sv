//`include "random_test.sv"

module tbench_top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;

  logic [4:0] output_val;
  logic       output_valid;
  logic       output_rdy;

  logic [4:0] input_val;
  logic       input_valid;
  logic       input_rdy;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    reset = 1;
    #5 reset =0;
  end

  initial begin
    input_val = 0;
    input_valid = 2;
    output_rdy = 1;
    #10
    @(posedge clk)
    input_valid = 1;
    @(posedge clk)
    input_valid = 0;
    end
    
  
  //DUT instance, interface signals are connected to the DUT ports
  pipeline DUT (

    .output_val(output_val),
    .output_valid(output_valid),
    .output_rdy(output_rdy),

    .input_val(input_val),
    .input_valid(input_valid),
    .input_rdy(input_rdy),

    .clk_i(clk),
    .reset_i(reset)
   );
  
endmodule
