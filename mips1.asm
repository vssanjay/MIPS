capitalize:
.data
messagecapitalize: .asciiz "\n Captialize \n"
.text
	la $a0, messagecapitalize
	li $v0, 4
	syscall
	la $a0,enterString
	li $v0, 4
	syscall #prompt user to enter string
	li $v0,8
	la $a0,str1
	syscall   #get string 1

	la $a0,str1  #pass address of str1
	jal capitalizeString
	li   $v0, 10          # system call for exit
        syscall               # Exit!

deleteCharacters:
.data
messagedeleteCharacters: .asciiz "\n Delete Characters \n"

enterPosition: .asciiz "Enter the position you wanna delete: \n"
enterNumberOfCharacters: .asciiz "Enter the number of characters you wanna delete: \n"

.text
	la $a0, messagedeleteCharacters
	li $v0, 4
	syscall
	la $a0,enterString
	li $v0, 4
	syscall #prompt user to enter string
	li $v0,8
	la $a0,str1
	syscall   #get string 1

	la $a0,str1  #pass address of str1
	jal deleteString
	li   $v0, 10          # system call for exit
        syscall               # Exit!

quit:
.data
messagequit: .asciiz "\n Quit \n "

.text
	la $a0, messagequit
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	



capitalizeString:        
 .data

.text
	la $a0, messagecapitalize
	li $v0, 4
	syscall
	li   $v0, 10          # system call for exit
        syscall               # Exit!
        


deleteString:
  .data
messagedeleteString:.asciiz "\nThe deleted text is: "

.text
	la $a0, messagedeleteString
	li $v0, 4
	syscall
	li   $v0, 10          # system call for exit
        syscall               # Exit!
        
 
        
	
	 
