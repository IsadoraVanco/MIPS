# Atividade 03 - MIPS (2/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.
 
Exemplo de um programa que faz a leitura e escrita de uma matriz de inteiros de ordem 3x3.

```
.data
Mat: .space 36  # Matriz de inteiros 3x3 (4Bytes)
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "

.text
main: 
    la $a0, Mat     # Endereço base de Mat
    li $a1, 3       # Número de linhas
    li $a2, 3       # Número de colunas
    jal leitura     # leitura(Mat, nlin, ncol)

    move $a0, $v0   # Endereço da matriz lida
    jal escrita     # escrita(Mat, nlin, ncol)

    li $v0, 10      # Código para finalizar o programa
    syscall         # Finaliza o programa

indice:
    mul $v0, $t0, $a2       # i * ncol
    add $v0, $v0, $t1       # (i * ncol) + j
    sll $v0, $v0, 2         # [(i * ncol) + j] * 4 (Bytes)
    add $v0, $v0, $a3       # Soma o endereço base de Mat

    jr $ra                  # Retorna para o caller

leitura:
    subi $sp, $sp, 4        # Espaço para um item na pilha
    sw $ra, ($sp)           # Salva o endereço base de Mat
    move $a3, $a0           # aux = endereço base de Mat

    l:  
        la $a0, Ent1        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string

        move $a0, $t0       # Valor de i para impressão
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime i

        la $a0, Ent2        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string

        move $a0, $t1       # Valor de j para impressão
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime j

        la $a0, Ent3        # Carrega o endereço da string
        li $v0, 4           # Código de impressão de string
        syscall             # Imprime a string  

        li $v0, 5           # Código de leitura de inteiro
        syscall             # Leitura do valor (retorna em $v0)

        move $t2, $v0       # aux = valor lido
        jal indice          # Calcula o endereço de Mat[i][j]

        sw $t2, ($v0)       # Mat[i][j] = aux
        addi $t1, $t1, 1    # j++
        
        blt $t1, $a2, l     # if(j < ncol): goto l
        
        li $t1, 0           # j = 0
        addi $t0, $t0, 1    # i++

        blt $t0, $a1, l     # if(i < nlin): goto l

        li $t0, 0           # i = 0
        lw $ra, ($sp)       # Recupera o retorno para a main
        addi $sp, $sp, 4    # Libera o espaço na pilha
        move $v0, $a3       # Endereço base da matriz para retorno

        jr $ra              # Retorna para a main

escrita:
    subi $sp, $sp, 4        # Espaço para um item na pilha
    sw $ra, ($sp)           # Salva o endereço base de Mat
    move $a3, $a0           # aux = endereço base de Mat

    e:
        jal indice          # Calcula o endereço de Mat[i][j]

        lw $a0, ($v0)       # Valor em Mat[i][j]
        li $v0, 1           # Código para impressão de inteiro
        syscall             # Imprime Mat[i][j]

        la $a0, 32          # Código ASCII para espaço
        li $v0, 11          # Código de impressão de caractere
        syscall             # Imprime o espaço

        addi $t1, $t1, 1    # j++

        blt $t1, $a2, e     # if(j < ncol): goto e

        la $a0, 10          # Código ASCII para newline ('\n')
        syscall             # Pula a linha

        li $t1, 0           # j = 0
        addi $t0, $t0, 1    # i++

        blt $t0, $a1, e     # if(i < nlin): goto e

        li $t0, 0           # i = 0

        lw $ra, ($sp)       # Recupera o retorno para a main
        addi $sp, $sp, 4    # Libera o espaço na pilha
        move $v0, $a3       # Endereço base da matriz para retorno

        jr $ra              # Retorna para a main
```

## Exercícios

1. Elaborar um programa, em código MIPS, que faça a leitura de uma matriz A de inteiros, de ordem 4x3, e a leitura de um vetor de inteiros V com 3 elementos. Determinar o produto de A por V. 
 
2. Dizemos que uma matriz inteira Anxn  é uma matriz de permutação se em cada linha e em cada coluna houver n-1 elementos nulos e um único elemento igual a 1. (utilizar n = 3)
 
**Exemplo**:  A matriz abaixo é de permutação

```
0 1 0 0
0 0 1 0
1 0 0 0
0 0 0 1
```

Dada uma matriz inteira Anxn, elaborar um programa, em código MIPS, para verificar se a matriz A é de permutação

3. Dada uma matriz de inteiros Amxn, imprimir o número de linhas e o número de colunas nulas da matriz. (utilizar n = m = 4)

**Exemplo**: m = 4 e n = 4 

```
1 0 2 3
4 0 5 6
0 0 0 0 
0 0 0 0
```
 
tem 2 linhas nulas e 1 coluna nula. 