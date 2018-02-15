.data
menu: .asciiz "The menu available is \n 1) Function Length \n 2) Capitalize \n 3) Delete Characters \n 4) Quit"
prompt: .asciiz "\n Enter your choice (1,2,3,4)	: \n "

.text

main:	
	li $t6, 1
	li $t7, 2
	li $t8, 3
	li $t9, 4
	la $a0, menu
	li $v0, 4
	syscall
	
	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 51
	syscall
	move $t3, $a0
	
	beq $t3, $t6, functionLength
	beq $t3, $t7, capitalize
	beq $t3, $t8, deleteCharacters
	beq $t3, $t9, quit

	li $v0, 10
	syscall
functionLength:
    .data
str1:   .asciiz "Enter String: "
strTest:.space 100
str2:   .asciiz "Length is: \n"
    .text

    addiu   $sp, $sp, -4            # save space
    sw      $ra, 0($sp)             # push $ra
    la      $a0, str1               # print(str1)
    li      $v0, 4
    syscall

    li      $a1, 100                 # read strTest
    la      $a0, strTest
    li      $v0, 8
    syscall


    jal     stringLength            # call strLength
    move    $t0, $v0                # save result to $t0

    la      $a0, str2               # print str2
    li      $v0, 4
    syscall

    move    $a0, $t0                # print result
    li      $v0, 1
    syscall

    lw      $ra, 0($sp)             # restore $ra
    addiu   $sp, $sp, 4             # restore $sp
    j main
   
stringLength:

    li      $v0, 0                  # len = 0

while:  
    lb      $t0, ($a0)              # get char
    beq    $t0,'\n', wh_end             # if(char == '\0') --> end while
    addi    $v0, $v0, 1             # len++
    addiu   $a0, $a0, 1             # *s++
    j       while
wh_end:
    	jr      $ra
    	

capitalize:
.data

    .text

    addiu   $sp, $sp, -4            # save space
    sw      $ra, 0($sp)             # push $ra
    la      $a0, str1               # print(str1)
    li      $v0, 4
    syscall

    li      $a1, 100                # read strTest
    la      $a0, strTest
    li      $v0, 8
    syscall
    
    jal capitalizeString
    j main

capitalizeString:
.data
capital: .asciiz "The capitalized string is : \n"

.text
conversion:	 li $v0, 0	 
		 lb $t2, ($a0)
		 add $t1, $t2, 0 
		 beq $t2, $0, exit
 		 blt $t2, 48, error 	#$v0 < 48?
	 	 bgt $t2, 122, error 	#$v0 > 122?
		 blt $t2, 57, next 	#$v0 < 57?
		 blt $t2, 65, error 	#$v0 < 65?
		 blt $t2, 90, next 	#$v0 < 90?
		 blt $t2, 97, error 	#$v0 < 97?
		 sub $t2, $t2, 32
		 sb $t2, ($a0)	
		 sb $t1, ($a1) 
next:
		 addi $a0, $a0, 1 
		 addi $a1, $a1, 1 	
		 j conversion
error: 	 
		 li $v0, 1			#store 1
		 j exit
exit:
	      	la $a0, capital
	      	li $v0, 4
	      	syscall
	      	jr $ra
	      	

	      	
deleteCharacters:
.data
position: .asciiz "\n Enter position: "
number: .asciiz "\n Enter number of characters"
.text
    addiu   $sp, $sp, -4            # save space
    sw      $ra, 0($sp)             # push $ra
    la      $a0, str1               # print(str1)
    li      $v0, 4
    syscall

    li      $a1, 100                 # read strTest
    la      $a0, strTest
    li      $v0, 8
    syscall      
    
    la      $a0, position               # print(position)
    li      $v0, 4
    syscall

    li      $v0, 51
    syscall
    
    la      $a0, number               # print(position)
    li      $v0, 4
    syscall

    li      $v0, 51
    syscall
    
    jal deleteString
    j main
    

deleteString:
.data
delete: .asciiz "\n The deleted string is .."
.text
	la $a0, delete
	li $v0, 4
	syscall
	j main
          	



quit:
.data

quitting: .asciiz "Program quitting"
.text

la $a0 , quitting
li $v0, 4
syscall
li $v0, 10
syscall 
	      	


	         
	







