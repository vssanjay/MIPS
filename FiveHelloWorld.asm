# My First MIPS program
# Author: Saad Biaz
# August 25, 2016
# Objective: demo program to show how to print out a string

.text

main : 	addi $t0, $zero, 0
	while:
		bgt $t0 , 4, exit
		jal Hello			#Call subroutine Hello
		addi $t0, $t0, 1 
		j while	
				
	exit:	
		li $v0,10
		syscall		

quit :	li $v0, 10			# specify Print String Service (#10)
	syscall				# syscall to execute requested service specified in Register $v0 (#10)
	
# Subroutine to print Hello World
	.data
myString:	.asciiz "Hello World \n"
	.text
Hello : la $a0, myString
	li $v0, 4			# specify Print String Service (#4)
	syscall				# syscall to execute requested service specified in Register $v0 (#4)
	jr $ra				# return from subroutine		
		


