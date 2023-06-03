
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        # Var x decl in .data with value 8
            
        b fEnd
f:
# Function Preamble of f:
        # data allocation 2 vars:
        addi $sp, $sp, -8
        # save $ra
        addi $sp, $sp, -4
        sw $ra, ($sp)
        # save $ss
        
        addi $sp, $sp, -4
        sw $s7, ($sp)
            
        addi $sp, $sp, -4
        sw $s6, ($sp)
            
        addi $sp, $sp, -4
        sw $s5, ($sp)
            
        addi $sp, $sp, -4
        sw $s4, ($sp)
            
        addi $sp, $sp, -4
        sw $s3, ($sp)
            
        addi $sp, $sp, -4
        sw $s2, ($sp)
            
        addi $sp, $sp, -4
        sw $s1, ($sp)
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
            
        # $fp = $sp
        move $fp, $sp
        
# Function Body of f:
        
        # Decl local Var
            
        li $s0, 8  # Num 8 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable z
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        # Decl local Var
            
        li $s0, 9  # Num 9 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable u
        addi $sp, $sp, 4
        sw $s0, 40($fp)
            
        lw $s0, 40($fp)  # Identifier u to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var z
        sw $s0, 36($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        lw $s0, 44($fp)  # Identifier y to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 36($fp)  # Identifier z to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        add $s0, $s0, $s1  # + operation
                
        sw $s0, ($sp)
            
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b fReturn
        
        # End of func f
fReturn:
        # $ss restore
        
        lw $s0, 0($fp)
            
        lw $s1, 4($fp)
            
        lw $s2, 8($fp)
            
        lw $s3, 12($fp)
            
        lw $s4, 16($fp)
            
        lw $s5, 20($fp)
            
        lw $s6, 24($fp)
            
        lw $s7, 28($fp)
            
        # $ra restore
        lw $ra, 32($fp)
        # $sp return
        addi $sp, $sp, 48
        # restore $fp
        lw $fp, ($sp)
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
fEnd:
        
        # Call of func f
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 1
                
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal f
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        x: .word 8
                