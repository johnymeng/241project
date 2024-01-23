module ddr (
  clk,
  reset_n,
  master_crtl_fixed_location,
  master_crtl_write_base,
  master_crtl_lenght,
  master_crtl_go,
  master_crtl_done,
  master_user_write_buffer,
  master_user_buffer_input_data,
  master_user_buffer_full,
  but0,
  led
);
  input    wire clk;
  input    wire reset_n;
  output    wire master_crtl_fixed_location;
  output    wire master_crtl_write_base;
  output    wire master_crtl_lenght;
  output    wire master_crtl_go;
  input    wire master_crtl_done;
  output    wire master_user_write_buffer;
  output    wire master_user_buffer_input_data;
  input    wire master_user_buffer_full;
  input    wire but0;
  output    wire  led;
  
  parameter   IDLE = 5'b00001, 
				  STATE1 = 5'b00010, 
				  STATE2 = 5'b00100, 
				  STATE3 = 5'b01000, 
				  STATE4 = 5'b10000;
				  
  reg         state_but    = 1;
  reg     state            = IDLE;
  
  reg dataToWrite;
  reg writeBuffer;
  reg startWriting;
  reg  led_int         = 4'b0000;
  reg startAddress        = 'h10000000;
  always @ (posedge clk) begin
    case(state)
       IDLE:     
            begin 
                if (but0 == 1 && but0 != state_but) state <= STATE1;
                //led_int = 4b'0000;
                if (led == 1) led_int <= 0;
            end        
        STATE1:    
            begin 
                dataToWrite <= 13;
                state <= STATE2;
                led_int <= 1;
            end
        STATE2:    
            begin 
                if (master_user_buffer_full != 1) writeBuffer <= 1;
                else writeBuffer <= 0;
                state <= STATE3;
                led_int <= 1;
            end
        STATE3:
            begin
                startWriting <= 1;
                //writeBuffer <= 0;
                state = STATE4;
                led_int <= 1;
            end
        STATE4:
            begin
                startWriting <= 0;
                if (master_crtl_done == 1) 
                    begin
                        state = IDLE;
                        startAddress <= startAddress + 1;
                    end
                led_int <= 1;
            end
     endcase
     
    state_but = but0;
  end
  
  assign master_crtl_fixed_location        = 0;
  assign master_crtl_write_base             = startAddress;
  assign master_crtl_lenght                = 4;
  assign master_user_buffer_input_data    = dataToWrite;
  assign master_user_write_buffer        = writeBuffer;
  assign master_crtl_go                     = startWriting;
  assign led                                    = led_int;
  
endmodule