# decodeTables.s	Provides subroutines for handling the decoding of instructions.
#
# Author: 		Kolbe Prusa

.data
.globl DECODE_UNIMPLEMENTED, DECODE_INVALID, DECODE_R
	DECODE_UNIMPLEMENTED:	.word -2
	DECODE_INVALID:		.word -1
	DECODE_R:		.word 0

.globl decode_jumpTable
.align 2
decode_jumpTable:			# Jump table for bits 31DECODE_UNIMPLEMENTED9
	.word	decode_0_jumpTable	# 0 (000)
	.word	decode_1_jumpTable	# 1 (001)
	.word	decode_2_jumpTable	# 2 (010)
	.word	decode_3_jumpTable	# 3 (011)
	.word	decode_4_jumpTable	# 4 (100)
	.word	decode_5_jumpTable	# 5 (101)
	.word	decode_6_jumpTable	# 6 (110)
	.word	decode_7_jumpTable	# 7 (111)

.globl decode_0_jumpTable
.align 2
decode_0_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_R    		# 0 (000) R-format
	.word	DECODE_UNIMPLEMENTED    # 1 (001) Bltz/gez
	.word	DECODE_UNIMPLEMENTED	# 2 (010) jump
	.word	DECODE_UNIMPLEMENTED	# 3 (011) jump & link
	.word	DECODE_UNIMPLEMENTED	# 4 (100) branch eq
	.word	DECODE_UNIMPLEMENTED	# 5 (101) branch ne
	.word	DECODE_UNIMPLEMENTED	# 6 (110) blez 
	.word	DECODE_UNIMPLEMENTED	# 7 (111) bgtz
	
.globl decode_1_jumpTable
.align 2
decode_1_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) add immediate
	.word	DECODE_UNIMPLEMENTED	# 1 (001) addiu
	.word	DECODE_UNIMPLEMENTED	# 2 (010) set less than imm.
	.word	DECODE_UNIMPLEMENTED	# 3 (011) set less than imm. unsigned
	.word	DECODE_UNIMPLEMENTED	# 4 (100) andi
	.word	DECODE_UNIMPLEMENTED	# 5 (101) ori
	.word	DECODE_UNIMPLEMENTED	# 6 (110) xori
	.word	DECODE_UNIMPLEMENTED	# 7 (111) load upper immediate

.globl decode_2_jumpTable
.align 2
decode_2_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) TLB
	.word	DECODE_UNIMPLEMENTED	# 1 (001) FlPt
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_3_jumpTable
.align 2
decode_3_jumpTable:			#  Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) load byte 
	.word	DECODE_UNIMPLEMENTED	# 1 (001) load half 
	.word	DECODE_UNIMPLEMENTED	# 2 (010) lwl 
	.word	DECODE_UNIMPLEMENTED	# 3 (011) load word 
	.word	DECODE_UNIMPLEMENTED	# 4 (100) load byte unsigned
	.word	DECODE_UNIMPLEMENTED	# 5 (101) load half unsigned
	.word	DECODE_UNIMPLEMENTED	# 6 (110) lwr
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.globl decode_4_jumpTable
.align 2
decode_4_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	0x0			# 0 (000) R-format
	.word	DECODE_UNIMPLEMENTED	# 1 (001) Bltz/gez
	.word	DECODE_UNIMPLEMENTED	# 2 (010) jump
	.word	DECODE_UNIMPLEMENTED	# 3 (011) jump & link
	.word	DECODE_UNIMPLEMENTED	# 4 (100) branch eq
	.word	DECODE_UNIMPLEMENTED	# 5 (101) branch ne
	.word	DECODE_UNIMPLEMENTED	# 6 (110) blez 
	.word	DECODE_UNIMPLEMENTED	# 7 (111) bgtz

.globl decode_5_jumpTable
.align 2
decode_5_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) store byte 
	.word	DECODE_UNIMPLEMENTED	# 1 (001) store half 
	.word	DECODE_UNIMPLEMENTED	# 2 (010) swl 
	.word	DECODE_UNIMPLEMENTED	# 3 (011) store word
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 6 (110) swr
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_6_jumpTable
.align 2
decode_6_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) load linked word
	.word	DECODE_UNIMPLEMENTED	# 1 (001) lwc1
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_7_jumpTable
.align 2
decode_7_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) store cond. word
	.word	DECODE_UNIMPLEMENTED	# 1 (001) swc1
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

########################################
	
.globl decode_R_jumpTable
.align 2
decode_R_jumpTable:			# Jump table for R-Format instructions.
	.word	decode_R_0_jumpTable	# 0 (000)
	.word	decode_R_1_jumpTable	# 1 (001)
	.word	decode_R_2_jumpTable	# 2 (010)
	.word	decode_R_3_jumpTable	# 3 (011)
	.word	decode_R_4_jumpTable	# 4 (100)
	.word	decode_R_5_jumpTable	# 5 (101)
	.word	decode_R_6_jumpTable	# 6 (110)
	.word	decode_R_7_jumpTable	# 7 (111)

.globl decode_R_0_jumpTable
.align 2
decode_R_0_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) shift left logical
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 2 (010) shift right logical
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sra
	.word	DECODE_UNIMPLEMENTED	# 4 (100) sllv
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 6 (110) srlv
	.word	DECODE_UNIMPLEMENTED	# 7 (111) srav
	
.globl decode_R_1_jumpTable
.align 2
decode_R_1_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) jump register
	.word	DECODE_UNIMPLEMENTED	# 1 (001) jalr
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 4 (100) syscall
	.word	DECODE_UNIMPLEMENTED	# 5 (101) break
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_R_2_jumpTable
.align 2
decode_R_2_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) mfhi
	.word	DECODE_UNIMPLEMENTED	# 1 (001) mthi
	.word	DECODE_UNIMPLEMENTED	# 2 (010) mflo
	.word	DECODE_UNIMPLEMENTED	# 3 (011) mtlo
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_R_3_jumpTable
.align 2
decode_R_3_jumpTable:			#  Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) mult
	.word	DECODE_UNIMPLEMENTED	# 1 (001) multu
	.word	DECODE_UNIMPLEMENTED	# 2 (010) div
	.word	DECODE_UNIMPLEMENTED	# 3 (011) divu
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.globl decode_R_4_jumpTable
.align 2
decode_R_4_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) add
	.word	DECODE_UNIMPLEMENTED	# 1 (001) addu
	.word	DECODE_UNIMPLEMENTED	# 2 (010) subtract
	.word	DECODE_UNIMPLEMENTED	# 3 (011) subu
	.word	DECODE_UNIMPLEMENTED	# 4 (100) and
	.word	DECODE_UNIMPLEMENTED	# 5 (101) or
	.word	DECODE_UNIMPLEMENTED	# 6 (110) xor
	.word	DECODE_UNIMPLEMENTED	# 7 (111) not or (nor)

.globl decode_R_5_jumpTable
.align 2
decode_R_5_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 2 (010) set l.t
	.word	DECODE_UNIMPLEMENTED	# 3 (011) se l.t. unsigned
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_R_6_jumpTable
.align 2
decode_R_6_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_R_7_jumpTable
.align 2
decode_R_7_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.text
