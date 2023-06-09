
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
            
        li $s0, 3  # Num 3 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 5  # Num 5 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 9  # Num 9 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 6  # Num 6 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 4  # Num 4 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        li $s0, 2  # Num 2 to stack
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
        li $t1, 6
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
        sw $s0, 36($fp)
            
        # Call of func bubbleSort
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 1
                
        lw $s0, 36($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal bubbleSort
        
        lw $s0, ($sp)  # assign value to var A
        sw $s0, 36($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        # Call of func print
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 1
                
        lw $s0, 36($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal print
        
        addi $sp, $sp, 4  # raising sp after expression
                
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
        
        b printEnd
print:
# Function Preamble of print:
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
        
# Function Body of print:
        
# block of code
        
        # Decl local Var
            
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable TcHOTqmmee
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        # Decl local Var
            
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable iLFFlUqAZh
        addi $sp, $sp, 4
        sw $s0, 40($fp)
            
        # Decl local Var
            
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable a
        addi $sp, $sp, 4
        sw $s0, 44($fp)
            
# for each loop
        # set ptr var:

        lw $s0, 48($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var TcHOTqmmee
        sw $s0, 36($fp)
                
        addi $sp, $sp, 4
        # check for Null ptr

        lw $s0, 36($fp)  # Identifier TcHOTqmmee to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t2, ($sp)
        addi $sp, $sp, 4
        beq $t2, $zero, endForEach2
forLoop2:

        lw $s0, 36($fp)  # Identifier TcHOTqmmee to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t0, ($sp)
        lw $t0, ($t0)
        sw $t0, ($sp)

        lw $s0, ($sp)  # assign value to var a
        sw $s0, 44($fp)
                
        addi $sp, $sp, 4    
        
        lw $s0, 44($fp)  # Identifier a to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $a0, ($sp)  # outputting an int !!!
        addi $sp, $sp, 4
        li $v0, 1
        syscall
        

        lw $s0, 36($fp)  # Identifier TcHOTqmmee to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s2, ($sp)
        addi $sp, $sp, 4
        lw $t2, 4($s2)
        beq $t2, $zero, endForEach2
        addi $sp, $sp, -4
        sw $t2, ($sp)

        lw $s0, ($sp)  # assign value to var TcHOTqmmee
        sw $s0, 36($fp)
                
        addi $sp, $sp, 4

        lw $s0, 40($fp)  # Identifier iLFFlUqAZh to stack
            
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
            
        lw $s0, ($sp)  # assign value to var iLFFlUqAZh
        sw $s0, 40($fp)
                
        addi $sp, $sp, 4
        b forLoop2
endForEach2:
        
        # End of func print
printReturn:
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
printEnd:
        
        b bubbleSortEnd
bubbleSort:
# Function Preamble of bubbleSort:
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
        
# Function Body of bubbleSort:
        
        # Decl local Var
            
        lw $s0, 48($fp)  # Identifier A to stack
            
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
            
        lw $s0, ($sp)  # init variable n
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        # Decl local Var
            
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable swapped
        addi $sp, $sp, 4
        sw $s0, 40($fp)
            
whileCondition4:
            
        lw $s0, 40($fp)  # Identifier swapped to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # Unary ! operation
        beq $zero, $s0, negate5
        li $s0, 0
        b exitNegate5
negate5:
        li $s0, 1
exitNegate5:
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile4
            
        # Body of While Loop
        
        li $s0, 0  # Num 0 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var swapped
        sw $s0, 40($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
# block of code
        
        # Decl local Var
            
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # init variable i
        addi $sp, $sp, 4
        sw $s0, 44($fp)
            
whileCondition6:
            
        lw $s0, 44($fp)  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 36($fp)  # Identifier n to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        blt $s0, $s1, conTrue7  # comparator <
            
conFalse7:
        li $s0, 0  # comparator descision
        b conExit7
conTrue7:
        li $s0, 1
conExit7:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # while loop condition check
        addi $sp, $sp, 4
        beq $s0, $zero, exitWhile6
            
        # Body of While Loop
        
# If Elif Else block
        
        #list member expr
            
        lw $s0, 48($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 44($fp)  # Identifier i to stack
            
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
            
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav10:
        ble $t1, $zero, endTrav10
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav10
endTrav10:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        #list member expr
            
        lw $s0, 48($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 44($fp)  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav11:
        ble $t1, $zero, endTrav11
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav11
endTrav11:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $s1, ($sp)  # comparison
        addi $sp, $sp, 4
        lw $s0, ($sp)
            
        bgt $s0, $s1, conTrue12  # comparator >
            
conFalse12:
        li $s0, 0  # comparator descision
        b conExit12
conTrue12:
        li $s0, 1
conExit12:
        sw $s0, ($sp)
            
        lw $s0, ($sp)  # check if condition
        addi $sp, $sp, 4
        beq $s0, $zero, ifBlockSkip9
        
        # Call of func swap
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # push arg 3
                
        lw $s0, 44($fp)  # Identifier i to stack
            
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
            
        # push arg 2
                
        lw $s0, 44($fp)  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # push arg 1
                
        lw $s0, 48($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # final call
        jal swap
        
        lw $s0, ($sp)  # assign value to var A
        sw $s0, 48($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        li $s0, 1  # Num 1 to stack
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, ($sp)  # assign value to var swapped
        sw $s0, 40($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        b exitIf8  # goto if end
ifBlockSkip9:
        
exitIf8:
        
        lw $s0, 44($fp)  # Identifier i to stack
            
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
        sw $s0, 44($fp)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        b whileCondition6  # looping while
exitWhile6:
            
        b whileCondition4  # looping while
exitWhile4:
            
        lw $s0, 48($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b bubbleSortReturn
        
        # End of func bubbleSort
bubbleSortReturn:
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
bubbleSortEnd:
        
        b swapEnd
swap:
# Function Preamble of swap:
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
        
# Function Body of swap:
        
        # Decl local Var
            
        #list member expr
            
        lw $s0, 40($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 44($fp)  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav13:
        ble $t1, $zero, endTrav13
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav13
endTrav13:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        lw $s0, ($sp)  # init variable x
        addi $sp, $sp, 4
        sw $s0, 36($fp)
            
        #list member expr
            
        lw $s0, 40($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 48($fp)  # Identifier j to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav14:
        ble $t1, $zero, endTrav14
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav14
endTrav14:
            
        # push value to stack
        lw $t0, ($t2)
        addi $sp, $sp, -4
        sw $t0, ($sp)
                
        #list member expr
            
        lw $s0, 40($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 44($fp)  # Identifier i to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav15:
        ble $t1, $zero, endTrav15
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav15
endTrav15:
            
        # push pointer to stack
        addi $sp, $sp, -4
        sw $t2, ($sp)
                
        # store value at ptr
        lw $t2, ($sp)
        addi $sp, $sp, 4
        lw $t0, ($sp)
        sw $t0, ($t2)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        lw $s0, 36($fp)  # Identifier x to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        #list member expr
            
        lw $s0, 40($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $s0, 48($fp)  # Identifier j to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        lw $t1, ($sp)
        addi $sp, $sp, 4
        lw $t2, ($sp)
        addi $sp, $sp, 4
        # traverce
startTrav16:
        ble $t1, $zero, endTrav16
        addi $t1, $t1, -1
        lw $t2, 4($t2)
        b startTrav16
endTrav16:
            
        # push pointer to stack
        addi $sp, $sp, -4
        sw $t2, ($sp)
                
        # store value at ptr
        lw $t2, ($sp)
        addi $sp, $sp, 4
        lw $t0, ($sp)
        sw $t0, ($t2)
                
        addi $sp, $sp, 4  # raising sp after expression
                
        lw $s0, 40($fp)  # Identifier A to stack
            
        addi $sp, $sp, -4
        sw $s0, ($sp)
        
        # retrun call
        lw $v0, ($sp)
        addi $sp, $sp, 4
        b swapReturn
        
        # End of func swap
swapReturn:
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
swapEnd:
        
        # Call of func main
        # Push $ffp
        addi $sp, $sp, -4
        sw $fp, ($sp)
            
        # final call
        jal main
        
        addi $sp, $sp, 4  # raising sp after expression
                
# Global Variables
        .data
        