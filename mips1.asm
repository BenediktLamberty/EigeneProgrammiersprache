
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
# list decl and init
            
        b lEzdGiRdpoEnd
lEzdGiRdpo:
# Function Preamble of lEzdGiRdpo:
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
        
# Function Body of lEzdGiRdpo:
        
# If Elif Else block
        
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        ble $s0, $s1, conTrue4  # comparator <=
            
conFalse4:
        li $s0, 0  # comparator descision
        b conExit4
conTrue4:
        li $s0, 1
conExit4:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq $s0, $zero, ifBlockSkip3
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b lEzdGiRdpoReturn
        
        b exitIf2  # goto if end
ifBlockSkip3:
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq $s0, $zero, ifBlockSkip5
        
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # recur
        la $s4, lEzdGiRdpo
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
        b lEzdGiRdpoReturn
        
        b exitIf2  # goto if end
ifBlockSkip5:
        
exitIf2:
        
        # End of func lEzdGiRdpo
lEzdGiRdpoReturn:
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
lEzdGiRdpoEnd:
        
        # push func pointer
        la $t0, lEzdGiRdpo
        addi $sp, $sp, -4
        sw $t0, ($sp)
        
        # first malloc
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # list pointer to reg
        move $t2, $v0
        move $s2, $v0
        
        # fill list
        li $t1, 0
startFill1:
        ble $t1, $zero, endFill1
        addi $t1, $t1, -1
        # save elem
        lw $t0, ($sp)
        addi $sp, $sp, 4
        sw $t0, ($t2)
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # link list
        sw $v0, 4($t2)
        move $t2, $v0
        b startFill1
endFill1:  
        # save elem
        lw $t0, ($sp)
        addi $sp, $sp, 4
        sw $t0, ($t2)
        # null pointer
        sw $zero, 4($t2) 
        # list ptr to stack
        addi $sp, $sp, -4
        sw $s2, ($sp)
            
        lw $s0, ($sp)  # init variable A
        addi $sp, $sp, 4
        sw $s0, A
            
        #list member expr
            
        lw $s0, A  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav6:
        ble $t1, $zero, endTrav6
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav6
endTrav6:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        # Call of func
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
        
        # push arg 1
            
        li $s0, 5  # Num 5 to stack
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
        
        A: .space 4
                