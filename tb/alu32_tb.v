`timescale 1ns / 1ps

module alu32_tb;

    reg [31:0] A, B;
    reg [3:0] Op;
    wire [31:0] Result;
    wire CarryOut, Overflow, Zero;

    alu32 uut (
        .A(A),
        .B(B),
        .Op(Op),
        .Result(Result),
        .CarryOut(CarryOut),
        .Overflow(Overflow),
        .Zero(Zero)
    );

    parameter SP = "   ";   // spacing between columns

    task print_row;
        input integer idx;
        input [31:0] expected;
        begin
            $display("%0d%s%h%s%h%s%04b%s%h%s%b%s%b%s%b",
                idx, SP,
                A, SP,
                B, SP,
                Op, SP,
                expected, SP,
                CarryOut, SP,
                Zero, SP,
                Overflow
            );
        end
    endtask

    initial begin

        // Header (manually formatted)
        $display("#   A          B          Op     Expected   CO  Z   OV");

        // Tests

        A = 32'h3C0F_A5B2; B = 32'h0FF0_5A4D; Op = 4'b0000; #20;
        print_row(1, 32'h0C00_0000);

        Op = 4'b0001; #20;
        print_row(2, 32'h3FFF_FFFF);

        B = 32'h50A3_C271; Op = 4'b0010; #20;
        print_row(3, 32'h8CB3_6823);

        Op = 4'b0110; #20;
        print_row(4, 32'hEB6B_E341);

        Op = 4'b0111; #20;
        print_row(5, 32'h0000_0001);

        B = 32'h0FF0_5A4D; Op = 4'b1100; #20;
        print_row(6, 32'hC000_0000);

        A = 32'hABCD_1234; B = 32'hABCD_1234; Op = 4'b1111; #20;
        print_row(7, 32'h0000_0001);

        B = 32'h1234_5678; #20;
        print_row(8, 32'h0000_0000);

        $stop;
    end

endmodule