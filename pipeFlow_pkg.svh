  `define pipeFlow(name, num_stages) \
     static    logic [``num_stages``-1:0] stage_valid = '0; \
     automatic logic [``num_stages``-1:0] update_pipe = '0; \
     automatic logic update_regs = ``name``_out_rdy; \
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
     if ((update_regs) || (!stage_valid[0])) begin \
       stage_valid[0] = ``name``_in_valid; \
       update_pipe[0] = ``name``_in_valid; \
     end \
\
     ``name``_in_rdy    <= ``name``_out_rdy || !(stage_valid == '1); \
     ``name``_out_valid <= stage_valid[``num_stages``-1];