# string.s	Provides subroutines for working with string buffers.
#
# Author: 	Kolbe Prusa

.text
##########################################################################
#
#	Concats two strings located at the provided buffer addresses.
#
#	The concatentation will occur up until the end of the destination buffer,
#	specified by $a1.
#
#	Arguments:
#		- $a0 = Destination string buffer.
#		- $a1 = Destination string buffer length.
#		- $a2 = Source string buffer.
#
#	Results:
#		- $v0 = Number of characters concatenated.
#
##########################################################################
.globl	stringConcat
stringConcat:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	sw 	$s0, -8($fp)
	sw 	$s1, -12($fp)	
	sw 	$s2, -16($fp)
	addi	$sp, $sp, -20
	########################
	la	$s0, ($a0)			# ($s0) = Desination string buffer.
	la	$s1, ($a1)			# ($s1) = Destination string buffer length.
	la	$s2, ($a2)			# ($s2) = Source string buffer.
	
	jal	stringLen			# Calculate length of desintation buffer string.
	la	$t9, ($v0)			# ($s3) = Desination buffer string length.
	
	la	$t0, ($zero)			# ($t0) = Source string buffer index (loop counter).
stringConcat_loop:	
	add	$t1, $t9, $t0			# ($t1) = Current index of destination buffer.
	bge	$t1, $s1, stringConcat_return	# if (desination buffer index >= desintation buffer length) -> return
	
	add	$t2, $a2, $t0			# ($t2) = Address of current source byte at current index.
	lbu	$t3, ($t2)			# ($t3) = Byte at current index from source buffer.
	beqz	$t3, stringConcat_return	# Check if at end of source buffer.
	
	add	$t4, $s0, $t1
	sb	$t3, ($t4)			# Store the byte from source buffer to destination buffer.
	
	addi	$t0, $t0, 1			# Increment source string buffer index.
	j	stringConcat_loop
stringConcat_return:
	la	$v0, ($t1)
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
#	Calculates the length of a null terminated string.
#
#	Arguments:
#		- $a0 = String buffer.
#
#	Results:
#		- $v0 = String length.
#
##########################################################################
.globl stringLen
stringLen:
	la	$v0, ($zero)			# Initialize index.
stringLen_loop:
	add	$t0, $a0, $v0			# Calculate byte address from index.
	lbu	$t1, ($t0)			# Load the byte value.
	beqz	$t1, stringLen_return		# if (byte == '\0') -> return
	addi	$v0, $v0, 1			# Increment index
	j	stringLen_loop
stringLen_return:
	jr	$ra
	

##########################################################################
#
#	Converts a signed 32-bit integer into its string representation.
#
#	Arguments:
#		- $a0 = Integer to convert.
#		- $a1 = Destination buffer
#
#	Results:
#		- $v0 = Length of converted string.
#
##########################################################################
.globl intToString
intToString:
	########################		# Save protected registers on stack.
	sw	$fp, -4($sp)
	la	$fp, -4($sp)
	
	sw	$ra, -4($fp)
	addi	$sp, $sp, -8
	########################

	bnez	$a0, intToString_non_zero
	li	$t0, '0'
	sb	$t0, ($a1)
	jr	$ra
intToString_non_zero:
	bgtz	$a0, intToString_pos		
	nor	$a0, $a0, $zero			# Convert int to unsigned if negative.	
	addiu	$a0, $a0, 1
	li	$t1, '-'			# Write sign to buffer.
	sb	$t1, ($a1)
	addi	$a1, $a1, 1
intToString_pos:
	jal	uintToString_non_zero
	
	########################		# Restore protected registers. 
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($fp)
	
  	jr  	$ra 
	#######################
 
##########################################################################
#
#	Converts an unsigned integer into its string representation.
#
#	Arguments:
#		- $a0 = Integer to convert.
#		- $a1 = Destination buffer
#
#	Results:
#		- $v0 = Length of converted string.
#
##########################################################################
.globl uintToString
uintToString:
	bnez	$a0, uintToString_non_zero
	li	$t0, '0'
	sb	$t0, ($a1)
	jr	$ra
uintToString_non_zero:
	la	$t0, ($zero)			# ($t0) = Loop counter.
	li	$t5, 10				# ($t5) = Divisor
	la	$t8, ($a0)
uintToString_convert_loop:
	divu	$t8, $t5
	mflo	$t8				# ($t8) = Quotient
	mfhi	$t9				# ($t9) = Remainder
	
	addi	$t9, $t9, 0x30			# Convert remainder to ASCII value.
	sb	$t9, -1($sp)			# Store converted ASCII value on stack.
	
	addi	$sp, $sp, -1			# Increase stack size.
	addi	$t0, $t0, 1			# Increment loop counter.
	
	bnez	$t8, uintToString_convert_loop	# Continue conversion until quotient is zero.
	la	$v0, ($t0)			# Save length of converted string.

uintToString_write_loop:
	beqz	$t0, uintToString_return
	lbu	$t8, ($sp)			# Pop char from stack.
	sb	$t8, ($a1)			# Write char in buffer.
	
	addi	$sp, $sp, 1			# Decrease stack size.
	addi	$t0, $t0, -1			# Decrement loop counter.
	addi	$a1, $a1, 1			# Increment desination buffer address.
	j	uintToString_write_loop
uintToString_return:
  	jr  	$ra
