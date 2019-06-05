  `define pipeFlow(in_name, out_name, num_stages) \
     static    logic [``num_stages``-1:0] stage_valid = '0; \
     automatic logic [``num_stages``-1:0] update_pipe = '0; \
     automatic logic update_regs = ``out_name``_rdy; \
     static logic rdy_switch = 1; \
\
     if (``num_stages`` > 1) begin \
       for(int i=``num_stages``-1; i>0; i--) begin \
         if (!update_regs) begin \
           update_regs = !stage_valid[i]; \
         end else begin \
           stage_valid[i] = stage_valid[i-1]; \
           update_pipe[i] = 1; \
         end \
       end \
     end \
\
     if ((update_regs) | (~stage_valid[0])) begin \
       if (rdy_switch) begin \
         `ifdef DISABLE_PIPELINING \
           rdy_switch <= !(``in_name``_valid & ``in_name``_rdy); \
         `endif \
         stage_valid[0] = ``in_name``_valid; \
         update_pipe[0] = ``in_name``_valid; \
       end \
       else begin \
         stage_valid[0] = 0; \
         update_pipe[0] = 0; \
       end \
\
     end \
\
     if (``out_name``_rdy & ``out_name``_valid) begin \
       rdy_switch = 1; \
     end \
\
     ``in_name``_rdy    <= (``out_name``_rdy | ~(stage_valid == '1)) & rdy_switch; \
     ``out_name``_valid <= stage_valid[``num_stages``-1];

  `define delayFlow(in_name, out_name, num_stages) \
     logic [``num_stages``-1:0] stage_valid = '0; \
\
  stage_valid[0] <= (``in_name``_rdy  & ``in_name``_valid); \
\
  if (!(stage_valid[``num_stages``-1] & (!``out_name``_rdy))) begin \
    for (int i=1; i<``num_stages``; i++) begin \
      stage_valid[i] <= stage_valid[i-1]; \
    end \
  end \
\
  ``in_name``_rdy <= !(stage_valid | (``in_name``_rdy  & ``in_name``_valid)); \
  ``out_name``_valid <= stage_valid[``num_stages``-1];
