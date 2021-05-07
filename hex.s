# hex.s		Provides subroutines for handling hexadecimal data.
#
# Author: 	Kolbe Prusa
	
.text
##########################################################################
#
#	Converts a HEX character to its decimal value.
#
#	Arguments:
#		- $a0 = ASCII value to convert
#		- $a1 = ASCII value of lower bound
#		- $a2 = Base HEX value in decimal
#
#	Results:
#		- $v0 =	Decimal value of hex
#
#	E.G. 	$a0 = 'B' = 66		$v0 = $a0 - $a1 + $a2
#		$a1 = 'A' = 65    	    = 66  - 65  + 10
#		$a2 = 0xA = 10    	    = 11
#		    			    = 0xB
#
##########################################################################
.globl convertHexChar
convertHexChar:
	la	$v0, ($zero)			# $v0 = 0
	sub	$v0, $a0, $a1			# $v0 = $a0 - $a1
	add	$v0, $v0, $a2			# $v0 = $v0 + 10
	jr 	$ra

##########################################################################
#
#	Checks if a value is within an inclusive range (i.e., $a1 <= $a0 <= $a2).
#
#	Arguments:
#		- $a0 = value to check
#		- $a1 = left inclusive bound
#		- $a2 = right inclusive bound
#
#	Results:
#		- $v0 =	1: The value is within the range.
#			0: The value is outside the range.
#
##########################################################################
.globl isInRange
isInRange:
	blt	$a0, $a1, notInRange		# if (a0 < a1)
	bgt	$a0, $a2, notInRange		# if (a0 > a2)
	la 	$v0, 1				# ($v0) = 1
	jr	$ra
notInRange:
	la 	$v0, ($zero)			# ($v0) = 0
	jr	$ra

##########################################################################
#
# 	Converts the hexademical string in the buffer to its value.
#	
#	Arguments:			
# 		- $a0 = Address of string buffer up to 32-bits.
# 		- $a1 = Length of string buffer in bytes.
#
#	Results:
#		- $v0 =	1: Conversion successful. (The buffer only contains vaild hex characters.)
#			0: Conversion failed. (The buffer contains invaild hex characters.)
#		- $v1 =	Converted hex value
#
##########################################################################
.globl convertHex
convertHex:
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
	addi	$sp, $sp, -32
	########################									
																				
	add	$s0, $zero, $zero		# Initialize ($s0) = 0 as loop counter
	la	$s5, ($zero)			# $s5 = converted hex value.
	la	$s1, ($a0)
	addi	$s2, $a1, -1
convertHex_topWhile:
	bge 	$s0, $s2, convertHex_endWhile	# Check if at end of string
	
	lb	$s4, ($s1)			# Load the ASCII character code from string buffer
	
	la	$a0, ($s4)			# Check if character is any of '0'...'9'
	li	$a1, 48
	li	$a2, 57
	jal 	isInRange
	add	$s3, $zero, $v0
	beq	$s3, 0, convertHex_case1	# If character is not in ['0'..'9'], check next case
	
	la	$a0, ($s4)			# Load the ASCII character code
	li 	$a2, 0				# Base value of 0x0
	j	convertHex_continue
convertHex_case1:
	la	$a0, ($s4)			# Check if character is any of 'A'...'F'
	li	$a1, 65
	li	$a2, 70
	jal 	isInRange
	add	$s3, $zero, $v0
	beq	$s3, 0, convertHex_case2	# If character is not in ['A'..'F'], check next case
	
	la	$a0, ($s4)			# Load the ASCII character code
	li 	$a2, 10				# Base value of 0xA
	j	convertHex_continue
convertHex_case2:
	la	$a0, ($s4)			# Check if character is any of 'a'...'f'
	li	$a1, 97
	li	$a2, 102
	jal 	isInRange
	add	$s3, $zero, $v0
	beq	$s3, 0, convertHex_invalidHex	# Character is invalid hexcode, failed all cases.
	
	la	$a0, ($s4)			# Load the ASCII character code
	li 	$a2, 10				# Base value of 0xa			
convertHex_continue:
	jal	convertHexChar			# Convert the valid ASCII character to HEX value.
	sll	$s5, $s5, 4			# Shift converted value left by 4-bits to prepare for new hex value.
	add	$s5, $s5, $v0			# Add new hex value to converted value.
		
	addi	$s1, $s1, 1 			# ($s1)++
	addi	$s0, $s0, 1			# ($s0)++
	j 	convertHex_topWhile		# Continue the loop
convertHex_endWhile:
	add 	$v0, $zero, 1			# ($v0) = 1
	la	$v1, ($s5)			# converted value
	j	convertHex_epilogue		# Jump to end of subroutine
convertHex_invalidHex:
	la 	$v0, ($zero)			# ($v0) = 0
convertHex_epilogue:	
	########################		# Restore protected registers. 
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
#	Converts a buffer containing hexadecimal character values into a binary buffer.
#
#	Arguments:
#		- $a0 = Input buffer address
#		- $a1 = Input buffer size.
#
#	Results:
#		- $v0 =	Address binary buffer.
#
##########################################################################
.globl convertHexBuffer	
convertHexBuffer:
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
	addi	$sp, $sp, -32
	########################
	la	$s0, ($a0)
	la	$s1, ($a1)
						# Allocate conversion buffer.
	srl	$a0, $s1, 1			# Divide size of input buffer by 2 (Hex conversion factor)
	addi	$a0, $a0, 1			# Add 1 to account for odd size of input buffer.
	jal	alloc
	la	$s3, ($v0)			# ($s3) = Conversion buffer address.
	la	$s4, ($v0)
	
	add	$t0, $s0, $s1			# ($t0) = End address of input buffer.
	la	$t1, ($s0)			# ($t1) = Input buffer address position.
convertHexBuffer_conversionLoop:
	bge	$t1, $t0, convertHexBuffer_conversionDone	# Loop for size of input buffer.
	
	la	$a0, ($t1)			# Convert 8 bytes of hex from input buffer to int.
	la	$a1, 9
	jal	convertHex
						# Add handling of conversion error.
#	####			
#	la	$a0, ($v1)			# Output converted value to stdout.
#	jal	printIntHex
#	jal	printNewLine
#	####
	
	sw	$v1, ($s3)
	
	la	$t1, 9($t1)
	la	$s3, 4($s3)
	j	convertHexBuffer_conversionLoop
convertHexBuffer_conversionDone:
	la	$v0, ($s4)
	########################		# Restore protected registers. 
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
#	Converts an integer into a hex-string representation.
#
#	Arguments:
#		- $a0 = Integer to convert.
#		- $a1 = Destination buffer
#
##########################################################################
.globl intToHexString
intToHexString:
	bnez	$a0, intToHexString_non_zero
	li	$t0, 0
	li	$t1, '0'
intToHexString_zero:
	sb	$t1, ($a1)
	addiu	$a1, $a1, 1
	addiu	$t0, $t0, 1
	blt	$t0, 8, intToHexString_zero
	jr	$ra
intToHexString_non_zero:
	la	$t0, ($zero)			# ($t0) = Loop counter.
	li	$t5, 16				# ($t5) = Divisor
	la	$t8, ($a0)
intToHexString_convert_loop:
	divu	$t8, $t5
	mflo	$t8				# ($t8) = Quotient
	mfhi	$t9				# ($t9) = Remainder
	
	bgt	$t9, 9, intToHexString_char
	li	$t1, 0x30			# Base ASCII value for '0'.
	j	intToHexString_convert
intToHexString_char:
	li	$t1, 0x61			# Base ASCII value for 'a'.
	subi	$t9, $t9, 10			# Resolve ASCII offset.		
intToHexString_convert:
	add	$t9, $t9, $t1			# Convert remainder to ASCII value.
	sb	$t9, -1($sp)			# Store converted ASCII value on stack.
	
	addiu	$sp, $sp, -1			# Increase stack size.
	addiu	$t0, $t0, 1			# Increment loop counter.
	
	bnez	$t8, intToHexString_convert_loop# Continue conversion until quotient is zero.
	
intToHexString_pad:
	li	$t9, '0'
	sb	$t9, -1($sp)			# Store converted ASCII value on stack.
	addiu	$sp, $sp, -1			# Increase stack size.
	addiu	$t0, $t0, 1			# Increment loop counter.
	blt	$t0, 8, intToHexString_pad

intToHexString_write_loop:
	beqz	$t0, intToHexString_return
	lbu	$t8, ($sp)			# Pop char from stack.
	sb	$t8, ($a1)			# Write char in buffer.
	
	addi	$sp, $sp, 1			# Decrease stack size.
	addi	$t0, $t0, -1			# Decrement loop counter.
	addi	$a1, $a1, 1			# Increment desination buffer address.
	j	intToHexString_write_loop
intToHexString_return:
  	jr  	$ra


