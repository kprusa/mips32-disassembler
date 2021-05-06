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
#	Converts an integer into its string representation
#
#	Arguments:
#		- $a0 = Integer to convert.
#		- $a1 = Destination buffer
#
#	Results:
#		- $v0 = Length of converted string.
#
##########################################################################
.globl ItoA
ItoA:
  	bnez 	$a0, ItoA_non_zero  		# first, handle the special case of a value of zero
  	li   	$t0, '0'
 	sb   	$t0, 0($a1)
  	sb   	$zero, 1($a1)
  	li   	$v0, 1
  	jr   	$ra

ItoA_non_zero:
  	addi 	$t0, $zero, 10    		 # now check for a negative value
  	li 	$v0, 0
    
  	bgtz 	$a0, ItoA_recurse
  	li   	$t1, '-'
  	sb   	$t1, 0($a1)
  	addi 	$v0, $v0, 1
  	neg  	$a0, $a0

ItoA_recurse:
	###
  	addi 	$sp, $sp, -24
  	sw   	$fp, 8($sp)
  	addi 	$fp, $sp, 8
  	sw   	$a0, 4($fp)
  	sw   	$a1, 8($fp)
  	sw   	$ra, -4($fp)
  	sw   	$s0, -8($fp)
  	sw   	$s1, -12($fp)
  	###
   
  	div  	$a0, $t0       			# $a0/10
  	mflo 	$s0            			# $s0 = quotient
  	mfhi 	$s1            			# s1 = remainder  
  	beqz 	$s0, ItoA_write

ItoA_continue:
  	move 	$a0, $s0  
  	jal 	ItoA_recurse

ItoA_write:
  	add	$t1, $a1, $v0
  	addi	$v0, $v0, 1    
  	addi 	$t2, $s1, 0x30 			# convert to ASCII
  	sb   	$t2, 0($t1)    			# store in the buffer
  	sb   	$zero, 1($t1)
  
ItoA_exit:
	###
  	lw   	$a1, 8($fp)
  	lw   	$a0, 4($fp)
  	lw   	$ra, -4($fp)
  	lw   	$s0, -8($fp)
  	lw   	$s1, -12($fp)
  	lw   	$fp, 8($sp)    
  	addi 	$sp, $sp, 24
  	jr 	$ra
  	###