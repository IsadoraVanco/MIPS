# 2. Desenvolver um programa que faça a leitura de um vetor Vet, 
# de n elementos inteiros, e apresente como saída o maior  
# e o menor  elementos do vetor e suas  respectivas  posições 
# (primeira posição = 1). 

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]: "
strTamanho: .asciiz "=> Digite o tamanho do vetor: "
strTamanhoErro: .asciiz "=> O tamanho do vetor deve ser maior que zero!\n"
strA: .asciiz "=> Lendo o vetor:\n"
strMostraA: .asciiz "\n=> Vetor lido:\n"
strMaior: .asciiz "\nO maior elemento do vetor é: "
strMenor: .asciiz "\nO menor elemento do vetor é: "
strPosicao: .asciiz "\nEstá na posição: "

.text
.globl main
main:
    jal lerTamanho                  # Le o tamanho do vetor (retorna o valor em $v0)
    
    move $s0, $v0                   # Salva o tamanho do vetor ($s0)

    # Aloca espaço para o vetor 
    sll $a0, $s0, 2                 # $a0 = tamanho do vetor * 4 Bytes (inteiro)
    jal alocaEspaco                 # Aloca o espaço pedido (retorna o endereço em $v0)

    move $s1, $v0                   # Salva o endereço do vetor  ($s1)

    # Lendo o vetor 
    la $a0, strA                    # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # printf(strA)

    move $a0, $s1                   # Endereço base do vetor 
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal leitura                     # leitura(vetorA, nlin, ncol)

    # Mostra vetor lido
    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s1                   # Endereço base do vetor 
    li $a1, 1                       # Número de linhas (1)
    move $a2, $s0                   # Número de colunas do vetor
    jal escrita                     # escrita(vetorA, nlin, ncol)

    # Procura o maior e o menor
    move $a0, $s1                   # Endereço base do vetor 
    move $a1, $s0                   # Número de elementos do vetor
    jal procuraExtremos             # procuraExtremos(endereço, nElementos)

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

leitura:    # leitura(a0 = Endereço, a1 = nLinhas (1 para vetores), a2 = nColunas)
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

procuraExtremos:    # procuraExtremos(a0 = Endereço, a1 = nElementos)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de onde chamou a função 

    li $t0, 0                       # i = 0
    li $t1, 0                       # j = 0

    move $a2, $a1
    move $a3, $a0
    jal indice                      # indice(nElementos, endereço, i, j)

    lw $t4, ($v0)                   # maior = vetor[0] ($t4)
    lw $t5, ($v0)                   # menor = vetor[0] ($t5)

    li $t2, 0                       # Posição do maior ($t2)
    li $t3, 0                       # Posição do menor ($t3)

    addi $t1, $t1, 1                # j++

    loopExtremos:
        bge $t1, $a1, fimExtremos   # if(j >= nElementos): goto fimExtremos

        move $a2, $a1
        move $a3, $a0
        jal indice                  # indice(nElementos, endereço, i, j)

        lw $t6, ($v0)               # $t6 = vetor[j]

        bgt $t6, $t4, addMaior      # if(vetor[j] > maior): goto addMaior
        bge $t6, $t5, continuaExtremo   # if(vetor[j] >= menor): goto continuaExtremo
            move $t5, $t6           # menor = vetor[j]
            move $t3, $t1           # Posição do menor = j
            j continuaExtremo

        addMaior:
            move $t4, $t6           # maior = vetor[i]
            move $t2, $t1           # Posição do maior = j

        continuaExtremo:
        addi $t1, $t1, 1            # j++   

        j loopExtremos
    
    fimExtremos:
    la $a0, strMaior                # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $t4                   # Maior elemento
    li $v0, 1                       # Código para impressão de inteiro
    syscall                    

    la $a0, strPosicao              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    addi $a0, $t2, 1                # Posição do maior
    li $v0, 1                       # Código para impressão de inteiro
    syscall                         
    
    la $a0, strMenor                # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $t5                   # Menor elemento
    li $v0, 1                       # Código para impressão de inteiro
    syscall                        
    
    la $a0, strPosicao              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    addi $a0, $t3, 1                # Posição do menor
    li $v0, 1                       # Código para impressão de inteiro
    syscall                     

    lw $ra, ($sp)                   # Recupera o retorno para a main
    addi $sp, $sp, 4                # Libera o espaço na pilha
    
    jr $ra
