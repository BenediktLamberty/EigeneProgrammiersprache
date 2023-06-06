
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
        b mainEnd
main:
# Function Preamble of main:
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
        
# Function Body of main:
        
        # Decl local Var
            
# list decl and init
            
        li $s0, 444  # Num 444 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 333  # Num 333 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 222  # Num 222 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 111  # Num 111 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 100  # Num 100 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # first malloc
        # malloc
        li $a0, 8
        li $v0, 9
        syscall
        # list pointer to reg
        move $t2, $v0
        move $s2, $v0
        
        # fill list
        li $t1, 4
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
            
        lw $s0, ($sp)  # init variable x
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        li $s0, 69  # Num 69 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 2  # Num 2 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav2:
        ble $t1, $zero, endTrav2
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav2
endTrav2:
            
        # push pointer to stack
        addi $sp, $sp, -4
        sw $t2, ($sp)
                
        # store value at ptr
        lw $t2, ($sp)
        addi $sp, $sp, 4
        lw $t0, ($sp)
        sw $t0, ($t2)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
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
startTrav3:
        ble $t1, $zero, endTrav3
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav3
endTrav3:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav4:
        ble $t1, $zero, endTrav4
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav4
endTrav4:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 2  # Num 2 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav5:
        ble $t1, $zero, endTrav5
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav5
endTrav5:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 3  # Num 3 to stack
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
                
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        #list member expr
            
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 4  # Num 4 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav7:
        ble $t1, $zero, endTrav7
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav7
endTrav7:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        # End of func main
mainReturn:
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
        # return $v0
        sw $v0, ($sp)
        # final return
        jr $ra
mainEnd:
        
        # Call of func main
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # final call
        jal main
        
        addi $sp, $sp, 4  # raising sp after expression
                
# Global Variables
        .data
        