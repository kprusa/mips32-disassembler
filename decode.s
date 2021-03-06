# decode.s		Provides subroutines for handling the decoding of MIPS-32 instructions.
#			
#			Decoding is performed by using lookup tables indexed by the upper 3 bits
#			of the instruction's opcode, then the lower 3 bits of the instruction's
#			opcode. The result of this lookup is the address of a decoder subroutine,
#			as well as the instructions mnemonic representation, offset by 4 bytes.
#
#			Once the decoder is known, it is executed, with the mnemonic instruction
#			string, 32-bit instruction, and instruction address as arguments.
#
#			The entry to this module is decodeInstruction, which performs the lookup
#			and executes the decoder, returning the string representation of the
#			instruction.
#
# Author: 		Kolbe Prusa

# The following constants are used to mark various states of the instruction lookup tables.
.data
#	The instruction is unimplemented (i.e., there is no decoder).
DECODE_UNIMPLEMENTED:	.word 0xfffffff0
#	The instruction is invalid (i.e., an instruction which is not a part of the MIPS-32 ISA.
DECODE_INVALID:		.word 0xfffffff1
#	The instruction is R-format, perform a lookup using funct code and R_lookupTable.
DECODE_R:		.word 0xfffffff2

# String representations of errors.
DECODE_ERROR_UNIMPLEMENTED:	.asciiz 	"decode: unimplemented instruction: "
DECODE_ERROR_INVALID:		.asciiz 	"decode: invalid instruction: "

# Used to separate instruction mnemonic from operands.
MNEMONIC_SEPARATOR:		.asciiz		"\t"

# Used to separate operands.
OPERATOR_SEPARATOR:		.asciiz		", "

# Constants for offset addressing.
BRACKET_LEFT:			.asciiz		"("
BRACKET_RIGHT:			.asciiz		")"

# Holds the decoded instruction.
.align 2
DECODED_INSTRUCTION_BUFFER:	.space		64
DECODED_INSTRUCTION_BUFFER_LEN:	.word		64

# Holds decoded int values for the instruction being decoded.
INT_CONVERSION_BUFFER:		.space		16
INT_CONVERSION_BUFFER_LEN:	.word		16

# Lookup table for obtaining error string from state constant.
.align 2
DECODE_LOOKUP_ERRORS:
	.word DECODE_ERROR_UNIMPLEMENTED
	.word DECODE_ERROR_INVALID

.align 2
DECODE_LOOKUP:			# Jump table for bits 31-29 of instruction
	.word	DECODE_0_LOOKUPTABLE	# 0 (000)
	.word	DECODE_1_LOOKUPTABLE	# 1 (001)
	.word	DECODE_2_LOOKUPTABLE	# 2 (010)
	.word	DECODE_3_LOOKUPTABLE	# 3 (011)
	.word	DECODE_4_LOOKUPTABLE	# 4 (100)
	.word	DECODE_5_LOOKUPTABLE	# 5 (101)
	.word	DECODE_6_LOOKUPTABLE	# 6 (110)
	.word	DECODE_7_LOOKUPTABLE	# 7 (111)

.align 	4
DECODE_0_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_R    		# 0 (000) R-format
	.align 	4
	.word	DECODE_UNIMPLEMENTED    # 1 (001) bltz
	.asciiz "bltz"
	.align 	4
	.word	decoderJ		# 2 (010) j				
	.asciiz	"j"
	.align 	4
	.word	decoderJ		# 3 (011) jal				
	.asciiz	"jal"
	.align 	4
	.word	decoderI_arith		# 4 (100) beq
	.asciiz "beq"
	.align 	4
	.word	decoderI_arith		# 5 (101) bne
	.asciiz "bne"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 6 (110) blez 
	.asciiz "blez"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 7 (111) bgtz
	.asciiz "bgtz"
	
.align 	4
DECODE_1_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	decoderI_arith		# 0 (000) addi				
	.asciiz	"addi"
	.align 	4
	.word	decoderI_arith		 # 1 (001) addiu
	.asciiz	"addiu"
	.align 	4
	.word	decoderI_arith		# 2 (010) slti
	.asciiz "slti"
	.align 	4
	.word	decoderI_arith		# 3 (011) sltiu
	.asciiz "sltiu"
	.align 	4
	.word	decoderI_arith		# 4 (100) andi
	.asciiz "andi"
	.align 	4
	.word	decoderI_arith		# 5 (101) ori
	.asciiz "ori"
	.align 	4
	.word	decoderI_arith		# 6 (110) xori
	.asciiz "xori"
	.align 	4
	.word	decoderI_arith		# 7 (111) lui
	.asciiz "lui"

.align 	4
DECODE_2_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
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
DECODE_3_LOOKUPTABLE:			#  Jump table for bits 28-26 of instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	decoderR_3Reg		# 4 (100) INVALID OPCODE
	.asciiz	"mul"
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.align 	4
DECODE_4_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	decoderI_loadStore 	# 0 (000) lb
	.asciiz "lb"
	.align 	4
	.word	decoderI_loadStore 	# 1 (001) lh
	.asciiz "lh"
	.align 	4
	.word	decoderI_loadStore 	# 2 (010) lwl 
	.asciiz "lwl"
	.align 	4
	.word	decoderI_loadStore 	# 3 (011) lw				
	.asciiz	"lw"
	.align 	4
	.word	decoderI_loadStore 	# 4 (100) lbu
	.asciiz "lbu"
	.align 	4
	.word	decoderI_loadStore 	# 5 (101) lhu
	.asciiz "lhu"
	.align 	4
	.word	decoderI_loadStore 	# 6 (110) lwr
	.asciiz "lwr"
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
DECODE_5_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	decoderI_loadStore 	# 0 (000) sb
	.asciiz "sb"
	.align 	4
	.word	decoderI_loadStore 	# 1 (001) sh
	.asciiz	"sh"
	.align 	4
	.word	decoderI_loadStore 	# 2 (010) swl 
	.asciiz	"swl"
	.align 	4
	.word	decoderI_loadStore 	# 3 (011) sw				
	.asciiz	"sw"
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	decoderI_loadStore 	# 6 (110) swr
	.asciiz "swr"
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
DECODE_6_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	decoderI_loadStore 	# 0 (000) ll
	.asciiz "ll"
	.align 	4
	.word	DECODE_UNIMPLEMENTED	# 1 (001) lwc1
	.asciiz "lwc1"
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
DECODE_7_LOOKUPTABLE:			# Jump table for bits 28-26 of instruction
	.align 	4
	.word	decoderI_loadStore 	# 0 (000) sc
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
DECODE_R_LOOKUP:			# Jump table for R-Format instructions.
	.word	DECODE_R_0_LOOKUPTABLE	# 0 (000)
	.word	DECODE_R_1_LOOKUPTABLE	# 1 (001)
	.word	DECODE_R_2_LOOKUPTABLE	# 2 (010)
	.word	DECODE_R_3_LOOKUPTABLE	# 3 (011)
	.word	DECODE_R_4_LOOKUPTABLE	# 4 (100)
	.word	DECODE_R_5_LOOKUPTABLE	# 5 (101)
	.word	DECODE_R_6_LOOKUPTABLE	# 6 (110)
	.word	DECODE_R_7_LOOKUPTABLE	# 7 (111)

.align 	4
DECODE_R_0_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
	.align 	4
	.word	decoderR_shamt		# 0 (000) sll
	.asciiz "sll"
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	decoderR_shamt		# 2 (010) srl
	.asciiz "srl"
	.align 	4
	.word	decoderR_shamt		# 3 (011) sra
	.asciiz "sra"
	.align 	4
	.word	decoderR_3Reg		# 4 (100) sllv
	.asciiz "sllv"
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	decoderR_3Reg		# 6 (110) srlv
	.asciiz "srlv"
	.align 	4
	.word	decoderR_3Reg		# 7 (111) srav
	.asciiz "srav"
	
.align 	4
DECODE_R_1_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
	.align 	4
	.word	decoderR_3Reg		# 0 (000) jr				
	.asciiz	"jr"
	.align 	4
	.word	decoderR_3Reg		# 1 (001) jalr
	.asciiz	"jalr"
	.align 	4
	.word	DECODE_INVALID		# 2 (010) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 3 (011) INVALID OPCODE
	.align 	4
	.word	decoder_mnemonic    	# 4 (100) syscall
	.asciiz	"syscall"
	.align 	4
	.word	decoder_mnemonic	# 5 (101) break
	.asciiz	"break"
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
DECODE_R_2_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
	.align 	4
	.word	decoderR_3Reg		# 0 (000) mfhi
	.asciiz "mfhi"
	.align 	4
	.word	decoderR_3Reg		# 1 (001) mthi
	.asciiz "mthi"
	.align 	4
	.word	decoderR_3Reg		# 2 (010) mflo
	.asciiz "mflo"
	.align 	4
	.word	decoderR_3Reg		# 3 (011) mtlo
	.asciiz "mtlo"
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
DECODE_R_3_LOOKUPTABLE:			#  Jump table for bits 2-0 of instruction
	.align 	4
	.word	decoderR_3Reg		# 0 (000) mult				
	.asciiz	"mult"
	.align 	4
	.word	decoderR_3Reg		# 1 (001) multu
	.asciiz "multu"
	.align 	4
	.word	decoderR_3Reg		# 2 (010) div				
	.asciiz	"div"
	.align 	4
	.word	decoderR_3Reg		# 3 (011) divu
	.asciiz "divu"
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE
					
.align 	4
DECODE_R_4_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
	.align 	4
	.word	decoderR_3Reg		# 0 (000) add				
	.asciiz	"add"
	.align 	4
	.word	decoderR_3Reg		# 1 (001) addu
	.asciiz "addu"
	.align 	4
	.word	decoderR_3Reg		# 2 (010) sub				
	.asciiz	"sub"
	.align 	4
	.word	decoderR_3Reg		# 3 (011) subu
	.asciiz "subu"
	.align 	4
	.word	decoderR_3Reg		# 4 (100) and
	.asciiz "and"
	.align 	4
	.word	decoderR_3Reg		# 5 (101) or
	.asciiz "or"
	.align 	4
	.word	decoderR_3Reg		# 6 (110) xor
	.asciiz "xor"
	.align 	4
	.word	decoderR_3Reg		# 7 (111) nor
	.asciiz "nor"

.align 	4
DECODE_R_5_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
	.align 	4
	.word	DECODE_INVALID		# 0 (000) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 1 (001) INVALID OPCODE
	.align 	4
	.word	decoderR_3Reg		# 2 (010) slt
	.asciiz "slt"
	.align 	4
	.word	decoderR_3Reg		# 3 (011) sltu
	.asciiz "sltu"
	.align 	4
	.word	DECODE_INVALID		# 4 (100) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 5 (101) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 6 (110) INVALID OPCODE
	.align 	4
	.word	DECODE_INVALID		# 7 (111) INVALID OPCODE

.align 	4
DECODE_R_6_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
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
DECODE_R_7_LOOKUPTABLE:			# Jump table for bits 2-0 of R-format instruction
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


.align 2
DECODE_REGISTER_LOOKUP:
	.align 3
	.asciiz "$zero"
	.align 3
	.asciiz "$at"
	.align 3
	.asciiz "$v0"
	.align 3
	.asciiz "$v1"
	.align 3
	.asciiz "$a0"
	.align 3
	.asciiz "$a1"
	.align 3
	.asciiz "$a2"
	.align 3
	.asciiz "$a3"
	.align 3
	.asciiz "$t0"
	.align 3
	.asciiz "$t1"
	.align 3
	.asciiz "$t2"
	.align 3
	.asciiz "$t3"
	.align 3
	.asciiz "$t4"
	.align 3
	.asciiz "$t5"
	.align 3
	.asciiz "$t6"
	.align 3
	.asciiz "$t7"
	.align 3
	.asciiz "$s0"
	.align 3
	.asciiz "$s1"
	.align 3
	.asciiz "$s2"
	.align 3
	.asciiz "$s3"
	.align 3
	.asciiz "$s4"
	.align 3
	.asciiz "$s5"
	.align 3
	.asciiz "$s6"
	.align 3
	.asciiz "$s7"
	.align 3
	.asciiz "$t8"
	.align 3
	.asciiz "$t9"
	.align 3
	.asciiz "$k0"
	.align 3
	.asciiz "$k1"
	.align 3
	.asciiz "$gp"
	.align 3
	.asciiz "$sp"
	.align 3
	.asciiz "$fp"
	.align 3
	.asciiz "$ra"
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
	
	lw	$v0, DECODE_LOOKUP($s2)	# Get initial jump table address for instruction decode.
	addu	$v0, $v0, $s1			# Calculate address of decoder.

	lw	$t2, ($v0)			# Load address of instruction decoder.
	
	la	$t1, DECODE_R
	bne	$t2, $t1, decoderLookup_errorHandling	# Check if instruction is R-format; if so, use funct code for decoder lookup.
	and	$s1, $s0, 0x3f			# ($s1) = Bits 5-0 of instruction
	srl	$s2, $s1, 3			# ($s2) = Bits 5-3 of instruction.
	and	$s1, $s1, 0x7                  	# ($s1) = Bits 2-0 of instruction.
	
	sll	$s2, $s2, 2			# Word align for initial index.
	sll	$s1, $s1, 4			# Word align for second index.
	
	lw	$v0, DECODE_R_LOOKUP($s2)
	addu	$v0, $v0, $s1			# Calculate address of decoder.
	lw	$t2, ($v0)			# Load address of instruction decoder.
decoderLookup_errorHandling:
	andi	$t0, $t2, 0x10000000		# Check if lookup is in data segment; if so, it is an error type.
	bne	$t0, 0x10000000, decoderLookup_noError
	lw	$t2, ($t2)

	bltu	$t2, 0xfffffff0, decoderLookup_noError
	and	$t2, $t2, 0x0000000f
	sll	$t2, $t2, 2
	lw	$v1, DECODE_LOOKUP_ERRORS($t2)
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

##########################################################################
#
#	Decodes an instruction to it's mnemonic string representation.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
.globl decodeInstruction
decodeInstruction:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	addi	$sp, $sp, -20
	########################
	la	$s0, ($a0)			# Save arguments.
	la	$s1, ($a1)
	
	la	$a0, DECODED_INSTRUCTION_BUFFER		# TODO: refactor this, it is very inefficient.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	jal	clearBuffer
	
	la	$a0, ($s0)
	la	$a1, ($s1)
	jal	decoderLookup			# Get instruction decoder.
	bnez	$v1, decodeInstruction_return	# If instruction is valid, continue; otherwise, return error.
	la	$s2, ($v0)			# ($s2) = Decoder address.
	
	la	$a2, 4($s2)
	lw	$s2, ($s2)
	jalr	$s2				# Jump to decoder.
decodeInstruction_return:
	########################		# Restore protected registers. 
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Passthrough decoder simply returns the mnemonic. Used for syscall
#	and break.
#
#	Arguments:
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoder_mnemonic:
	la	$v0, ($a2)
	li	$v1, 0
	
  	jr  	$ra 

##########################################################################
#
#	Decodes a 3 register R-format instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoderR_3Reg:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw 	$s5, -28($fp)
	sw 	$s6, -32($fp)
	sw 	$s7, -36($fp)
	
	addi	$sp, $sp, -40
	########################
	la	$s0, ($a0)			# ($s0) = 32-bit instruction
	la	$s1, ($a1)			# ($s1) = Text segment address.
	la	$s2, ($a2)			# ($s2) = Instruction mnemonic string buffer.
	
	jal	decoderR_fields			# Decode the instruction 
	la	$s3, ($t0)			# ($s3) = rd field
	la	$s4, ($v1)			# ($s4) = rt field
	la	$s5, ($v0)			# ($s5) = rs field

	la	$a0, DECODED_INSTRUCTION_BUFFER
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, ($s2)
	jal	stringConcat
	
	la	$a2, MNEMONIC_SEPARATOR
	jal	stringConcat
	
	andi	$s6, $s0, 0x0000007 			# ($s6) = Bits [0:2] of funct code.
	andi	$s7, $s0, 0x00000038			# ($s7) = Bits [5:3] of funct code.
	srl	$s7, $s7, 3
	
	bne	$s7, 0x00000001, decoderR_3Reg_nJ	# Check if a jump register instruction.
	bne	$s6, 0x00000000, decoderR_3Reg_nJ_0	# Check if jr
	sll	$s5, $s5, 3				# Only concat rs field.
	la	$a2, DECODE_REGISTER_LOOKUP($s5)
	jal	stringConcat
	j	decoderR_3Reg_return
decoderR_3Reg_nJ_0:
	bne	$s6, 0x00000001, decoderR_3Reg_nJ	# Check if jalr
	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat
	
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat
	
	sll	$s5, $s5, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s5)
	jal	stringConcat
	j	decoderR_3Reg_return
decoderR_3Reg_nJ:
	bne	$s7, 0x00000003, decoderR_3Reg_nMulDiv	# Check if bits [5:3] = 0b011
							# i.e., instruction is in decode_R_3_lookupTable.
	sll	$s5, $s5, 3				# Concat rs field.
	la	$a2, DECODE_REGISTER_LOOKUP($s5)
	jal	stringConcat
	
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat
	
	sll	$s4, $s4, 3				# Concat rt field.
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat
	j	decoderR_3Reg_return
decoderR_3Reg_nMulDiv:
	la	$a0, DECODED_INSTRUCTION_BUFFER
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN

	bne	$s7, 0x00000002, decoderR_3Reg_nMtMf	# Check if mf** / mt**
	beq	$s6, 0x00000001, decoderR_3Reg_mt	# mthi
	beq	$s6, 0x00000003, decoderR_3Reg_mt	# mtlo
	
	sll	$s3, $s3, 3				# Concat rd field.
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat
	
	j	decoderR_3Reg_return
decoderR_3Reg_mt:					# mfhi / mflo
	sll	$s5, $s5, 3				# Concat rs field.
	la	$a2, DECODE_REGISTER_LOOKUP($s5)
	jal	stringConcat
	
	j	decoderR_3Reg_return
decoderR_3Reg_nMtMf:
	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat
	
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat
	
	sll	$s5, $s5, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s5)
	jal	stringConcat
	
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat
	
	sll	$s4, $s4, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat

decoderR_3Reg_return:
	la	$v0, DECODED_INSTRUCTION_BUFFER
	li	$v1, 0
	########################		# Restore protected registers. 
	lw	$s7, -36($fp)
	lw 	$s6, -32($fp)
	lw	$s5, -28($fp)
	lw 	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Decodes a R-format shamt instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoderR_shamt:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw 	$s5, -28($fp)
	sw 	$s6, -32($fp)
	
	addi	$sp, $sp, -36
	########################
	la	$s0, ($a0)			# ($s0) = 32-bit instruction
	la	$s1, ($a1)			# ($s1) = Text segment address.
	la	$s2, ($a2)			# ($s2) = Instruction mnemonic string buffer.
	
	jal	decoderR_fields			# Decode the instruction 
	la	$s3, ($v1)			# ($s3) = rt field
	la	$s4, ($t0)			# ($s4) = rd field
	la	$s5, ($t1)			# ($s5) = shamt field
	
	la	$a0, DECODED_INSTRUCTION_BUFFER	# Create string representation of instruction.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, ($s2)
	jal	stringConcat			# Concat instruction mnemonic.
	
	la	$a2, MNEMONIC_SEPARATOR
	jal	stringConcat			# Concat mnemonic-operands separator.
	
	sll	$s4, $s4, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat			# Concat rd operand.
		
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	
	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat			# Concat rt operand.
		
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	
	la	$a0, INT_CONVERSION_BUFFER	# TODO: refactor this, it is very inefficient.
	lw	$a1, INT_CONVERSION_BUFFER_LEN
	jal	clearBuffer
	
	la	$a0, ($s5)
	la	$a1, INT_CONVERSION_BUFFER
	jal	intToString			# Convert shamt field to sting.
	
	la	$a0, DECODED_INSTRUCTION_BUFFER
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, INT_CONVERSION_BUFFER
	jal	stringConcat			# Concat shamt field.

	la	$v0, DECODED_INSTRUCTION_BUFFER
	li	$v1, 0

	########################		# Restore protected registers. 
	lw	$s6, -32($fp)
	lw 	$s5, -28($fp)
	lw	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Decodes an I-format arith instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoderI_arith:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw 	$s5, -28($fp)
	sw 	$s6, -32($fp)
	
	addi	$sp, $sp, -36
	########################
	la	$s0, ($a0)			# ($s0) = 32-bit instruction
	la	$s1, ($a1)			# ($s1) = Text segment address.
	la	$s2, ($a2)			# ($s2) = Instruction mnemonic string buffer.
	
	jal	decoderI_fields
	la	$s3, ($v0)			# ($s3) = rs field
	la	$s4, ($v1)			# ($s4) = rt field
	la	$s5, ($t0)			# ($s5) = immediate field
	
	la	$a0, DECODED_INSTRUCTION_BUFFER	# Create string representation of instruction.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, ($s2)
	jal	stringConcat			# Concat instruction mnemonic.
	
	la	$a2, MNEMONIC_SEPARATOR
	jal	stringConcat			# Concat mnemonic-operands separator.
	
	
	srl	$t0, $s0, 29			# Check if branching.
	andi	$t0, $t0, 0x00000007		# Mask bits [5:3]
	bnez	$t0, decoderI_arith_nb
	
	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat			# Concat rs operand.

	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	
	sll	$s4, $s4, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat			# Concat rt operand.
		
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	j	decoderI_arith_lui
decoderI_arith_nb:
	sll	$s4, $s4, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat			# Concat rt operand.
		
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	
	srl	$t0, $s0, 26			# Check if lui.
	andi	$t0, $t0, 0x00000007		# Mask bits [2:0]
	beq	$t0, 0x00000007, decoderI_arith_lui
	

	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat			# Concat rs operand.

	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
decoderI_arith_lui:
	la	$a0, INT_CONVERSION_BUFFER	# TODO: refactor this, it is very inefficient.
	lw	$a1, INT_CONVERSION_BUFFER_LEN
	jal	clearBuffer
	
	la	$s6, intToString		# Handle unsinged instructions.
	srl	$t0, $s0, 26			
	andi	$t0, $t0, 0x7
	beq	$t0, 0x1, decoderI_arith_unsigned
	beq	$t0, 0x3, decoderI_arith_unsigned
	j	decoderI_arith_signed
decoderI_arith_unsigned:
	la	$s6, uintToString
decoderI_arith_signed:	
	la	$a0, ($s5)
	la	$a1, INT_CONVERSION_BUFFER
	jalr	$s6				# Convert immediate field to sting.
	
	la	$a0, DECODED_INSTRUCTION_BUFFER
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, INT_CONVERSION_BUFFER
	jal	stringConcat			# Concat immediate field.

	la	$v0, DECODED_INSTRUCTION_BUFFER
	li	$v1, 0

	########################		# Restore protected registers. 
	lw	$s6, -32($fp)
	lw 	$s5, -28($fp)
	lw 	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Decodes a load/store instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoderI_loadStore:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw 	$s5, -28($fp)
	sw 	$s6, -32($fp)
	
	addi	$sp, $sp, -36
	########################
	la	$s0, ($a0)			# ($s0) = 32-bit instruction
	la	$s1, ($a1)			# ($s1) = Text segment address.
	la	$s2, ($a2)			# ($s2) = Instruction mnemonic string buffer.
	
	jal	decoderI_fields
	la	$s3, ($v0)			# ($s3) = rs field
	la	$s4, ($v1)			# ($s4) = rt field
	la	$s5, ($t0)			# ($s5) = immediate field
	
	la	$a0, DECODED_INSTRUCTION_BUFFER	# Create string representation of instruction.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, ($s2)
	jal	stringConcat			# Concat instruction mnemonic.
	
	la	$a2, MNEMONIC_SEPARATOR
	jal	stringConcat			# Concat mnemonic-operands separator.
	
	sll	$s4, $s4, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s4)
	jal	stringConcat			# Concat rt operand.
		
	la	$a2, OPERATOR_SEPARATOR
	jal	stringConcat			# Concat operand separator.
	
	beqz	$s5, decoderI_loadStore_0_immd	# Only concat immediate if not zero.
	la	$a0, INT_CONVERSION_BUFFER	# TODO: refactor this, it is very inefficient.
	lw	$a1, INT_CONVERSION_BUFFER_LEN
	jal	clearBuffer
	
	la	$a0, ($s5)
	la	$a1, INT_CONVERSION_BUFFER
	jal	intToString			# Convert immediate field to sting.
	
	la	$a0, DECODED_INSTRUCTION_BUFFER
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, INT_CONVERSION_BUFFER
	jal	stringConcat			# Concat immediate field.
decoderI_loadStore_0_immd:

	la	$a2, BRACKET_LEFT
	jal	stringConcat
	
	sll	$s3, $s3, 3
	la	$a2, DECODE_REGISTER_LOOKUP($s3)
	jal	stringConcat			# Concat operand separator.
	
	la	$a2, BRACKET_RIGHT
	jal	stringConcat
	
	la	$v0, DECODED_INSTRUCTION_BUFFER
	li	$v1, 0

	########################		# Restore protected registers. 
	lw 	$s6, -32($fp)
	lw 	$s5, -28($fp)
	lw 	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Decodes a J-format instruction.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#		- $a1 = Text segment address.
#		- $a2 = Instruction mnemonic string buffer.
#
#	Results:
#		- $v0 = String buffer of decoded instruction.
#		- $v1 = String error value (0 if no error).
#
##########################################################################
decoderJ:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	sw 	$s5, -28($fp)
	sw 	$s6, -32($fp)
	
	addi	$sp, $sp, -36
	########################
	la	$s0, ($a0)			# ($s0) = 32-bit instruction
	la	$s1, ($a1)			# ($s1) = Text segment address.
	la	$s2, ($a2)			# ($s2) = Instruction mnemonic string buffer.
	
	andi	$s3, $s0, 0x03ffffff		# Mask address field
	sll	$s3, $s3, 2			# ($s3) = Jump address
	
	la	$a0, DECODED_INSTRUCTION_BUFFER	# Create string representation of instruction.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, ($s2)
	jal	stringConcat			# Concat instruction mnemonic.
	
	la	$a2, MNEMONIC_SEPARATOR
	jal	stringConcat			# Concat mnemonic-operands separator.
	
	
	la	$a0, ($s3)
	la	$a1, INT_CONVERSION_BUFFER
	jal	intToHexString			# Convert jump address to HEX string.
	
	la	$a0, DECODED_INSTRUCTION_BUFFER	# Concat hex jump address.
	lw	$a1, DECODED_INSTRUCTION_BUFFER_LEN
	la	$a2, HEX_PREFIX
	jal	stringConcat

	la	$a2, INT_CONVERSION_BUFFER
	jal	stringConcat
	
	la	$v0, DECODED_INSTRUCTION_BUFFER
	li	$v1, 0

	########################		# Restore protected registers. 
	lw 	$s6, -32($fp)
	lw 	$s5, -28($fp)
	lw	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################

##########################################################################
#
#	Decodes an R-format instruction's fields.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#
#	Results:
#		- $v0 = rs
#		- $v1 = rt
#		- $t0 = rd
#		- $t1 = shamt
#
##########################################################################
decoderR_fields:
	srl	$a0, $a0, 6			# Shift instruction right to get rid of funct.
	and	$t1, $a0, 0x0000001f		# ($t1) = shamt
	srl	$a0, $a0, 5
	and	$t0, $a0, 0x0000001f		# ($t0) = rd
	srl	$a0, $a0, 5
	and	$v1, $a0, 0x0000001f		# ($v1) = rt
	srl	$a0, $a0, 5
	and	$v0, $a0, 0x0000001f		# ($v0) = rs
	jr	$ra
	
##########################################################################
#
#	Decodes an I-format instruction's fields.
#
#	Arguments:
#		- $a0 = 32-bit instruction
#
#	Results:
#		- $v0 = rs
#		- $v1 = rt
#		- $t0 = immediate
#
##########################################################################
decoderI_fields:
	and	$t0, $a0, 0x0000ffff		# ($t0) = immediate
	sll	$t0, $t0, 16			# Shift immediate bits to upper 16 bits.
	sra	$t0, $t0, 16			# Shift right arithmetic to preserve sign (sign extension).
	srl	$a0, $a0, 16
	and	$v1, $a0, 0x0000001f		# ($v1) = rt
	srl	$a0, $a0, 5
	and	$v0, $a0, 0x0000001f		# ($v0) = rs
	jr	$ra
