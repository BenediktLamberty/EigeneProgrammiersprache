
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        b uxUaWwPcMxEnd
uxUaWwPcMx:
# Function Preamble of uxUaWwPcMx:
        # data allocation 0 vars:
        addi $sp, $sp, -0
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
        
# Function Body of uxUaWwPcMx:
        
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 4  # Num 4 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        mul $s0, $s0, $s1  # * operation
            
        sw $s0, ($sp)
            
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b uxUaWwPcMxReturn
        
        # End of func uxUaWwPcMx
uxUaWwPcMxReturn:
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
        addi $sp, $sp, 40
        # restore $fp
        lw $fp, ($sp)
        # accord for func ptr
        addi $sp, $sp, 4
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
uxUaWwPcMxEnd:
        
        # push func pointer
        la $t0, uxUaWwPcMx
        addi $sp, $sp, -4
        sw $t0, ($sp)
        
        lw $s0, ($sp)  # init variable g
        addi $sp, $sp, 4
        sw $s0, g
            
        b aKVqyEDftQEnd
aKVqyEDftQ:
# Function Preamble of aKVqyEDftQ:
        # data allocation 0 vars:
        addi $sp, $sp, -0
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
        
# Function Body of aKVqyEDftQ:
        
        lw $s0, g  # Identifier g to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b aKVqyEDftQReturn
        
        # End of func aKVqyEDftQ
aKVqyEDftQReturn:
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
        addi $sp, $sp, 36
        # restore $fp
        lw $fp, ($sp)
        # accord for func ptr
        addi $sp, $sp, 4
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
aKVqyEDftQEnd:
        
        # push func pointer
        la $t0, aKVqyEDftQ
        addi $sp, $sp, -4
        sw $t0, ($sp)
        
        lw $s0, ($sp)  # init variable f
        addi $sp, $sp, 4
        sw $s0, f
            
        lw $s0, f  # Identifier f to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        
        # final call
        lw $s4, 4($sp)
        jalr $s4
        
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        
        # push arg 1
            
        li $s0, 4  # Num 4 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        lw $s4, 8($sp)
        jalr $s4
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        
        g: .space 4
                
        f: .space 4
                