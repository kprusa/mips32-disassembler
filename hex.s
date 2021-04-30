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