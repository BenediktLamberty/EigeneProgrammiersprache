
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        li $s0, 69  # Num 69 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        