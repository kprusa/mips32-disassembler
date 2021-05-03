# main.s	This is a mini-disassembler for MIPS-32 ISA
#
# Author: 	Kolbe Prusa
.data
promptFilename:		.asciiz	"Input a filename: "

errorInvalidFilename:	.asciiz "error: invalid filename: "

filenameBuffer:		.space	256
filenameBufferLen:	.word	257

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
	la	$s0, ($v0)			# Save file descriptor. ($s0) = Input file descriptor
	bge	$s0, $zero, mainValidInputFile	# Check that input file is valid, print error if not.
	
	la	$a0, errorInvalidFilename
	jal	printString
	la	$a0, filenameBuffer
	jal	printString
	j	exit
mainValidInputFile:
	li	$a0, 9				# Allocate input buffer to hold on instruction (8 bytes)
	jal	alloc
	la	$s1, ($v0)			# Save buffer address. ($s1) = Input buffer address.
	li	$s2, 2

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
	la	$s3, ($v1)
	
	###					# Print converted value.
	la	$a0, ($v1)
	jal	printIntHex
	jal	printNewLine
	###
	j conversion_loop
conversion_exit:
	
	j 	exit