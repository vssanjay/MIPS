.data
return:		.asciiz "\n"
blank:		.asciiz " "
summary:	.asciiz "Miss, Total, Penalty, Time:\n"
cache:				
cache1:		.word 256, 8,6	# cache 16K block 64B = n block, lg(n), block offset	
cache2:		.word 128, 7,7	# cache 16K block 128B
cache3:		.word 64,  6,8	# cache 16K block 256B
cache4:		.word 16,  4,10	# cache 16K block 1KB
cache5:		.word 4,   2,12	# cache 16K block 4KB
cache6:		.word 1024,10,6	# cache 64K block 64B
cache7:		.word 512, 9,7	# cache 64K block 128B
cache8:		.word 256, 9,8	# cache 64K block 256B
cache9:		.word 64,  6,10	# cache 64K block 1KB
cache10:	.word 16,  4,12	# cache 64K block 4KB
cache11:	.word 4096,12,6	# cache 256K block 64B
cache12:	.word 2048,11,7	# cache 256K block 128B
cache13:	.word 1024,10,8	# cache 256K block 256B
cache14:	.word 256, 8,10	# cache 256K block 1KB
cache15:	.word 64,  6,12	# cache 256K block 4KB
cache16:	.word 8192,13,6	# cache 512K block 64B
cache17:	.word 4096,12,7	# cache 512K block 128B
cache18:	.word 2048,11,8	# cache 512K block 256B
cache19:	.word 512, 9,10	# cache 512K block 1KB
cache20:	.word 128, 7,12	# cache 512K block 4KB
nBlock:		.word 0
lgNBlock:	.word 0
offset:		.word 0
index:		.word 0
way:		.word 0
referenceCounter:	.word 1 # different with 0
cacheArray:	.space 32768
referenceArray:	.space 32768
missCounter:	.word 0
accessTime:	.word 0
penalty:	.word 0
lgSetSize:	.word 0
#test:		.space 67108864
.text
main: 
	la $a0, cache10		# Chose 20 diferent cache and block size combination # 5,4,10
	jal getCache
				# Chose how cache organised
	jal setVarIndexDirect 	# 1. Direct map
	#jal setVarIndex4Way	# 2. 4-way asssosiative
	#jal setVarIndexFull	# 3. Fully asssosiative
				# Chose FIFO or LRU
	li $s5, 0		# A. FIFO
	#li $s5, 1		# B. LRU
	
	jal cleanReferenceArray
				# chose RNG seed 0 RNG 0 
	li $a0, 0
	jal setRandomSeed	
				# Choose how many random number you want to use
	li $s6,1000000		# $s6 max
	li $s7,0		# $s7 index
loop:
	beq $s7, $s6, quit
		
	jal setA0RandomNum
	jal setS0TagS1IndexS2SetAddress
	jal setS3TotalOffsetS4R
	jal replaceIfS4
	
	addi $s7,$s7,1
	j loop
quit:				# after loop
	#jal printCacheArray	
	#jal printReferenceArray	
	jal printSummary
				# Exit
    	li   $v0, 10      
    	syscall

########## None->$s3,$4
.data
.text
setS3TotalOffsetS4R:
	la $t0, way
	lw $t0, 0($t0)	# $t0 max
	li $t1, 0	# $t1 counter
	la $t2, cacheArray	# $t2 cache head
	la $t4, referenceArray	# $t4 reference head
loopSetS3TotalOffsetS4R:
	beq $t1, $t0, capacity
	add $s3, $t1, $t1	# s3 2x
	add $s3, $s3, $s3	# s3 4x
	add $s3, $s3, $s2	# +s2
	
	add $t3, $s3, $t4	# total + reference
	lw $t3, 0($t3)		# reference content
	li $t5,0
	beq $t3, $t5, compulsory
	
	add $t3, $s3, $t2	# total + cache
	lw $t3, 0($t3)		# tag content
	beq $t3, $s0, hit
	
	addi $t1, $t1, 1
	j loopSetS3TotalOffsetS4R
capacity:
	li $s4, 1		# need replace operation
	
	la $t6, referenceCounter# reference counter + 1
	lw $t7, 0($t6)			
	addi $t7,$t7,1		
	sw $t7, 0($t6)
	
	la $t6, missCounter	# +1 miss
	lw $t7, 0($t6)
	addi $t7,$t7,1
	sw $t7, 0($t6)
	
	# access time
	la $t8, penalty
	lw $t8, 0($t8)
	la $t6, accessTime
	lw $t7, 0($t6)
	add $t7,$t7,$t8	# accesstime + penalty
	sw $t7, 0($t6)
	
	jr $ra
compulsory:
	li $s4, 0		# no need for replace
	
	la $t6, referenceCounter
	lw $t7, 0($t6)
	
	add $t3, $s3, $t4	# update reference
	sw $t7, 0($t3)		
	
	addi $t7,$t7,1		# reference counter + 1
	sw $t7, 0($t6)
	
	add $t3, $s3, $t2	# cache + offset save tag
	sw $s0, 0($t3)
	
	la $t6, missCounter	# +1 miss
	lw $t7, 0($t6)
	addi $t7,$t7,1
	sw $t7, 0($t6)
	
	# access time
	la $t8, penalty
	lw $t8, 0($t8)
	la $t6, accessTime
	lw $t7, 0($t6)
	add $t7,$t7,$t8	# accesstime + penalty
	sw $t7, 0($t6)

	jr $ra
hit:
	li $s4, 0		# no need for replace
	
	la $t6, referenceCounter
	lw $t7, 0($t6)
	
	beqz $s5, skipHit
	add $t3, $s3, $t4	# update reference if LRU
	sw $t7, 0($t3)		
skipHit:	
	addi $t7,$t7,1		# reference counter + 1
	sw $t7, 0($t6)
	
	la $t6, accessTime
	lw $t7, 0($t6)
	addi $t7,$t7,1		# accesstime + 1
	sw $t7, 0($t6)
	
	jr $ra
	
########## $a0->None
.data
.text
setRandomSeed:
	move $t1,$a1
	li $a1,0
	li $v0,40
	syscall 
	move $a1,$t1
	jr $ra

########## $a0->$s0
.data
.text
setS0TagS1IndexS2SetAddress: 
	la $t1,offset
	lw $t1,0($t1)
	srlv $s0,$a0,$t1	# remove the offset
	
	la $t1,index		#
	lw $t1, 0($t1)
	li $t0, 0xffffffff	
	sllv $t0,$t0, $t1	# index mask <-
	xori $t0,$t0, 0xffffffff# flip bits
	and  $s1,$s0, $t0
	srlv $s0,$s0, $t1	# remove the index
	move $s2,$s1
	add $s2,$s2,$s2
	add $s2,$s2,$s2		# 4x word size
	la $t2, lgSetSize	# consider set size
	lw $t2, 0($t2)
	sllv $s2,$s2,$t2	# times n-way
	jr $ra

########## None->None
.data
.text
setVarIndexDirect: 
	la $t1, lgNBlock
	lw $t1, 0($t1)
	la $t2, index
	sw $t1, 0($t2)
	la $t1, way
	li $t2, 1
	sw $t2, 0($t1)
	jr $ra

########## None->None
.data
.text
setVarIndex4Way: 
	la $t1, lgNBlock
	lw $t1, 0($t1)
	addi $t1, $t1, -2	
	la $t3, lgSetSize	# set size
	li $t4, 2
	sw $t4, 0($t3)
	la $t2, index
	sw $t1, 0($t2)
	la $t1, way
	li $t2, 4
	sw $t2, 0($t1)
	jr $ra

########## None->None
.data
.text
setVarIndexFull: 
	li $t1, 0
	la $t2, index
	sw $t1, 0($t2)
	la $t1, way
	la $t2, nBlock
	lw $t2, 0($t2)
	sw $t2, 0($t1)
	jr $ra
	
########## $s0,$s1->None
.data
.text
replaceIfS4:
	beqz $s4, passReplaceIfS4		
	la $t0, way
	lw $t0, 0($t0)		# max
	li $t1, 0		# index
	la $t2, cacheArray	# head
	la $t4, referenceArray  #
	add $t3, $t4, $s2	# 
	lw $t5,0($t3)		# inital reference $t5
	move $t6, $s2		# inital total offset $t6
loopReplaceIfS4:		# 
	beq $t1, $t0, quitReplaceIfS4
	add $t3, $t1, $t1
	add $t3, $t3, $t3	# $t3 4x 
	add $t3, $t3, $s2	# $s2 offset without associativity
	
	add $t7, $t3, $t4	# t3 total + head reference
	lw $t7, 0($t7)
	sltu $t8,$t7,$t5	# if current $t7 smaller, $t8 1
	beqz $t8, skipReplaceIfS4	# otherwise skip if
	move $t5, $t7		# current reference value
	move $t6, $t3		# current total offset
skipReplaceIfS4:	
	addi $t1, $t1, 1
	j loopReplaceIfS4
quitReplaceIfS4:
	la $t3, referenceCounter # have already +1
	lw $t7,0($t3)
	addi $t7,$t7,-1
	add $t8,$t6,$t4
	sw $t7,0($t8)		# store original reference
	
	add $t8,$t6,$t2		# cache head update the cache tag
	sw $s0,0($t8)	
passReplaceIfS4:
	jr $ra

########## None->None
.data
.text
printReferenceArray:
	move $t4, $a0
	la $t2, referenceArray
	la $t0, nBlock
	lw $t0, 0($t0)		# max
	li $t1, 0		# index
loopPrintReferenceArray:
	beq $t1, $t0, quitPrintReferenceArray
	add $t3, $t1, $t1
	add $t3, $t3, $t3
	add $t3, $t3, $t2
	lw $a0, 0($t3)
	li $v0,1
	syscall
	la $a0, blank
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1
	j loopPrintCacheArray
quitPrintReferenceArray:
	la $a0, return
	li $v0, 4
	syscall
	move $a0,$t4
	jr $ra      

########## None->None
.data
.text
cleanReferenceArray:
	la $t2, referenceArray
	la $t0, nBlock
	lw $t0, 0($t0)		# max
	li $t1, 0		# index
loopCleanReferenceArray:
	beq $t1, $t0, quitCleanReferenceArray
	add $t3, $t1, $t1
	add $t3, $t3, $t3
	add $t3, $t3, $t2
	
	li $t4, 0
	sw $t4, 0($t3)		# clean all bytes into zero

	addi $t1, $t1, 1
	j loopCleanReferenceArray
quitCleanReferenceArray:
	jr $ra       
	                                   
########## None->None
.data
.text
printCacheArray:
	move $t4, $a0
	la $t2, cacheArray
	la $t0, nBlock
	lw $t0, 0($t0)		# max
	li $t1, 0		# index
loopPrintCacheArray:
	beq $t1, $t0, quitPrintCacheArray
	add $t3, $t1, $t1
	add $t3, $t3, $t3
	add $t3, $t3, $t2
	lw $a0, 0($t3)
	li $v0,1
	syscall
	la $a0, blank
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1
	j loopPrintCacheArray
quitPrintCacheArray:
	la $a0, return
	li $v0, 4
	syscall
	move $a0,$t4
	jr $ra

########## $a0->None
.data
.text
printSummary:
	move $a0, $t0
	
	la $a0, summary  
	li $v0, 4
	syscall
	
	la $a0, missCounter
	lw $a0, 0($a0)
	li $v0,1
	syscall
	la $a0, blank
	li $v0, 4
	syscall
	
	la $a0, referenceCounter
	lw $a0, 0($a0)
	addi $a0, $a0,-1 # start from 1 over counted
	li $v0,1
	syscall
	la $a0, blank
	li $v0, 4
	syscall
	
	la $a0, penalty
	lw $a0, 0($a0)
	li $v0,1
	syscall
	la $a0, blank
	li $v0, 4
	syscall
	
	la $a0, accessTime
	lw $a0, 0($a0)
	li $v0,1
	syscall
	la $a0, return
	li $v0, 4
	syscall
	
	move $a0,$t0
	jr $ra	 
	 	 	 
########## $a0->None
.data
.text
printA0Num:
	move $t0,$a0  
	li $v0, 1
	syscall
	la $a0, return
	li $v0, 4
	syscall
	move $a0,$t0
	jr $ra

########## $a0->None
.data
.text
printA0AddressNum:
	move $t4, $a0 
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	la $a0, return
	li $v0, 4
	syscall
	move $a0, $t4
	jr $ra
	
		
########## $a0->$a0
.data
.text
setA0RandomNum:
	li $v0, 41
	syscall
	jr $ra

########## $a0->None
.data
.text
getCache:  
	la,$a1,nBlock # save to nBlock
	lw,$a2,0($a0)
	sw,$a2,0($a1)
	la,$a1,lgNBlock # save to index
	lw,$a2,4($a0)
	sw,$a2,0($a1)
	la,$a1,offset # save to offset
	lw,$a2,8($a0)
	sw,$a2,0($a1)
	addi $t0,$a2,-2 # save to penalty
	li $t1,1
	sllv $t1,$t1,$t0
	la $t0, penalty
	sw $t1, 0($t0)
	jr $ra
