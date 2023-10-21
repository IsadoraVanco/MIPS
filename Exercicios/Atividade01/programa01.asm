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
    addi $s2, $zero, 7
    # $s7 = 1
    addi $s7, $zero, 1

    # $s3 = ponteiro do vetor
    la $s3, vetor

    # for(int i = 0; i < 8; i++){ 
    #    if(vetor[i] >= 0){
    #        somaPositivos += vetor[i];
    #    } else{
    #        somaNegativos += vetor[i];
    #    }
    # }

    for: 
        add $t0, $s2, $s2 # 2 * contador
        add $t0, $t0, $t0 # $t0 = 4 * contador

        add $t1, $zero, $s3 # $t1 = vetor
        add $t1, $t1, $t0 # $t1 += 4 * contador
        lw $t2, 0($t1) # $t2 = *vetor[contador]

        slti $t1, $t2, 0 #if (*vetor[contador] < 0){ $t1 = 1: $t1 = 0}
        beq $t1, $zero, adicionapositivos #if($t1 = 0){go to adicionapositivos}

        adicionanegativos:
            add $s1, $s1, $t2 # somanegativos += *vetor[contador]

        decremento:    	
            sub $s2, $s2, $s7 # contador--
            slti $t0, $s2, 0 # if(contador < 0){$t0 = 1: $t0 = 0}
            beq $t0, $zero, for #if($t0 == 0){go to for}
            j fim #jump to fim

        adicionapositivos:
            add $s0, $s0, $t2 #somapositivos += *vetor[contador]
            j decremento

fim:
    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, positivos
    syscall

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s0 #Printa a soma de positivos
    syscall

    # Configura o syscall para escrever strings
    li $v0, 4
    la $a0, negativos
    syscall

    # Configura o syscall para escrever inteiros
    li $v0, 1
    add $a0, $zero, $s1 #Printa a soma de negativos
    syscall