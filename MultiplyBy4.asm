# Now, how about input?
# Author: Saad Biaz
# August 26,2016
# Objective: demo about how to input an integer

.data
prompt: .asciiz "Enter an integer between 1-10 : "

wronginput: .asciiz "Wrong value, try again between 1-10 \n"
.text

main: 
      li $t0, 0
      li $t1, 10
      la   $a0, prompt      # load address of prompt for syscall
      li   $v0, 4           # specify Print String service (See MARS Help --> Tab System Calls)
      syscall               # System call to execute service # 4 (in Register $v0)
      li   $v0, 51          # specify Read Integer service (#51)
      syscall               # System call to execute service # 51 (in Register $v0) : Read the number. After this instruction, the number read is in Register $a0.
      move $t3, $a0
      li   $v0,1
      syscall
      jal conditions
      
conditions:
      ble $t3, $t0, ELSE
      bge $t3, $t1, ELSE
      jal printFunction
      ELSE:
          li $v0, 10
          la $a0, wronginput
          li $v0, 4
          syscall
          la   $a0, prompt      # load address of prompt for syscall
      	  li   $v0, 4           # specify Print String service (See MARS Help --> Tab System Calls)
          syscall               # System call to execute service # 4 (in Register $v0)
          li   $v0, 51          # specify Read Integer service (#51)
          syscall               # System call to execute service # 51 (in Register $v0) : Read the number. After this instruction, the number read is in Register $a0.
          move $t3, $a0
          jal conditions

printFunction:
	addi $t2, $zero, 0
	while:					#While loop begins
		bgt $t2 , $t3, exit
		jal Hello			#Call subroutine Hello
		addi $t2, $t2, 1 
		j while	
				
	exit:	
		li $v0,10
		syscall	
		
		    	    	
     	.data
myString:	.asciiz "Hello World \n"
	.text
Hello : la $a0, myString
	li $v0, 4			# specify Print String Service (#4)
	syscall				# syscall to execute requested service specified in Register $v0 (#4)
	jr $ra				# return from subroutine

	
   
      
      li   $v0, 10          # system call for exit
      syscall               # Exit!
		
###############################################################

