`timescale 1ns / 1ps

module DigitalClock(
    input clk_i, // 1Hz Clock
    input reset_n_i,
    input [1:0] h_i1,
    input [3:0] h_i2, m_i1, m_i2,
    input load_time_n_i, load_alarm_n_i, stop_alarm_n_i, alarm_on_n_i,
    output [1:0] h_o1,
    output [3:0] h_o2, m_o1, m_o2, s_o1, s_o2,
    output reg alarm_n_o
);

    // alarm time
    reg [1:0] alarm_h_1;
    reg [3:0] alarm_h_2, alarm_m_1, alarm_m_2;

    // current time
    reg [1:0] current_time_h_1;
    reg [3:0] current_time_h_2, current_time_m_1, current_time_m_2, current_time_s_1, current_time_s_2;

    // Load Alarm Time or Load Current Time
    always @(posedge clk_i, negedge reset_n_i) begin
        if(~reset_n_i) begin
            // Reset Alarm Time
            alarm_h_1 <= 2'd0;
            alarm_h_2 <= 4'd0;
            alarm_m_1 <= 4'd0;
            alarm_m_2 <= 4'd0;
            // Reset Current Time
            current_time_h_1 <= 2'd0;
            current_time_h_2 <= 4'd0;
            current_time_m_1 <= 4'd0;
            current_time_m_2 <= 4'd0;
            current_time_s_1 <= 4'd0;
            current_time_s_2 <= 4'd0;
        end
        else begin
            if(~load_time_n_i) begin
                // Load Current Time
                current_time_h_1 <= h_i1;
                current_time_h_2 <= h_i2;
                current_time_m_1 <= m_i1;
                current_time_m_2 <= m_i2;
                current_time_s_1 <= 4'd0;
                current_time_s_2 <= 4'd0;
            end
            else begin
                if(~load_alarm_n_i) begin
                    // Load Alarm Time
                    alarm_h_1 <= h_i1;
                    alarm_h_2 <= h_i2;
                    alarm_m_1 <= m_i1;
                    alarm_m_2 <= m_i2;
                end
                // increment current time by one second
                current_time_s_2 <= current_time_s_2 + 4'd1;
                if(current_time_s_2 == 4'd9) begin
                    current_time_s_2 <= 4'd0;
                    current_time_s_1 <= current_time_s_1 + 4'd1;
                    if(current_time_s_1 == 4'd5) begin
                        current_time_s_1 <= 4'd0;
                        current_time_m_2 <= current_time_m_2 + 4'd1;
                        if(current_time_m_2 == 4'd9) begin
                            current_time_m_2 <= 4'd0;
                            current_time_m_1 <= current_time_m_1 + 4'd1;
                            if(current_time_m_1 == 4'd5) begin
                                current_time_m_1 <= 4'd0;
                                current_time_h_2 <= current_time_h_2 + 4'd1;
                                if((current_time_h_2 == 4'd9 && current_time_h_1 <= 4'd1) || (current_time_h_2 == 4'd4 && current_time_h_1 == 4'd2)) begin
                                    current_time_h_2 <= 4'd0;
                                    current_time_h_1 <= current_time_h_1 + 4'd1;
                                    if(current_time_h_1 == 4'd2) begin
                                        current_time_h_1 <= 4'd0;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    // Alarm
    always @(posedge clk_i, negedge reset_n_i) begin
        if(~reset_n_i) begin
            alarm_n_o <= 1'b1;
        end
        else begin
            if(({current_time_h_1, current_time_h_2, current_time_m_1, current_time_m_2} == {alarm_h_1, alarm_h_2, alarm_m_1, alarm_m_2}) && ~alarm_on_n_i) begin
                alarm_n_o <= 1'b0;
            end
            if(~stop_alarm_n_i) begin
                alarm_n_o <= 1'b1;
            end
        end
    end

    // Assigning outputs
    assign h_o1 = current_time_h_1;
    assign h_o2 = current_time_h_2;
    assign m_o1 = current_time_m_1;
    assign m_o2 = current_time_m_2;
    assign s_o1 = current_time_s_1;
    assign s_o2 = current_time_s_2;

endmodule
