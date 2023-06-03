
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        b fiboEnd
fibo:
# Function Preamble of fibo:
        # data allocation 3 vars:
        addi $sp, $sp, -12
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
        
# Function Body of fibo:
        
        # Decl local Var
            
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable a
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        # Decl local Var
            
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable b
        addi $sp, $sp, 4
        sw $s0, 40($fp)
            
whileCondition1:
            
        lw $s0, 48($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        bgt $s0, $s1, conTrue2  # comparator >
            
        li $s0, 0  # comparator descision
        b conExit2
conTrue2:
        li $s0, 1
conExit2:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile1
            
        # Body of While Loop
        
        lw $s0, 48($fp)  # Identifier x to stack
            
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
            
        lw $s0, ($sp)  # assign value to var x
        sw $s0, 48($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        # Decl local Var
            
        lw $s0, 40($fp)  # Identifier b to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable c
        addi $sp, $sp, 4
        sw $s0, 44($fp)
            
        lw $s0, 36($fp)  # Identifier a to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 40($fp)  # Identifier b to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        add $s0, $s0, $s1  # + operation
                
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # assign value to var b
        sw $s0, 40($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        lw $s0, 44($fp)  # Identifier c to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var a
        sw $s0, 36($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        b whileCondition1  # looping while
exitWhile1:
            
        lw $s0, 36($fp)  # Identifier a to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b fiboReturn
        
        # End of func fibo
fiboReturn:
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
        addi $sp, $sp, 52
        # restore $fp
        lw $fp, ($sp)
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
fiboEnd:
        
        # Call of func fibo
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 1
                
        li $s0, 11  # Num 11 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal fibo
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
# Global Variables
        .data
        