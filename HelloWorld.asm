.data
menu: .asciiz "The menu available is \n a) Function Length \n b) Capitalize \n c) Delete Characters \n d) Quit"
prompt: .asciiz "\n Enter your choice (a , b , c , d)	: "



.text

main:	
	li $t6, 97 
	li $t7, 98
	li $t8, 99
	li $t9, 100
	la $a0, menu
	li $v0, 4
	syscall
	
	la $a, prompt
	li $v0, 4
	syscall
	li $v0, 51
	syscall
	move $t3, $a0
	jal conditions

conditions:
	beq 
