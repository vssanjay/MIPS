.data

data : .word    0 : 1000000

.text

main :
    li $t0, 1000000     # $t0 = number of columns
    move $s0, $zero     # counter
    move $s1, $zero     # counter
    move $t2, $zero     # $t2 = the value to be stored
    subi $t1, $zero, 1
    jal generateref

    jal fifoDM16_64

    jal quit

generateref :
    mult $s0, $t0       
    mflo $s2            # move multiply result from lo register to $s2
    add $s2, $s2, $s1   
    sll $s2, $s2, 2     # $s2 *= 4 (shift left 2 bits) for byte offset

    li $a1, 2147483647
    li $v0, 42
    syscall

    sw $a0, data($s2)   # store the value in matrix element

    addi $s1, $s1, 1    # increment column counter
    bne $s1, $t0, genref # not at end of row so loop back
    move $s1, $zero     # reset column counter
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    jr $ra

DM16KB_64 :
    addi $t1, $t1, 1
    lw $s0, data($t1)

    sll $s2, $s0, 18
    srl $s1, $s2, 24
    srl $s2, $s0, 14

DM16KB_64_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM16_64

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
	subi $t2, $zero, 4

	move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

DM16KB_128 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 18
    srl $s1, $s2, 25
    srl $s2, $s0, 14

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)
	

DM16KB_128_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM16_128

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal DM16KB_256
	
fifoDM16_1024 :
    addi $t3, $t3, 1 
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 18
    srl $s1, $s2, 28
    srl $s2, $s0, 14

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)
	
	    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall
DM16KB_1024_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, DM16KB_4096

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t9
    li $v0, 4
    syscall

    move $t5, $zero

    jal DM64KB_64


DM64KB_64 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 16
    srl $s1, $s2, 22
    srl $s2, $s0, 16

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, DM64KB_64_sw

    bne $t0, $t3, fifoDM64_64
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal DM64KB_128


fifoDM64_64_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM64_64

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM64_128
fifoDM64_4096_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM64_4096

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t9
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM256_64
fifoDM256_128_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM256_128

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM256_256


fifoDM256_256 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 14
    srl $s1, $s2, 22
    srl $s2, $s0, 18

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM256_256_sw

    bne $t0, $t3, fifoDM256_256
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM256_1024


fifoDM256_256_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM256_256

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM256_1024


fifoDM256_1024 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 14
    srl $s1, $s2, 24
    srl $s2, $s0, 18

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM256_1024_sw

    bne $t0, $t3, fifoDM256_1024
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM256_4096
fifoDM512_64 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 13
    srl $s1, $s2, 19
    srl $s2, $s0, 19

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM512_64_sw

    bne $t0, $t3, fifoDM512_64
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_128


fifoDM512_64_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM512_64

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_128


fifoDM512_128 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 13
    srl $s1, $s2, 20
    srl $s2, $s0, 19

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM512_128_sw

    bne $t0, $t3, fifoDM512_128
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_256


fifoDM512_128_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM512_128

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_256


fifoDM512_256 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 13
    srl $s1, $s2, 21
    srl $s2, $s0, 19

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM512_256_sw

    bne $t0, $t3, fifoDM512_256
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_1024


fifoDM512_256_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM512_256

    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_1024


fifoDM512_1024 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 13
    srl $s1, $s2, 23
    srl $s2, $s0, 19

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    bne $s3, $s2, fifoDM512_1024_sw

    bne $t0, $t3, fifoDM512_1024
    move $s1, $zero
    move $s0, $zero
    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_4096


fifoDM512_1024_sw :
    sw $s2, 0x103e0900($t4)
    addi $t5, $t5, 1

    bne $t0,$t3, fifoDM512_1024

    move $s1, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t8
    li $v0, 4
    syscall

    move $t5, $zero

    jal fifoDM512_4096


fifoDM512_4096 :
    addi $t3, $t3, 1
    addi $t2, $t2, 4
    lw $s0, data($t2)

    sll $s2, $s0, 13
    srl $s1, $s2, 25
    srl $s2, $s0, 19

    sll $t4, $s1, 2
    lw $s3, 0x103e0900($t4)

    move $s2, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    subi $t2, $zero, 4

    move $a0, $t5
    li $v0, 1
    syscall

    move $a0, $t9
    li $v0, 4
    syscall
    syscall

    move $t5, $zero

    jal quit
	


quit :
    li $v0, 10
    syscall