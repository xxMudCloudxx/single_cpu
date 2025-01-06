`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: inst_rom.v
//   > 描述  ：异步指令存储器模块，采用寄存器搭建而成，类似寄存器堆
//   >         内嵌好指令，只读，异步读
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [4 :0] addr, // 指令地址
    output reg [31:0] inst       // 指令
    );

    wire [31:0] inst_rom[18:0];  // 指令存储器，字节地址7'b000_0000~7'b111_1111
    //------------- 指令编码 ---------|指令地址|--- 汇编指令 -----|- 指令结果 -----//
    assign inst_rom[ 0] = 32'h00000000; // 00H: nop (无操作)
    assign inst_rom[ 1] = 32'h00000000; // 04H: nop (无操作)
    assign inst_rom[ 2] = 32'h00000000; // 08H: nop (无操作)
    assign inst_rom[ 3] = 32'h00000000; // 0CH: nop (无操作)
    assign inst_rom[ 4] = 32'h24010000; // 10H: addiu $1, $1, 0    | $1 = $1 + 0(a)
    assign inst_rom[ 5] = 32'h24020000; // 14H: addiu $2, $2, 0    | $2 = $2 + 0(n)
    assign inst_rom[ 6] = 32'h20030000; // 18H: addi  $3, $0, 0    | result = 0 ($3)
    assign inst_rom[ 7] = 32'h20040000; // 1CH: addi  $4, $0, 0    | temp = 0 ($4)
    assign inst_rom[ 8] = 32'h20050001; // 20H: addi  $5, $0, 1    | counter = 1 ($5)
    assign inst_rom[ 9] = 32'h00042000; // 24H: sll   $4, $4, 2    | temp = temp * 4 (左移2位，相当于乘4)
    assign inst_rom[10] = 32'h00842020; // 28H: add   $4, $4, $1   | temp += a
    assign inst_rom[11] = 32'h00042000; // 2CH: sll   $4, $4, 1    | temp = temp * 2 (左移1位，相当于乘2)
    assign inst_rom[12] = 32'h00842020; // 30H: add   $4, $4, $1   | temp += a (完成 ×10)
    assign inst_rom[13] = 32'h00642820; // 34H: add   $3, $3, $4   | result += temp
    assign inst_rom[14] = 32'h20A50001; // 38H: addi  $5, $5, 1    | counter++
    assign inst_rom[15] = 32'h00A2082A; // 3CH: slt   $1, $5, $2   | if counter < n
    assign inst_rom[16] = 32'h1420FFFB; // 40H: bne   $1, $0, loop | 跳回24H
    assign inst_rom[17] = 32'hAC030008; // 44H: sw    $3, 8($0)    | 存储result至内存地址0x00000008
    assign inst_rom[18] = 32'h08000000; // 48H: j     00H          | 跳转到起始地址

    //读指令,取4字节
    always @(*)
    begin
        case (addr)
            5'd0 : inst <= inst_rom[0 ];
            5'd1 : inst <= inst_rom[1 ];
            5'd2 : inst <= inst_rom[2 ];
            5'd3 : inst <= inst_rom[3 ];
            5'd4 : inst <= inst_rom[4 ];
            5'd5 : inst <= inst_rom[5 ];
            5'd6 : inst <= inst_rom[6 ];
            5'd7 : inst <= inst_rom[7 ];
            5'd8 : inst <= inst_rom[8 ];
            5'd9 : inst <= inst_rom[9 ];
            5'd10: inst <= inst_rom[10];
            5'd11: inst <= inst_rom[11];
            5'd12: inst <= inst_rom[12];
            5'd13: inst <= inst_rom[13];
            5'd14: inst <= inst_rom[14];
            5'd14: inst <= inst_rom[15];
            5'd14: inst <= inst_rom[16];
            5'd14: inst <= inst_rom[17];
            5'd14: inst <= inst_rom[18];
            default: inst <= 32'd0;
        endcase
    end
endmodule