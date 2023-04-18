
	.text

	.globl	main
main:	
	li $t1, 0
	li $t2, 10
w_abfr: bge $t1, $t2, w_ende
	addi $t1, $t1, 1
	b w_abfr
w_ende:
