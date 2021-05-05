# main.s	This is a mini-disassembler for MIPS-32 ISA
#
# Author: 	Kolbe Prusa
.data
promptFilename:			.asciiz	"Input a filename: "

errorInvalidFilename:		.asciiz "error: invalid filename: "
errorInvalidInstruction:	.asciiz "error: invalid instruction: "
errorLine:			.asciiz "line: "

TEXT_SEGMENT_ADDR:			.word	0x00400000

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
	
	li	$s2, 1				# ($s2) = Current instruction line.
conversion_loop:
	la	$a0, ($s0)			# Read 9 bytes from the input file, write into input buffer.
	la	$a1, ($s1)
	li	$a2, 9
	jal	readFile
	ble	$v0, 1, conversion_exit
	
	la	$a0, ($s1)			# Convert 8 bytes from buffer to int.
	li	$a1, 9
	jal	convertHex			
	la	$s3, ($v1)			# ($s3) = Converted instruction.
	
	la	$a0, ($s3)
	jal	decoderLookup
	la	$s4, ($v0)			# ($s4) = Decoder address.
	la	$t1, ($v1)
		
	beqz 	$t1, conversion_loop_valid	# Print error if instruction is invalid.
	la	$a0, ($t1)
	la	$a1, ($s1)
	la	$a2, ($s2)
	jal	printError
	j	conversion_loop_invalid
conversion_loop_valid:
	addi	$a0, $s4, 4
	lw	$s4, ($s4)
	jalr	$s4
	jal	printNewLine
conversion_loop_invalid:
	addi	$s2, $s2, 1			# Increment instruction line.
	j conversion_loop
conversion_exit:
	j	exit
	
##########################################################################
#
#	Prints an error message.
#
#	Arguments:
#		- $a0 = Error message string buffer.
#		- $a1 = Instruction string buffer.
#		- $a2 = Line number of erroring instruction.
#
##########################################################################
printError:
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
	la	$s1, ($a1)
	la	$s2, ($a2)
	
	la	$a0, errorInvalidInstruction
	jal	printString
	la	$a0, ($s0)
	jal	printString
	la	$a0, errorLine
	jal	printString
	la	$a0, ($s2)
	jal	printInt
	li	$a0, 58				# Print ':'
	jal	printChar
	li	$a0, 32				# Print ' '
	jal	printChar
	
	addi	$t0, $s2, -1			# Convert line number to text segment address.
	sll	$t0, $t0, 2
	lw	$t1, TEXT_SEGMENT_ADDR
	add	$a0, $t0, $t1
	jal	printIntHex
	
	li	$a0, 32				# Print ' '
	jal	printChar
	la	$a0, ($s1)
	jal	printString
	########################		# Restore protected registers. 
	lw 	$s2, -16($fp)
	lw 	$s1, -12($fp)
	lw 	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################
