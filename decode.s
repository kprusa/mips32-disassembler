# decodeTables.s	Provides subroutines for handling the decoding of instructions.
#
# Author: 		Kolbe Prusa

.data
.globl 	DECODE_UNIMPLEMENTED, DECODE_INVALID, DECODE_R
	DECODE_UNIMPLEMENTED:	.word 0xfffffff0
	DECODE_INVALID:		.word 0xfffffff1
	DECODE_R:		.word 0xfffffff2

.globl	DECODE_ERROR_UNIMPLEMENTED, DECODE_ERROR_INVALID
	DECODE_ERROR_UNIMPLEMENTED:	.asciiz 	"decode: unimplemented instruction: "
	DECODE_ERROR_INVALID:		.asciiz 	"decode: invalid instruction: "

.globl decode_errors
.align 2
decode_errors:
	.word DECODE_ERROR_UNIMPLEMENTED
	.word DECODE_ERROR_INVALID

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
	.word	DECODE_UNIMPLEMENTED	# 0 (000) addi
	.word	printIntHex		# 1 (001) addiu
	.word	DECODE_UNIMPLEMENTED	# 2 (010) slti
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sltiu
	.word	DECODE_UNIMPLEMENTED	# 4 (100) andi
	.word	DECODE_UNIMPLEMENTED	# 5 (101) ori
	.word	DECODE_UNIMPLEMENTED	# 6 (110) xori
	.word	DECODE_UNIMPLEMENTED	# 7 (111) lui

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
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.globl decode_4_jumpTable
.align 2
decode_4_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) lb
	.word	DECODE_UNIMPLEMENTED	# 1 (001) lh
	.word	DECODE_UNIMPLEMENTED	# 2 (010) lwl 
	.word	DECODE_UNIMPLEMENTED	# 3 (011) lw
	.word	DECODE_UNIMPLEMENTED	# 4 (100) lbu
	.word	DECODE_UNIMPLEMENTED	# 5 (101) lhu
	.word	DECODE_UNIMPLEMENTED	# 6 (110) lwr
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.globl decode_5_jumpTable
.align 2
decode_5_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) sb
	.word	DECODE_UNIMPLEMENTED	# 1 (001) sh
	.word	DECODE_UNIMPLEMENTED	# 2 (010) swl 
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sw
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
	.word	DECODE_UNIMPLEMENTED	# 0 (000) sll
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 2 (010) srl
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sra
	.word	DECODE_UNIMPLEMENTED	# 4 (100) sllv
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.word	DECODE_UNIMPLEMENTED	# 6 (110) srlv
	.word	DECODE_UNIMPLEMENTED	# 7 (111) srav
	
.globl decode_R_1_jumpTable
.align 2
decode_R_1_jumpTable:			# Jump table for bits 28DECODE_UNIMPLEMENTED6
	.word	DECODE_UNIMPLEMENTED	# 0 (000) jr
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
##########################################################################
#
#	Finds the decoder the the supplied instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#
#	Results:
#		- $v0 =	Address of instruction decoder.
#		- $v1 = Error value (0 if no error)
#
##########################################################################
.globl decoderLookup
decoderLookup:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	addi	$sp, $sp, -20
	########################
	la	$s0, ($a0)
	
	srl	$s1, $s0, 26			# ($s1) = Instruction opcode.
	srl	$s2, $s1, 3			# ($s2) = Bits 31-29 of instruction.
	and	$s1, $s1, 0x7                  	# ($s1) = Bits 28-26 of instruction.
	
	sll	$s2, $s2, 2			# Word align for index
	sll	$s1, $s1, 2
	
	lw	$v0, decode_jumpTable($s2)	# Get initial jump table address for instruction decode.
	addu	$v0, $v0, $s1			# Calculate index of final lookup.
	lw	$v0, ($v0)			# Load address of instruction decoder.
	
	la	$t1, DECODE_R
	bne	$v0, $t1, decoderLookup_errorHandling	# Check if instruction is R-format; if so, use funct code for decoder lookup.
	and	$s1, $s0, 0x3f			# ($s1) = Bits 5-0 of instruction
	srl	$s2, $s1, 3			# ($s2) = Bits 5-3 of instruction.
	and	$s1, $s1, 0x7                  	# ($s1) = Bits 2-0 of instruction.
	
	sll	$s2, $s2, 2			# Word align for index
	sll	$s1, $s1, 2
	
	lw	$v0, decode_R_jumpTable($s2)
	addu	$v0, $v0, $s1			# Calculate index of final lookup.
	lw	$v0, ($v0)
decoderLookup_errorHandling:
	andi	$t0, $v0, 0x10000000		# Check if lookup is in data segment; if so, it is an error type.
	bne	$t0, 0x10000000, decoderLookup_noError
	lw	$v0, ($v0)

	bltu	$v0, 0xfffffff0, decoderLookup_noError
	and	$v0, $v0, 0x0000000f
	sll	$v0, $v0, 2
	lw	$v1, decode_errors($v0)
	j	decoderLookup_return
decoderLookup_noError:
	la	$v1, ($zero)
decoderLookup_return:
	########################		# Restore protected registers. 
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################
