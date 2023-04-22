
	.text
	li $s0, 67676767
	
	jal fuc
	
	b exit












fuc: 
# prologue
	# args -> max args von fuc calls
	# push = (4(args) + weitereArgs + 8(saves) + 2(stacktemps) + 1(ra) + 1(empty) + localData) * 4
	# push = ( 4 + 2 + 8 + 1 + 1 + 4) * 4 = 80
	addiu $sp, $sp, -88
	
	# an 4 * (4 + 2 + 8 + 2) = 56
	sw $ra, 64($sp)  # save ra
	
	# saving $ss and stack $ts
	# an 4 * (4 + 2) = 24
	sw $s0, 24($sp)
	sw $s1, 28($sp)
	sw $s2, 32($sp)
	sw $s3, 36($sp)
	sw $s4, 40($sp)
	sw $s5, 44($sp)
	sw $s6, 48($sp)
	sw $s7, 52($sp)
	sw $t8, 56($sp)
	sw $t9, 60($sp)

# body
	# do something
	
	addi $sp, $sp, -4
	addi $sp, $sp, 4
	li $s0, 27983045
	
	
	# save return value
	li $v0, 00101
	
# epilogue
	# loading $ss
	lw $s0, 24($sp)
	lw $s1, 28($sp)
	lw $s2, 32($sp)
	lw $s3, 36($sp)
	lw $s4, 40($sp)
	lw $s5, 44($sp)
	lw $s6, 48($sp)
	lw $s7, 52($sp)
	lw $t8, 56($sp)
	lw $t9, 60($sp)
	
	#restore $ra
	lw $ra, 64($sp)
	
	# pop stack frame
	addiu $sp, $sp, 88
	
	# return
	jr $ra


exit:





















	
	
	