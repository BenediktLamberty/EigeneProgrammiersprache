	.data
obj: .word 0

	.text

# attribute: 
# priv const 	7316439486881575421	0	111
# publ		4652251084249969523	3	222
# priv		5934087373776604857	1	333

	li $a0 48 # 12(len+1) -> 48 (3 attribute)
	li $v0 9 # malloc
	syscall
	
	# save obj pointer
	move $s0, $v0

	# beschreibe const
	li $t0, 3 # len
	sw $t0, 0($s0)
	li $t0, 1 # type
	sw $t0, 4($s0)
	# constr leer
	# attribute:
	# 1--------
	li $t0, 7316439486881575421
	sw $t0, 12($s0)
	li $t0, 0
	sw $t0, 16($s0)
	li $t0, 111
	sw $t0, 20($s0)
	# 2---------
	li $t0, 4652251084249969523
	sw $t0, 24($s0)
	li $t0, 3
	sw $t0, 28($s0)
	li $t0, 222
	sw $t0, 32($s0)
	# 3---------
	li $t0, 5934087373776604857
	sw $t0, 36($s0)
	li $t0, 1
	sw $t0, 40($s0)
	li $t0, 333
	sw $t0, 44($s0)

# get prop
	li $t0, 0
	lw $t1, ($s0)
	li $t8, 12
	mul $t1, $t1, $t8
	li $t2, 4652251084249969523
	
	beq $t0, $t1, nichtGefunden
	addi $t0,$t0, 12
	lw $t3, $t0($s0)
	
	
	
	
	
	
	
	
	






