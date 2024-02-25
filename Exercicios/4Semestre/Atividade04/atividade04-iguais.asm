# 2. Elaborar um programa, em código MIPS, que realize a leitura 
# de duas matrizes de números inteiro de ordem 4x4  e apresente 
# como resposta:  
# * quantos valores iguais estão na mesma posição em ambas as matrizes;  
# * soma das posições (linha+coluna) de todos os elementos iguais 
# que estão na mesma posição em ambas as matrizes.

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
strMatA: .asciiz "=> Lendo Matriz A:\n"
strMatB: .asciiz "=> Lendo Matriz B:\n"
strMostraA: .asciiz "\n=> Matriz A lida:\n"
strMostraB: .asciiz "\n=> Matriz B lida:\n"
strCompara: .asciiz "\n=> Compara as matrizes:\n"
strIguais: .asciiz "\nElementos iguais em posições iguais: "
strSoma: .asciiz "\nSoma das linhas e colunas iguais: "


.align 2
MatA: .space 64                     # Matriz de inteiros 4x4 (4Bytes)
MatB: .space 64                     # Matriz de inteiros 4x4 (4Bytes)

.text
.globl main
main: 
    la $a0, strMatA                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço base de MatA
    li $a1, 4                       # Número de linhas
    li $a2, 4                       # Número de colunas
    jal leitura                     # leitura(MatA, nlin, ncol)

    la $a0, strMatB                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatB                    # Endereço base de MatB
    li $a1, 4                       # Número de linhas
    li $a2, 4                       # Número de colunas
    jal leitura                     # leVetor(MatB, nlin, ncol)

    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço da matriz lida
    li $a1, 4                       # Número de linhas
    li $a2, 4                       # Número de colunas
    jal escrita                     # escrita(MatA, nlin, ncol)

    la $a0, strMostraB              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatB                    # Endereço da matriz lida
    li $a1, 4                       # Número de linhas
    li $a2, 4                       # Número de colunas do vetor 
    jal escrita                     # escrita(MatB, nlin, ncol)

    la $a0, strCompara              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    li $a0, 4                       # Número de linhas das matrizes
    li $a1, 4                       # Número de colunas das matrizes 
    jal compara                     # Multiplica a matriz pelo vetor

    li $v0, 10                      # Código para finalizar o programa
    syscall                         # Finaliza o programa

indice:     # indice(a2 = nCol, a3 = Endereço da matriz, t0 = i, t1 = j)
    mul $v0, $t0, $a2               # i * ncol
    add $v0, $v0, $t1               # (i * ncol) + j
    sll $v0, $v0, 2                 # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3               # Soma o endereço base de Mat

    jr $ra                          # Retorna para o caller

leitura:    # leitura(a0 = Endereço, a1 = nLinhas, a2 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço base de Mat
    move $a3, $a0                   # aux = endereço base de Mat

    l:  
        la $a0, Ent1                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t0               # Valor de i para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime i

        la $a0, Ent2                # Carrega o endereço da string
        li $v0, 4                   # Código de impressão de string
        syscall                     # Imprime a string

        move $a0, $t1               # Valor de j para impressão
        li $v0, 1                   # Código para impressão de inteiro
        syscall                     # Imprime j

        la $a0, Ent3                # Carrega o endereço da string
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

        li $t0, 0           # i = 0
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

compara: # compara(a0 = nLinhas, a1 = nColunas)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de onde foi chamada a função

    addi $s0, $zero, 0              # iguais = 0
    addi $s1, $zero, 0              # total = 0

    add $a2, $zero, $a1             # $a2 = nColunas
    addi $t2, $zero, 0              # i em nLinhas

    linhas:
        addi $t3, $zero, 0              # j em nColunas

        colunas:
            move $t0, $t2               # $t0 = i
            move $t1, $t3               # $t1 = j
            la $a3, MatA                # $a3 = &MatA
            jal indice                  # Calcula o endereço de Mat[i][j]

            lw $t4, ($v0)               # $t4 = Mat[i][j]

            move $t0, $t2               # $t0 = i
            move $t1, $t3               # $t1 = j
            la $a3, MatB                # $a3 = &MatB
            jal indice                  # Calcula o endereço de Mat[i][j]

            lw $t5, ($v0)               # $t5 = Mat[i][j]

            bne $t4, $t5, incrementa    # if(MatA[i][j] != MatB[i][j]): goto incrementa

            addi $s0, $s0, 1            # iguais++
            add $s1, $s1, $t2           # total += i
            add $s1, $s1, $t3           # total += j

            incrementa:

            addi $t3, $t3, 1            # j++
            blt $t3, $a2, colunas       # if(j < nColunas): goto colunas

        addi $t2, $t2, 1            # i++
        blt $t2, $a0, linhas       # if(i < nLinhas): goto linhas

    # Imprime o resultado
    la $a0, strIguais               # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s0                    # Carrega o número de iguais
    li $v0, 1                       # Código de impressão de inteiros
    syscall                         # Imprime a string

    la $a0, strSoma               # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s1                    # Carrega o número de iguais
    li $v0, 1                       # Código de impressão de inteiros
    syscall                         # Imprime a string

    lw $ra, ($sp)               # Recupera o retorno para a main
    addi $sp, $sp, 4            # Libera o espaço na pilha
    move $v0, $a3               # Endereço base da matriz para retorno

    jr $ra                      # Retorna para a main