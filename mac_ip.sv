
module mac_ip(
    input clk,
    input rst_n,
    input En,
    input Clr,
    input [7:0] Ain,
    input [7:0] Bin,
    output [23:0] Cout
);

    typedef enum reg {IDLE, ACC} state_t;
    state_t state, nxt_state;

    reg [23:0] CoutReg;
    logic [15:0] ab;
    logic acc;
    logic [23:0] dataa;
    logic [23:0] datab;
    logic [23:0] result;

    lpm_mult_ip iMULT(.dataa(Ain), .datab(Bin), .result(ab));

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
	    state <= IDLE;
        end
        else if (Clr) begin
    	    state <= IDLE;
        end
        else begin
	    state <= nxt_state;
        end
    end

    always_comb begin
	acc = 0; // Default
	nxt_state = state;

	case (state)
	    default : if(En) begin
		nxt_state = ACC;
	    end

	    ACC : if(!En) begin
		nxt_state = IDLE;
	    end else begin
		acc = 1;
	    end
	endcase
    end

    always_ff @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
	    CoutReg <= '0;
	    dataa <= '0;
	    datab <= '0;
	end else if (Clr) begin
	    CoutReg <= '0;
	    dataa <= '0;
	    datab <= '0;
	end else if (acc) begin
	    dataa <= CoutReg;
	    datab <= ab;
	    CoutReg <= result;
	end
    end

    lpm_add_sub_ip iADD(.dataa(dataa), .datab(datab), .result(result));
    assign Cout = result;

endmodule