# main.s	This is a mini-disassembler for MIPS-32 ISA
#
# Author: 	Kolbe Prusa
.data
promptFilename:			.asciiz	"Input a filename: "

errorInvalidFilename:		.asciiz "error: invalid filename: "
errorInvalidInstruction:	.asciiz "error: invalid instruction: "

filenameBuffer:			.space	256
filenameBufferLen:		.word	257

.text
.globl main
main:
	jal	printNewLine			# Prompt for input filename.
	la	$a0, promptFilename
	jal	printString
	
	
	la	$a0, filenameBuffer		# Read input filename.
	lw	$a1, filenameBufferLen
	jal	readString
	
	addi	$v0, $v0, -1			# Remove trailing newline character from filename.
	la	$t0, filenameBuffer
	add	$t0, $t0, $v0
	sb	$zero, ($t0)

	
	la	$a0, filenameBuffer		# Open input file in read-only.
	lw	$a1, FILE_FLAG_R
	jal	openFile
	la	$s0, ($v0)			# ($s0) = Input file descriptor
	bge	$s0, $zero, mainValidInputFile	# Check that input file is valid, print error if not.
	
	la	$a0, errorInvalidFilename
	jal	printString
	la	$a0, filenameBuffer
	jal	printString
	j	exit
mainValidInputFile:
	li	$a0, 128			# Allocate input buffer to hold an instruction (8 bytes)
	jal	alloc
	la	$s1, ($v0)			# ($s1) = Input buffer address.
	
	
	li	$s2, 2
	li	$s6, 1				# ($s6) = Current instruction line.
conversion_loop:
	ble	$s2, 1, conversion_exit
	la	$a0, ($s0)			# Read 9 bytes from the input file, write into input buffer.
	la	$a1, ($s1)
	li	$a2, 9
	jal	readFile
	la	$s2, ($v0)
	
	la	$a0, ($s1)			# Convert 8 bytes from buffer to int.
	li	$a1, 9
	jal	convertHex			
	la	$s3, ($v1)			# ($s3) = Converted instruction.
	
	srl	$s4, $s3, 26			# ($s4) = Instruction opcode.
	srl	$s5, $s4, 3			# ($s5) = Bits 31-29 of instruction.
	and	$s4, $s4, 0x7                  	# ($s4) = Bits 28-26 of instruction.
	
	sll	$s5, $s5, 2			# Word align for index
	sll	$s4, $s4, 2
	
	lw	$t0, decode_jumpTable($s5)	# Get initial jump table address for instruction decode.
	addu	$t0, $t0, $s4			# Calculate index of final lookup
	lw	$t0, ($t0)			# Load address of instruction decoder.
	
	la	$t1, DECODE_R
	bne	$t0, $t1, conversion_loop_RType 	# Check if instruction is R-format; if so, use funct code for decoder lookup.
	and	$s4, $s3, 0x3f			# ($s4) = Bits 5-0 of instruction
	srl	$s5, $s4, 3			# ($s5) = Bits 5-3 of instruction.
	and	$s4, $s4, 0x7                  	# ($s4) = Bits 2-0 of instruction.
	
	sll	$s5, $s5, 2			# Word align for index
	sll	$s4, $s4, 2
	
	lw	$t0, decode_R_jumpTable($s5)
conversion_loop_RType:
	la	$t1, DECODE_INVALID
	bne	$t0, $t1, conversion_loop_valid_instruction		# Print error if instruction is invalid and exit program.
	la	$a0, errorInvalidInstruction
	jal	printString
	la	$a0, ($s6)
	jal	printInt
	jal	printSpace
	la	$a0, ($s1)
	jal	printString
	jal	printNewLine
	j	exit
conversion_loop_valid_instruction:
	addi	$s6, $s6, 1			# Increment instruction line.
	j conversion_loop
conversion_exit:
	
	j	exit