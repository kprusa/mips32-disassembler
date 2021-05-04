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
	
	
	li	$s6, 1				# ($s6) = Current instruction line.
conversion_loop:
	la	$a0, ($s0)			# Read 9 bytes from the input file, write into input buffer.
	la	$a1, ($s1)
	li	$a2, 9
	jal	readFile
	la	$s2, ($v0)
	ble	$s2, 1, conversion_exit
	
	la	$a0, ($s1)			# Convert 8 bytes from buffer to int.
	li	$a1, 9
	jal	convertHex			
	la	$s3, ($v1)			# ($s3) = Converted instruction.
	
	la	$a0, ($s3)
	jal	decoderLookup
	la	$t0, ($v0)
	
	la	$t1, DECODE_INVALID		# Print error if instruction is invalid and exit program.
	bne	$t0, $t1, conversion_loop_valid_instruction	
	la	$a0, errorInvalidInstruction
	jal	printString
	la	$a0, ($s6)
	jal	printInt
	jal	printSpace
	la	$a0, ($s1)
	jal	printString
conversion_loop_valid_instruction:
	addi	$s6, $s6, 1			# Increment instruction line.
	j conversion_loop
conversion_exit:
	
	j	exit