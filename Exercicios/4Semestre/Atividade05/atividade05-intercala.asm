# 3. Faça  um  programa  que  leia  dois  vetores  (VetC  e  VetD),  
# de  n  elementos  inteiros,  e apresente como saída outro vetor (VetE) 
# contendo nas posições pares os valores do primeiro e nas posições impares 
# os valores do segundo. 

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
strVetorIntercalado: .asciiz "\n=> Vetor intercalado:\n"

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

    # Aloca espaço para o vetor C
    sll $a0, $s0, 3                 # $a0 = tamanho do vetor * 4 Bytes
    jal alocaEspaco                 # Aloca o espaço pedido (retorna o endereço em $v0)

    move $s3, $v0                   # Salva o endereço do vetor C ($s3)

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

    # Intercala os vetores
    move $a0, $s1                   # Endereço de A
    move $a1, $s2                   # Endereço de B
    move $a2, $s0                   # Endereço de A
    move $a3, $s3                   # Endereço de C
    jal intercala

    # Mostra o vetor resultante
    la $a0, strVetorIntercalado     # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s3                   # Endereço base do vetor C
    li $a1, 1                       # Número de linhas (1)
    sll $a2, $s0, 1                 # Número de colunas do vetor
    jal escrita                     # escrita(vetorB, nlin, ncol)

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

intercala:  # intercala(a0 = endereçoA, a1 = endereçoB, a2 = tamanho, a3 = endereçoC)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat

    li $t1, 0                       # j = 0

    move $t2, $a3                   # Salva o endereço de C

    loopIntercala:
        lw $t4, ($a0)               # $t5 = vetorA[j]
        sw $t4, ($a3)               # vetorC[indice] = vetorA[j]
        addi $a0, $a0, 4            # VetorA++

        addi $a3, $a3, 4            # VetorC++

        lw $t4, ($a1)               # $t5 = vetorB[j]
        sw $t4, ($a3)               # vetorC[indice] = vetorB[j]
        addi $a1, $a1, 4            # VetorB++

        addi $a3, $a3, 4            # VetorC++

        addi $t1, $t1, 1            # j++

        blt $t1, $a2, loopIntercala # if(j < nElementos): goto loopIntercala 

    lw $ra, ($sp)                   # Recupera o retorno para a main
    addi $sp, $sp, 4                # Libera o espaço na pilha

    jr $ra                          # Retorna para a main