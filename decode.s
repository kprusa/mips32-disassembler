# decodeTables.s	Provides subroutines for handling the decoding of instructions.
#
# Author: 		Kolbe Prusa

.data
DECODE_UNIMPLEMENTED:	.word 0xfffffff0
DECODE_INVALID:		.word 0xfffffff1
DECODE_R:		.word 0xfffffff2

DECODE_ERROR_UNIMPLEMENTED:	.asciiz 	"decode: unimplemented instruction: "
DECODE_ERROR_INVALID:		.asciiz 	"decode: invalid instruction: "

.align 2
decode_errors:
	.word DECODE_ERROR_UNIMPLEMENTED
	.word DECODE_ERROR_INVALID

.align 2
decode_jumpTable:			# Jump table for bits 31-29 of instruction
	.word	decode_0_jumpTable	# 0 (000)
	.word	decode_1_jumpTable	# 1 (001)
	.word	decode_2_jumpTable	# 2 (010)
	.word	decode_3_jumpTable	# 3 (011)
	.word	decode_4_jumpTable	# 4 (100)
	.word	decode_5_jumpTable	# 5 (101)
	.word	decode_6_jumpTable	# 6 (110)
	.word	decode_7_jumpTable	# 7 (111)

.align 	4
decode_0_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_R    		# 0 (000) R-format
	.align 	4
	.word	DECODE_UNIMPLEMENTED    # 1 (001) bltz
	.align 	4
	.word	printString		# 2 (010) j				# Implement
	.asciiz	"j"
	.align 	4
	.word	printString		# 3 (011) jal				# Implement
	.asciiz	"jal"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) beq
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 5 (101) bne
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) blez 
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 7 (111) bgtz
	
.align 	4
decode_1_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	printString		# 0 (000) addi				# Implement
	.asciiz	"addi"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) addiu
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) slti
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sltiu
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) andi
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 5 (101) ori
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) xori
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 7 (111) lui

.align 	4
decode_2_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) TLB
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) FlPt
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_3_jumpTable:			#  Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.align 	4
decode_4_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) lb
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) lh
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) lwl 
	.align 	4
	.word	printString		# 3 (011) lw				# Implement
	.asciiz	"lw"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) lbu
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 5 (101) lhu
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) lwr
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_5_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) sb
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) sh
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) swl 
	.align 	4
	.word	printString		# 3 (011) sw				# Implement
	.asciiz	"sw"
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) swr
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_6_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) load linked word
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) lwc1
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_7_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) store cond. word
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) swc1
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

########################################
	
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

.align 	4
decode_R_0_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) sll
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) srl
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) sra
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) sllv
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) srlv
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 7 (111) srav
	
.align 	4
decode_R_1_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	printString		# 0 (000) jr				# Implement
	.asciiz	"jr"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) jalr
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) syscall
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 5 (101) break
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_R_2_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 0 (000) mfhi
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) mthi
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) mflo
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) mtlo
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_R_3_jumpTable:			#  Jump table for bits 28-26 of instruction
	.align 	4
	.word	printString		# 0 (000) mul				# Implement
	.asciiz	"mul"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) mulu
	.align 	4
	.word	printString		# 2 (010) div				# Implement
	.asciiz	"div"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) divu
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.align 	4
decode_R_4_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	printString		# 0 (000) add				# Implement
	.asciiz	"add"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) addu
	.align 	4
	.word	printString		# 2 (010) sub				# Implement
	.asciiz	"sub"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) subu
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 4 (100) and
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 5 (101) or
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) xor
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 7 (111) not or (nor)

.align 	4
decode_R_5_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 2 (010) set l.t
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 3 (011) se l.t. unsigned
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_R_6_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
decode_R_7_jumpTable:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.text
##########################################################################
#
#	Finds the decoder for the supplied instruction.
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
	
	sll	$s2, $s2, 2			# Word align for initial index.
	sll	$s1, $s1, 4			# Word align for second index.
	
	lw	$v0, decode_jumpTable($s2)	# Get initial jump table address for instruction decode.
	addu	$v0, $v0, $s1			# Calculate address of decoder.
	# lw	$v0, ($v0)			# Load address of instruction decoder.

	lw	$t2, ($v0)			# Load address of instruction decoder.
	
	la	$t1, DECODE_R
	bne	$t2, $t1, decoderLookup_errorHandling	# Check if instruction is R-format; if so, use funct code for decoder lookup.
	and	$s1, $s0, 0x3f			# ($s1) = Bits 5-0 of instruction
	srl	$s2, $s1, 3			# ($s2) = Bits 5-3 of instruction.
	and	$s1, $s1, 0x7                  	# ($s1) = Bits 2-0 of instruction.
	
	sll	$s2, $s2, 2			# Word align for initial index.
	sll	$s1, $s1, 4			# Word align for second index.
	
	lw	$v0, decode_R_jumpTable($s2)
	addu	$v0, $v0, $s1			# Calculate address of decoder.
	# lw	$v0, ($v0)
	lw	$t2, ($v0)			# Load address of instruction decoder.
decoderLookup_errorHandling:
	andi	$t0, $t2, 0x10000000		# Check if lookup is in data segment; if so, it is an error type.
	bne	$t0, 0x10000000, decoderLookup_noError
	lw	$t2, ($t2)

	bltu	$t2, 0xfffffff0, decoderLookup_noError
	and	$t2, $t2, 0x0000000f
	sll	$t2, $t2, 2
	lw	$v1, decode_errors($t2)
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
