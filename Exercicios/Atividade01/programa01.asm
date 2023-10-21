# 1. Elaborar um programa, em código MIPS, que realize a soma dos valores
# positivos e a soma dos valores negativos contidos em um vetor, na forma:

# .data
# vetor: .word -2, 4, 7, -3, 0, -3, 5, 6
# .......

# Layout de saída:
# A soma dos valores positivos =
# A soma dos valores negativos =

# Obs. Enviar o fonte (comentado) - programa01.asm
# Aluna: Isadora Vanço

.data 
vetor: .word -2, 4, 7, -3, 0, -3, 5, 6
positivos: .asciiz "\nA soma dos valores positivos = "
negativos: .asciiz "\nA soma dos valores negativos = "

.text
.globl main
main:
    # $s0 = soma dos positivos
    add $s0, $zero, $zero
    # $s1 = soma dos negativos
    add $s1, $zero, $zero
    # $s2 = contador
    addi $s2, $zero, 0
    # $s3 = ponteiro do vetor
    la $s3, vetor
    # $s4 = fim do loop = número de elementos do vetor
    addi $s4, $zero, 8

    loop: 
        sll $t0, $s2, 2 # $t0 = 4 * contador
        add $t0, $t0, $s3 # $t0 += &vetor
        lw $t1, 0($t0) # $t1 = vetor[contador]

        slti $t2, $t1, 0 # if(vetor[contador] < 0){$t2 = 1: $t2 = 0}
        beq $t2, $zero, adicionaPositivos #if($t2 = 0): adicionaPositivos

        adicionaNegativos:
            add $s1, $s1, $t1 # somanegativos += vetor[contador]
            j incremento # Vai para o incremento

        adicionaPositivos:
            add $s0, $s0, $t1 #somapositivos += vetor[contador]

        incremento:    	
            addi $s2, $s2, 1 # contador++
            beq $s2, $s4, exit #if(contador == fim do loop): exit
            j loop # Vai para loop

exit:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, positivos # Configura o argumento para a chamada
    syscall # Print(positivos)

    li $v0, 1 # Configura o syscall para escrever inteiros
    add $a0, $zero, $s0 # Configura o argumento para a chamada
    syscall # Print($s0)

    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, negativos # Configura o argumento para a chamada
    syscall # Print(negativos)

    li $v0, 1 # Configura o syscall para escrever inteiros
    add $a0, $zero, $s1 # Configura o argumento para a chamada
    syscall # Print($s1)