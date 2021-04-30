# io.s		Provides input and output subroutines based on sysetemcalls.
#
# Author: 	Kolbe Prusa
.text
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
##########################################################################
.globl readString
readString:	
	li 	$v0, 8 				# load syscall code for read string
	syscall
	
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
