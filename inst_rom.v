`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: inst_rom.v
//   > ����  ���첽ָ��洢��ģ�飬���üĴ�������ɣ����ƼĴ�����
//   >         ��Ƕ��ָ�ֻ�����첽��
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [4 :0] addr, // ָ���ַ
    output reg [31:0] inst       // ָ��
    );

    wire [31:0] inst_rom[18:0];  // ָ��洢�����ֽڵ�ַ7'b000_0000~7'b111_1111
    //------------- ָ����� ---------|ָ���ַ|--- ���ָ�� -----|- ָ���� -----//
    assign inst_rom[ 0] = 32'h00000000; // 00H: nop (�޲���)
    assign inst_rom[ 1] = 32'h00000000; // 04H: nop (�޲���)
    assign inst_rom[ 2] = 32'h00000000; // 08H: nop (�޲���)
    assign inst_rom[ 3] = 32'h00000000; // 0CH: nop (�޲���)
    assign inst_rom[ 4] = 32'h24010000; // 10H: addiu $1, $1, 0    | $1 = $1 + 0(a)
    assign inst_rom[ 5] = 32'h24020000; // 14H: addiu $2, $2, 0    | $2 = $2 + 0(n)
    assign inst_rom[ 6] = 32'h20030000; // 18H: addi  $3, $0, 0    | result = 0 ($3)
    assign inst_rom[ 7] = 32'h20040000; // 1CH: addi  $4, $0, 0    | temp = 0 ($4)
    assign inst_rom[ 8] = 32'h20050001; // 20H: addi  $5, $0, 1    | counter = 1 ($5)
    assign inst_rom[ 9] = 32'h00042000; // 24H: sll   $4, $4, 2    | temp = temp * 4 (����2λ���൱�ڳ�4)
    assign inst_rom[10] = 32'h00842020; // 28H: add   $4, $4, $1   | temp += a
    assign inst_rom[11] = 32'h00042000; // 2CH: sll   $4, $4, 1    | temp = temp * 2 (����1λ���൱�ڳ�2)
    assign inst_rom[12] = 32'h00842020; // 30H: add   $4, $4, $1   | temp += a (��� ��10)
    assign inst_rom[13] = 32'h00642820; // 34H: add   $3, $3, $4   | result += temp
    assign inst_rom[14] = 32'h20A50001; // 38H: addi  $5, $5, 1    | counter++
    assign inst_rom[15] = 32'h00A2082A; // 3CH: slt   $1, $5, $2   | if counter < n
    assign inst_rom[16] = 32'h1420FFFB; // 40H: bne   $1, $0, loop | ����24H
    assign inst_rom[17] = 32'hAC030008; // 44H: sw    $3, 8($0)    | �洢result���ڴ��ַ0x00000008
    assign inst_rom[18] = 32'h08000000; // 48H: j     00H          | ��ת����ʼ��ַ

    //��ָ��,ȡ4�ֽ�
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