
# Program:
        .text
        
        # Var x decl in .data with value 8
            
        li $t8, 758  # Num 758 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        li $t8, 68  # Num 68 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $t8, x  # Identifier x to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        li $t8, 9  # Num 9 to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $t9, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $t8, ($sp)
            
        add $t8, $t8, $t9  # + operation
                
        sw $t8, ($sp)
            
        lw $t9, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $t8, ($sp)
            
        mul $t8, $t8, $t9  # * operation
            
        sw $t8, ($sp)
            
        lw $t9, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $t8, ($sp)
            
        sub $t8, $t8, $t9  # - operation
            
        sw $t8, ($sp)
            
        lw $t8, ($sp)  # assign value to var x
        sw $t8, x
            
        addi $sp, $sp, 4  # raising sp after expression
                
        lw $t8, x  # Identifier x to stack
        addi $sp, $sp, -4
        sw $t8, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        x: .word 8
                