module predictor_trigger_control (	input 		clock,
												output reg	latch_trigger,
												output reg	update_trigger,
												output reg	predict_trigger);
	integer i = 0;				
	always @ (posedge clock) begin
		i = i + 1;
		if (i == 1) begin
			latch_trigger <= clock;
			update_trigger <= 0;
			predict_trigger <= 0;
		end
		
		if (i == 2) begin
			latch_trigger <= 0;
			update_trigger <= clock;
			predict_trigger <= 0;
		end
		
		if (i == 3) begin
			latch_trigger <= 0;
			update_trigger <= 0;
			predict_trigger <= clock;
		end
		
		if (i == 4) begin
			i = 0;
			latch_trigger <= 0;
			update_trigger <= 0;
			predict_trigger <= 0;
		end
	end
	
endmodule
