
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        b OhFZhdDKPXEnd
OhFZhdDKPX:
# Function Preamble of OhFZhdDKPX:
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
        
# Function Body of OhFZhdDKPX:
        
# If Elif Else block
        
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        beq $s0, $s1, conTrue3  # comparator ==
            
conFalse3:
        li $s0, 0  # comparator descision
        b conExit3
conTrue3:
        li $s0, 1
conExit3:
        sw $s0, ($sp)
            
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        beq $s0, $s1, conTrue4  # comparator ==
            
conFalse4:
        li $s0, 0  # comparator descision
        b conExit4
conTrue4:
        li $s0, 1
conExit4:
        sw $s0, ($sp)
            
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        bne $s0, $zero, doOr5
        bne $s1, $zero, doOr5
        li $s0, 0
        b exitLogic5
doOr5:
        li $s0, 1
exitLogic5:
            
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq $s0, $zero, ifBlockSkip2
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b OhFZhdDKPXReturn
        
        b exitIf1  # goto if end
ifBlockSkip2:
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq $s0, $zero, ifBlockSkip6
        
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # recur
        la $s4, OhFZhdDKPX
        addi $sp, $sp, -4
        sw $s4, ($sp)
        
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        
        # push arg 1
            
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        sub $s0, $s0, $s1  # - operation
            
        sw $s0, ($sp)
            
        # final call
        lw $s4, 8($sp)
        jalr $s4
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        mul $s0, $s0, $s1  # * operation
            
        sw $s0, ($sp)
            
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b OhFZhdDKPXReturn
        
        b exitIf1  # goto if end
ifBlockSkip6:
        
exitIf1:
        
        # End of func OhFZhdDKPX
OhFZhdDKPXReturn:
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
OhFZhdDKPXEnd:
        
        # push func pointer
        la $t0, OhFZhdDKPX
        addi $sp, $sp, -4
        sw $t0, ($sp)
        
        lw $s0, ($sp)  # init variable factorial
        addi $sp, $sp, 4
        sw $s0, factorial
            
        lw $s0, factorial  # Identifier factorial to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        
        # push arg 1
            
        li $s0, 1  # Num 1 to stack
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
        
        factorial: .space 4
                