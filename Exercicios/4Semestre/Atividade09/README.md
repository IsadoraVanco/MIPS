# Atividade 09 - MIPS

1. Elaborar um programa, em código em MIPS, que faça a leitura de um arquivo de inteiros (crie o arquivo dados1.txt com n elementos inteiros separados por um espaço em branco entre 
os números) e determine (implementando com funções): 
* o maior valor; 
* o menor valor; 
* o número de elementos ímpares;
* o número de elementos pares; 
* a soma dos valores; 
* os  valores  em  ordem  crescente;    
* os  valores  em  ordem  decrescente; 
* o  produto  dos elementos e 
* o número de caracteres do arquivo. 

2. Elaborar um programa, em código MIPS, que realize todas as operações do exercício 1, com o arquivo dados2.txt composto por n elementos inteiros, sendo um valor inteiro por linha no arquivo.

Exemplo de código para abertura de um arquivo
```
.data
Arquivo: .asciiz "dados.txt"
Erro: .asciiz "Arquivo não encontrado! \n"

.text
main:
    li $v0, 13  # Abertura de arquivo
    la $a0, Arquivo
    syscall

    bgez $v0, fim

    la $ao, Erro
    li $v0, 4   # Impressão de string
    syscall

    fim:
    li $v0, 10
    syscall
```

Exemplo de código para contagem de caracteres de um arquivo
```
.data
buffer: .asciiz " "
Arquivo: .asciiz "dados.txt"
Erro: .asciiz "Arquivo não encontrado! \n"

.text
main:
    la $a0, Arquivo
    li $a1, 0   # Somente leitura
    jal abertura

    move $s0, $v0
    
    move $a0, $s0
    la $a1, buffer
    li $a2, 1   # Caractere por leitura
    jal contagem

    move $a0, $v0
    li $a1, 1   # Impressão de inteiro
    syscall

    li $v0, 16  # Fechar arquivo
    
    li $v0, 10
    syscall

abertura:
    li $v0, 13  # Abertura de arquivo
    syscall

    bgez $v0, a

    la $a0, Erro
    li $v0, 4   # Impressão de string
    syscall

    li $v0, 10  # Finalizar programa
    syscall

    jr $ra

contagem:
    li $v0, 14  # Leitura de arquivo
    syscall

    addi $t0, $t0, 1    
    
    bnez $v0, contagem

    subi $t0, $t0, 1
    move $v0, $t0

    jr $ra
```

Exemplo de código para leitura e soma de valores em um arquivo
```
.data
buffer: .asciiz " "
Arquivo: .asciiz "dados2.txt"
Erro: .asciiz "Arquivo não encontrado!\n"

.text
main:
    la $a0, Arquivo
    li $a1, 0   # Somente leitura
    jal abertura

    move $s0, $v0

    move $a0, $s0
    la $a1, buffer
    li $a2, 1
    jal leitura

    move $a0, $v0
    li $v0, 1   # Impressão de inteiro
    syscall

    li $v0, 16  # Fechar arquivo
    move $a0, $s0
    syscall

    li $v0, 10
    syscall

leitura:
    li $v0, 14  # Leitura de arquivo
    syscall

    beqz $v0, f

    lb $t0, ($a1)

    beq $t0, 13, leitura
    beq $t0, 10, l

    subi $t0, $t0, 48   # Converte decimal para caractere
    mul $t1, $t1, 10
    add $t1, $t1, $t0

    j leitura

    l: 
    add $t2, $t2, $t1
    li $t1, 0
    j leitura

    f:
    add $v0, $t2, $t1
    
    jr $ra

abertura:
    li $v0, 13  # Abertura de arquivo
    syscall

    bgez $v0, a

    la $a0, Erro
    li $v0, 4   # Impressão de string
    syscall

    li $v0, 10  # Finalizar programa
    syscall

    jr $ra
``` 
