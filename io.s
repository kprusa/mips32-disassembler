# io.s		Provides input and output subroutines based on sysetem calls.
#
# Author: 	Kolbe Prusa
.data
.globl	FILE_FLAG_R, FILE_FLAG_WC, FILE_FLAG_WCA
	FILE_FLAG_R:	.word	0
	FILE_FLAG_WC:	.word	1
	FILE_FLAG_WCA:	.word	9
.text

##########################################################################
#
#	Allocates a new buffer on the heap.
#
#	Arguments:
#		- $a0 = Number of bytes to allocate
#
#	Results:
#		- $v0 =	The address of the buffer
#
##########################################################################
.globl alloc
alloc:
	li	$v0, 9				# load syscall code for open file.
	syscall
	jr	$ra 

##########################################################################
#
#	Opens a file with the specified flag.
#
#	Arguments:
#		- $a0 = Address of string buffer containing filename
#		- $a1 = Flag
#			- 0: read-only
#			- 1: write-only with creation
#			- 9: write-only with create and append.
#
#	Results:
#		- $v0 =	File descriptor (negative if error)
#
##########################################################################
.globl openFile
openFile:
	li	$v0, 13				# load syscall code for open file.
	syscall
	jr	$ra 
	
##########################################################################
#
#	Closes a file with the specified flag.
#
#	Arguments:
#		- $a0 = File descriptor
#
##########################################################################
.globl closeFile
closeFile:
	li	$v0, 16				# load syscall code for open file.
	syscall
	jr	$ra 
	
##########################################################################
#
#	Reads bytes from a file.
#
#	Arguments:
#		- $a0 = File descriptor
#		- $a1 = Address of input buffer.
#		- $a2 = Max characters (bytes) to read.
#
#	Results:
#		- $v0 =	Number of bytes read
#			- 0: End of file.
#			- <0: Error
#
##########################################################################
.globl readFile
readFile:
	li	$v0, 14				# load syscall code for open file.
	syscall
	jr	$ra 

##########################################################################
#
#	Exits the program
#
##########################################################################
.globl exit
exit:						# exit the program
	li 	$v0, 10 			# load syscall code for exit
	syscall
	
##########################################################################
#
#	Reads a string from stdin.
#
#	Arguments:
#		- $a0 = Buffer address
#		- $a1 = Maximum number of characters to read.
#
#	Results:
#		- $v0 =	Length of string read.
#
##########################################################################
.globl readString
readString:	
	li 	$v0, 8 				# load syscall code for read string
	syscall
	
	la	$v0, ($zero)			# loop couter
readString_loop:
	bge	$v0, $a1, readString_return	# if (($t0) > max number of characters to read) -> break loop
	add	$t1, $v0, $a0
	lb	$t1, ($t1)
	beq	$t1, $zero, readString_return
	addi	$v0, $v0, 1
	b	readString_loop
readString_return:
	jr 	$ra				# return to caller

##########################################################################
#
#	Prints a new line (i.e., '\n').
#
##########################################################################
.globl printNewLine
printNewLine:
	li	$a0, 10				# load newline character '\n'.
	li 	$v0, 11 			# load syscall code for print character.
	syscall
	
	jr 	$ra				# return to caller
	
##########################################################################
#
#	Prints a space.
#
##########################################################################
.globl printSpace
printSpace:
	li	$a0, 32				# load space character ' '.
	li 	$v0, 11 			# load syscall code for print character.
	syscall
	
	jr 	$ra				# return to caller
	
##########################################################################
#
#	Prints an integer.
#	
#	Arguments:			
# 		- $a0 = Integer to print.
#
##########################################################################
.globl printInt
printInt:                       		# prints an integer at $a0 to stdout
        li      $v0, 1          		# load syscall code for print int.
        syscall

        jr      $ra             		# return to caller
        

##########################################################################
#
#	Prints an integer in hex.
#	
#	Arguments:			
# 		- $a0 = Integer to print.
#
##########################################################################
.globl printIntHex
printIntHex: 
	li	$v0, 34
	syscall
	
	jr	$ra
        
##########################################################################
#
#	Prints a string.
#	
#	Arguments:			
# 		- $a0 = String to print.
#
##########################################################################
.globl printString
printString:					# prints a string at $a0 to stdout.
	li 	$v0, 4 				# load syscall code for print string.
	syscall
	
	jr 	$ra				# return to caller
