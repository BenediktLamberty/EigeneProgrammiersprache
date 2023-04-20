
# Program:
        .text
        
        li $t8, 10  # Num 10 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        li $t8, 20  # Num 20 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $t8, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $t9, ($sp)
            
        sub $t8, $t8, $t9
            
        sw $t8, ($sp)
            
        lw $t8, ($sp)  # init variable x
        sw $t8, x
            
        lw $t8, x  # Identifier x to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        x: .space 4
                