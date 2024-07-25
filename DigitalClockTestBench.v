`timescale 1ns / 1ps

module DigitalClockTestBench();

    // UUT inputs
    reg reset_n_i, clk_i;
    reg [1:0] h_i1;
    reg [3:0] h_i2, m_i1, m_i2;
    reg load_time_n_i, load_alarm_n_i, stop_alarm_n_i, alarm_on_n_i;

    // UUT outputs
    wire [1:0] h_o1;
    wire [3:0] h_o2, m_o1, m_o2, s_o1, s_o2;
    wire alarm_o;

    // UUT
    DigitalClock uut (
        clk_i, reset_n_i,
        h_i1,
        h_i2, m_i1, m_i2,
        load_time_n_i, load_alarm_n_i, stop_alarm_n_i, alarm_on_n_i,
        h_o1,
        h_o2, m_o1, m_o2, s_o1, s_o2,
        alarm_o
    );

    // Clock Generation
    always begin
        clk_i = 1'b0;
        #500;
        clk_i = 1'b1;
        #500;
    end

    initial begin
        repeat (100) #2000000;
        $finish;
    end

    initial begin
        reset_n_i = 1'b0;
        load_time_n_i = 1'b1;
        load_alarm_n_i = 1'b1;
        stop_alarm_n_i = 1'b1;
        alarm_on_n_i = 1'b1;
        @(negedge clk_i);
        reset_n_i = 1'b1;
        @(negedge clk_i);
        h_i1 = 2'd1;
        h_i2 = 4'd3;
        m_i1 = 4'd4;
        m_i2 = 4'd5;
        load_alarm_n_i = 1'b0;
        @(negedge clk_i);
        load_alarm_n_i = 1'b1;
        wait({h_o1, h_o2, m_o1, m_o2} == {2'd1, 4'd3, 4'd4, 4'd6});
        alarm_on_n_i = 1'b0;
        wait({h_o1, h_o2, m_o1, m_o2} == {2'd1, 4'd4, 4'd1, 4'd6});
        wait({h_o1, h_o2, m_o1, m_o2} == {2'd1, 4'd4, 4'd1, 4'd5});
        @(negedge clk_i);
        stop_alarm_n_i = 1'b0;
        @(negedge clk_i);
        stop_alarm_n_i = 1'b1;
        wait({h_o1, h_o2, m_o1, m_o2} == {2'd2, 4'd2, 4'd3, 4'd5});
        h_i1 = 2'd1;
        h_i2 = 4'd4;
        m_i1 = 4'd5;
        m_i2 = 4'd4;
        @(negedge clk_i);
        load_time_n_i = 1'b0;
        @(negedge clk_i);
        load_time_n_i = 1'b1;
    end

endmodule
