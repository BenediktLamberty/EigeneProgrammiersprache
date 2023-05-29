
# Program:
        .text
        
startDoWhile1:
            
        # Body of While Loop
        
        li $t8, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        li $t8, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $t8, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        bne $t8, $zero, startDoWhile1
            
# Global Variables
        .data
        