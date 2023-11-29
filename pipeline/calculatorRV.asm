MAIN:
	lui  s1, 0xFFFFF
	lw  s0, 0x70(s1)
	sw  s0, 0x60(s1)
	lui t0, 0x00E00
	and  t1, s0, t0  	#取操作符
	srli  t2, s0, 8
	andi  t2, t2, 0x0FF  	#取操作数A
	andi  t3, s0, 0x0FF  	#取操作数B
	lui  a0, 0x00000
	lui  a1, 0x00200
	lui  a2, 0x00400
	lui  a3, 0x00600
	lui  a4, 0x00800
	lui  a5, 0x00A00
	lui  a6, 0x00C00
	beq  t1, a0, AND	#A & B
	beq  t1, a1, OR	#A | B
	beq  t1, a2, XOR	#A ^ B
	beq  t1, a3, SLL	#A << B
	beq  t1, a4, SRA	#A >> B（算术右移）
	beq  t1, a5, ZERO	#(A==0) ? B : [B]补
	beq  t1, a6, DEV	#A / B
AND:
	and  s0, t2, t3
	jal  DISPLAY
OR:
	or  s0, t2, t3
	jal  DISPLAY
XOR:
	xor  s0, t2, t3
	jal  DISPLAY
SLL:
	sll  s0, t2, t3
	jal  DISPLAY
SRA:
	andi  s0, t2, 0x080  	#保留操作数A的符号位
	sub  t2, t2, s0
	sra  t2, t2, t3
	add  s0, s0, t2
	jal  DISPLAY
ZERO:
	add  s0, zero, t3
	beq  t2, zero, DISPLAY
	andi  t4, t3, 0x080  	#取操作数B的符号位
	beq  t4, zero, DISPLAY
	sub  t3, t3, t4
	addi  t4, zero, 0x100
	sub  s0, t4, t3  	#求B的补码
	jal  DISPLAY
DEV:
	andi  t4, t2, 0x080	#取操作数A的符号位
	andi  t5, t3, 0x080	#取操作数B的符号位
	sub  t2, t2, t4	#求操作数A的绝对值
	sub  t3, t3, t5	#求操作数B的绝对值
	slli  t3, t3, 6	#令除数的最低位与被除数的最高位对齐
	add  s0, zero, zero
	add  a0, zero, zero	#移位计数器
	addi  a1, zero, 6	#一共需要移位6次
	LOOP:
		sub  t2, t2, t3
	JUDGE:
		blt  t2, zero, MINUS
		addi  s0, s0, 1	#余数为正，上商1
		beq  a0, a1, END
		slli  s0, s0, 1
		slli  t2, t2, 1
		addi  a0, a0, 1
		jal LOOP
	MINUS:
		beq  a0, a1, END
		slli  s0, s0, 1
		slli  t2, t2, 1
		addi  a0, a0, 1
		add  t2, t2, t3
		jal JUDGE
	END:
		beq  t4, t5, DISPLAY
		addi  s0, s0, 0x080	#若两操作数符号不同，则结果的符号位应为1
		jal  DISPLAY
DISPLAY:	
	andi  t0, s0, 0x001
	addi  t1, zero, 4
	addi  t2, zero, 28
	TRANS:
		srli  s0, s0, 1
		andi  t3, s0, 0x001
		sll  t3, t3, t1
		add  t0, t0, t3
		addi t1, t1, 4
		bge  t2, t1, TRANS
	sw  t0, 0x00(s1)
	jal MAIN
