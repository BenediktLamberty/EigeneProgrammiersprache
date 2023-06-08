
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
# list decl and init
            
        li $s0, 3  # Num 3 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 2  # Num 2 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 0  # Num 0 to stack
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
        li $t1, 3
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
        sw $s0, x
            
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)
        addi $sp, $sp, 4
        # travList
travStart2:
        lw $t2, 4($s1)
        beq $t2, $zero, travEnd2
        move $s2, $s1
        move $s1, $t2
        b travStart2
travEnd2:
        # poped value on stack
        lw $t0, ($s1)
        addi $sp, $sp, -4
        sw $t0, ($sp)
        # unlink list
        sw $zero, 4($s2)
            
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        
        # Var i decl in .data with value 0
            
whileCondition3:
            
        lw $s0, i  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        move $t0, $zero
        lw $s2, ($sp)
        addi $sp, $sp, 4
        beq $s2, $zero, travEnd4
travStart4:
        addi $t0, $t0, 1
        lw $t2, 4($s2)
        beq $t2, $zero, travEnd4
        move $s2, $t2
        b travStart4
travEnd4:
        addi $sp, $sp, -4
        sw $t0 ($sp)
            
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        blt $s0, $s1, conTrue5  # comparator <
            
conFalse5:
        li $s0, 0  # comparator descision
        b conExit5
conTrue5:
        li $s0, 1
conExit5:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile3
            
        # Body of While Loop
        
        #list member expr
            
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, i  # Identifier i to stack
            
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
        
        lw $s0, i  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # Binary operation
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        add $s0, $s0, $s1  # + operation
                
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # assign value to var i
        sw $s0, i
                
        addi $sp, $sp, 4  # raising sp after expression
                
        b whileCondition3  # looping while
exitWhile3:
            
# Global Variables
        .data
        
        x: .space 4
                
        i: .word 0
                