# 1. Em álgebra linear, a diagonal secundária de uma matriz A 
# é a coleção das entradas Aij em que i + j é igual a n + 1 
# (onde n é a ordem da matriz).  Elaborar um programa, em  
# código  MIPS,  que  receba  como  entrada  uma  matriz  de  
# inteiros  de  ordem    3x3  e apresente como saída todos os 
# valores da matriz e a soma dos elementos da diagonal secundária.

# Aluna: Isadora Vanço
.data
Ent1: .asciiz "["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
strMatA: .asciiz "=> Lendo a Matriz:\n"
strMostraA: .asciiz "\n=> Matriz lida:\n"
strSoma: .asciiz "\nSoma dos elementos da diagonal secundária: "


.align 2
MatA: .space 36                     # Matriz de inteiros 3x3 (4Bytes)

.text
.globl main
main: 
    la $a0, strMatA                 # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço base de MatA
    li $a1, 3                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal leitura                     # leitura(MatA, nlin, ncol)

    la $a0, strMostraA              # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    la $a0, MatA                    # Endereço da matriz lida
    li $a1, 3                       # Número de linhas
    li $a2, 3                       # Número de colunas
    jal escrita                     # escrita(MatA, nlin, ncol)

    li $a0, 3                       # Ordem da matriz
    jal soma                        # Soma a diagonal secundária

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

soma: # soma(a0 = ordem)
    subi $sp, $sp, 4                # Espaço para um item na pilha
    sw $ra, ($sp)                   # Salva o endereço de onde foi chamada a função

    addi $s0, $zero, 0              # total = 0
    move $s1, $a0                  # ordem

    addi $t2, $zero, 0              # i em nLinhas
    subi $t3, $s1, 1                # j em nColunas

    linhas:
        move $t0, $t2               # $t0 = i
        move $t1, $t3               # $t1 = j
        la $a3, MatA                # $a3 = &MatA
        jal indice                  # Calcula o endereço de Mat[i][j]

        lw $t4, ($v0)               # $t4 = Mat[i][j]
        add $s0, $s0, $t4           # soma += Mat[i][j]

        subi $t3, $t3, 1            #   j--
        addi $t2, $t2, 1            # i++
        blt $t2, $s1, linhas        # if(i < ordem): goto linhas


    # Imprime o resultado
    la $a0, strSoma               # Carrega o endereço da string
    li $v0, 4                       # Código de impressão de string
    syscall                         # Imprime a string

    move $a0, $s0                    # Carrega a soma
    li $v0, 1                       # Código de impressão de inteiros
    syscall                         # Imprime a string

    lw $ra, ($sp)               # Recupera o retorno para a main
    addi $sp, $sp, 4            # Libera o espaço na pilha
    move $v0, $a3               # Endereço base da matriz para retorno

    jr $ra                      # Retorna para a main