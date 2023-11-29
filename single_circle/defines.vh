// Annotate this macro before synthesis
//`define RUN_TRACE

// TODO: 在此处定义你的宏
//npc_op
`define NPC_PC4 2'b00       //NPC部件输出PC+4作为下一条指令地址
`define NPC_BRN 2'b01       //NPC部件根据ALU标志位确定下一条指令地址
`define NPC_JMP 2'b10       //NPC部件输出PC+offset作为下一条指令地址

//npc_osel
`define OST_EXT 1'b0        //选择符号扩展后的立即数作为偏移量
`define OST_ALU 1'b1        //选择ALU的运算结果作为偏移量

//rf_wsel
`define WB_ALU 2'b00        //将ALU的运算结果写回目的寄存器
`define WB_RAM 2'b01        //将从数据存储器中读出的数据写回目的寄存器
`define WB_PC4 2'b10        //将PC+4写回目的寄存器
`define WB_EXT 2'b11        //将扩展后的立即数写回目的寄存器

//sext_op
`define EXT_I 3'b000        //扩展I型指令中的立即数
`define EXT_S 3'b001        //扩展S型指令中的立即数
`define EXT_B 3'b010        //扩展B型指令中的立即数
`define EXT_U 3'b011        //扩展U型指令中的立即数
`define EXT_J 3'b100        //扩展J型指令中的立即数

//alu_op
`define ALU_ADD 4'b0000     //ALU执行加法运算
`define ALU_SUB 4'b0001     //ALU执行减法运算
`define ALU_LTU 4'b0010     //ALU执行无符号小于判断
`define ALU_GEU 4'b0011     //ALU执行无符号大于等于判断
`define ALU_EQ 4'b0100      //ALU执行等于判断
`define ALU_NE 4'b0101      //ALU执行不等判断
`define ALU_LT 4'b0110      //ALU执行有符号小于判断
`define ALU_GE 4'b0111      //ALU执行有符号大于等于判断
`define ALU_AND 4'b1000     //ALU执行并运算
`define ALU_OR  4'b1001     //ALU执行或运算
`define ALU_XOR 4'b1010     //ALU执行异或运算
`define ALU_SLL 4'b1100     //ALU执行逻辑左移
`define ALU_SRL 4'b1101     //ALU执行逻辑右移
`define ALU_SRA 4'b1110     //ALU执行算术右移

//alua_sel
`define ALUA_RS1 1'b0       //以寄存器rs1的值作为操作数A
`define ALUA_PC 1'b1        //以PC作为操作数A

//alub_sel
`define ALUB_RS2 1'b0       //以寄存器rs2的值作为操作数B
`define ALUB_EXT 1'b1       //以符号扩展后的立即数作为操作数B

//rw_op
`define RW_SB 3'b000        //按字节读写，做符号扩展
`define RW_UB 3'b100        //按字节读写，做零扩展
`define RW_SH 3'b001        //按半字读写，做符号扩展
`define RW_UH 3'b101        //按半字读写，做零扩展
`define RW_w 3'b010         //按字读写

// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
