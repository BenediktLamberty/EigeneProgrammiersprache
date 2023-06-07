
# Program:
        .text
        # setting up first $fp
        move $fp, $sp
        
# list decl and init
            
        li $s0, 5  # Num 5 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 4  # Num 4 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
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
        li $t1, 5
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
            
        # Var i decl in .data with value 0
            
whileCondition2:
            
        lw $s0, i  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, x  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        move $t0, $zero
        lw $s2, ($sp)
        addi $sp, $sp, 4
        beq $s2, $zero, travEnd3
travStart3:
        addi $t0, $t0, 1
        lw $t2, 4($s2)
        beq $t2, $zero, travEnd3
        move $s2, $t2
        b travStart3
travEnd3:
        addi $sp, $sp, -4
        sw $t0 ($sp)
            
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        blt $s0, $s1, conTrue4  # comparator <
            
        li $s0, 0  # comparator descision
        b conExit4
conTrue4:
        li $s0, 1
conExit4:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile2
            
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
                
        b whileCondition2  # looping while
exitWhile2:
            
# Global Variables
        .data
        
        x: .space 4
                
        i: .word 0
                