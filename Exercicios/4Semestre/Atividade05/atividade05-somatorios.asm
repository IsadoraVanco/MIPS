# 1. Elaborar um programa que faça a leitura de dois vetores 
# (VetA e VetB) compostos, cada um,  de  n  elementos  inteiros  
# e  apresente  como  saída  a  somatória  dos  elementos  
# das posições  pares  de  VetA  subtraída  da  somatória  
# dos  elementos  das  posições  ímpares  de VetB

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]: "
strTamanho: .asciiz "=> Digite o tamanho dos vetores: "
strTamanhoErro: .asciiz "=> O tamanho do vetor deve ser maior que zero!\n"
strA: .asciiz "=> Lendo o vetor A:\n"
strB: .asciiz "=> Lendo o vetor B:\n"
strMostraA: .asciiz "\n=> Vetor A lido:\n"
strMostraB: .asciiz "\n=> Vetor B lido:\n"
strSomaPares: .asciiz "\nSoma dos pares de A: "
strSomaImpares: .asciiz "\nSoma dos ímpares de B: "
strDiferenca: .asciiz "\nSoma dos pares de A - soma dos impares de B: "

.text
.globl main
main:
    jal lerTamanho                  # Le o tamanho do vetor (retorna o valor em $v0)
    
    move $s0, $v0                   # Salva o tamanho do vetor ($s0)

    # Aloca espaço para o vetor A
    sll $a0, $s0, 2                 # $a0 = tamanho do vetor * 4 Bytes (inteiro)
    jal alocaEspaco                 # Aloca o espaço pedido (retorna o endereço em $v0)

    move $s1, $v0                   # Salva o endereço do vetor A ($s1)

    # Aloca espaço para o vetor B
    sll $a0, $s0, 2                 # $a0 = tamanho do vetor * 4 Bytes
    jal alocaEspaco                 # Aloca o espaço pedido (retorna o endereço em $v0)

    move $s2, $v0                   # Salva o endereço do vetor B ($s2)

    # Lendo o vetor A
    la $a0, strA                    # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # printf(strA)

    move $a0, $s1                   # Endereço base do vetor A
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal leitura                     # leitura(vetorA, nlin, ncol)

    # Lendo o vetor B
    la $a0, strB                    # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # printf(strB)

    move $a0, $s2                   # Endereço base do vetor B
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal leitura                     # leitura(vetorB, nlin, ncol)

    # Mostra vetor A lido
    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s1                   # Endereço base do vetor A
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal escrita                     # escrita(vetorA, nlin, ncol)

    # Mostra vetor lido B
    la $a0, strMostraB              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s2                   # Endereço base do vetor B
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal escrita                     # escrita(vetorB, nlin, ncol)

    # Soma as posições pares
    move $a0, $s1                   # Endereço do vetor A
    move $a1, $s0                   # Número de posições do vetor
    jal somaPosicaoPares            # somaPosicaoPares(endereco, nElementos)

    move $s3, $v0                   # Salva o valor da soma dos pares de A ($s3)

    # Mostra a soma dos pares de A
    la $a0, strSomaPares            # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s3                   # Carrega a soma dos pares
    li $v0, 1                       # Código para impressão de inteiro
    syscall                         # printf(somaPares)

    # Soma as posições impares de B
    add $a0, $s2, 4                 # Endereço do vetor B
    subi $a1, $s0, 1                # Número de posições do vetor
    jal somaPosicaoPares            # somaPosicaoPares(endereco, nElementos)

    move $s4, $v0                   # Salva o valor da soma dos impares de B ($s4)
    
    # Mostra a soma dos impares de B
    la $a0, strSomaImpares          # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s4                   # Carrega a soma dos pares
    li $v0, 1                       # Código para impressão de inteiro
    syscall                         # printf(somaImpares)
    
    # Mostra a diferença entre os pares e impares
    move $a0, $s3                   # Soma dos pares
    move $a1, $s4                   # Soma dos impares
    la $a2, strDiferenca            # Endereço da string 
    jal mostraDiferenca             # mostraDiferenca(pares, impares, strDiferenca)

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

indice:     # indice(a2 = nCol, a3 = Endereço da matriz, t0 = i, t1 = j (0 para vetores))
    mul $v0, $t0, $a2               # i * ncol
    add $v0, $v0, $t1               # (i * ncol) + j
    sll $v0, $v0, 2                 # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3               # Soma o endereço base de Mat

    jr $ra                          # Retorna para o caller

lerTamanho:

    loopLer:
        la $a0, strTamanho          # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        li $v0, 5                   # Código de leitura de inteiro
        syscall                     # Leitura do valor (retorna em $v0)

        bgt $v0, 0, fimTamanho      # if(valor > 0): goto fimTamanho

        la $a0, strTamanhoErro      # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        j loopLer                   # goto loopLer
    
    fimTamanho:
    jr $ra

leitura:    # leitura(a0 = Endereço, a1 = nLinhas, a2 = nColunas (0 para vetores))
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    l:  
        la $a0, Ent1                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t1               # Valor de j para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime j

        la $a0, Ent2                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        li $v0, 5                   # Código de leitura de inteiro
        syscall                     # Leitura do valor (retorna em $v0)

        move $t2, $v0               # aux = valor lido
        jal indice                  # Calcula o endereço de Mat[i][j]

        sw $t2, ($v0)               # Mat[i][j] = aux
        addi $t1, $t1, 1            # j++
        
        blt $t1, $a2, l             # if(j < ncol): goto l
        
        li $t1, 0                   # j = 0
        addi $t0, $t0, 1            # i++

        blt $t0, $a1, l             # if(i < nlin): goto l

        li $t0, 0                   # i = 0
        lw $ra, ($sp)               # Recupera o retorno para a main
        addi $sp, $sp, 4            # Libera o espaço na pilha
        move $v0, $a3               # Endereço base da matriz para retorno

        jr $ra                      # Retorna para a main

escrita:    # escrita(a0 = Endereço, a1 = nLinhas, a2 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    addi $t0, $zero, 0              # i = 0
    addi $t1, $zero, 0              # j = 0
    e:
        jal indice                  # Calcula o endereço de Mat[i][j]

        lw $a0, ($v0)               # Valor em Mat[i][j]
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime Mat[i][j]

        la $a0, 32                  # Código ASCII para espaço
        li $v0, 11                  # Código de impressão de caractere
        syscall                     # Imprime o espaço

        addi $t1, $t1, 1            # j++

        blt $t1, $a2, e             # if(j < ncol): goto e

        la $a0, 10                  # Código ASCII para newline ('\n')
        syscall                     # Pula a linha

        li $t1, 0                   # j = 0
        addi $t0, $t0, 1            # i++

        blt $t0, $a1, e             # if(i < nlin): goto e  

        lw $ra, ($sp)               # Recupera o retorno para a main
        addi $sp, $sp, 4            # Libera o espaço na pilha
        move $v0, $a3               # Endereço base da matriz para retorno

        jr $ra                      # Retorna para a main

alocaEspaco: # alocaEspaco(a0 = tamanho em Bytes)
    # O tamanho já está em a0
    li $v0, 9                       # Código para alocar espaço em heap
    syscall

    jr $ra

somaPosicaoPares:  # somaPares(a0 = Endereco, a1 = nElementos)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat

    move $t2, $a0                   # Salva o endereço do vetor
    move $t3, $a1                   # Salva o tamanho do vetor
    li $t4, 0                       # $t4 = soma = 0

    li $t0, 0                       # i = 0
    li $t1, 0                       # j = 0
    
    loopSomaPar:
        move $a2, $a1               # nCol = nElementos
        move $a3, $t2               # Endereço do vetor
        jal indice                  # leitura(nElementos, endereco, i, j)

        lw $t5, ($v0)               # $t5 = valor lido em indice
        add $t4, $t4, $t5           # soma += valor

        addi $t0, $t0, 2            # i += 2

        blt $t0, $t3, loopSomaPar   # if(i < nElementos): goto loopSomaPar       

    lw $ra, ($sp)                   # Recupera o retorno para a main
    addi $sp, $sp, 4                # Libera o espaço na pilha
    
    move $v0, $t4                   # Valor da soma como retorno

    jr $ra

mostraDiferenca:    # mostraDiferenca(a0 = soma1, a1 = soma2, a2 = texto)
    sub $t0, $a0, $a1               # soma1 - soma2

    move $a0, $a2                   # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $t0                   # Carrega a subtaração
    li $v0, 1                       # Código para impressão de inteiro
    syscall                         # printf(subtração)

    jr $ra