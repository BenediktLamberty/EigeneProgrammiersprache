
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        # Var g decl in .data with value 9
            
        b idEnd
id:
# Function Preamble of id:
        # data allocation 1 vars:
        addi $sp, $sp, -4
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
        
# Function Body of id:
        
        # Decl local Var
            
        li $s0, 12  # Num 12 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable h
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        lw $s0, 40($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, g  # Identifier g to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        add $s0, $s0, $s1  # + operation
                
        sw $s0, ($sp)
            
        lw $s0, 36($fp)  # Identifier h to stack
            
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
        b idReturn
        
        # End of func id
idReturn:
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
        addi $sp, $sp, 44
        # restore $fp
        lw $fp, ($sp)
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
idEnd:
        
        # Call of func id
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 1
                
        li $s0, 69  # Num 69 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal id
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        g: .word 9
                