# Slide 41
# Implementar em código MIPS: 
# Somatório (k = 1 a 20)(4k + 2)

.data
fraseFinal: .asciiz "\nA soma final é de "

.text
.globl main
main:
    # $s0 = soma
    add $s0, $zero, $zero

    # $s1 = k 
    addi $s1, $zero, 1

    # $s2 = 21
    addi $s2, $s2, 21

    loop:
        sll $t0, $s1, 2 # $t0 = 4 * k 
        addi $t0, $t0, 2 # $t0 += 2
        add $s0, $s0, $t0 # soma += $t0

        addi $s1, $s1, 1 # k++
        
        beq $s1, $s2, exit # if(k == 21): exit
        j loop # Vai para loop

exit:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, fraseFinal
    syscall # Print(fraseFinal)

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s0
    syscall # Print(soma)