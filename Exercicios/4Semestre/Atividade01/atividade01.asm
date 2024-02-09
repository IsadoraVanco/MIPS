# Elaborar um programa, em código MIPS, que faça a leitura de 
# um vetor de n elementos (utilizar 12) inteiros e execute, 
# utilizando procedimentos, as seguintes operações:  

# a) Ordene o vetor em ordem crescente e apresentar o vetor ordenado;  
# b) Realize a soma dos elementos pares do vetor e apresentar o valor;  
# c) Leia uma chave k (número inteiro) e apresente na saída o número 
# de elementos do vetor que são maiores que a chave k e menores que 2*k; 
# d) Leia uma chave k (número inteiro) e apresente na saída o número 
# de elementos iguais a chave lida.  
# e) Apresenta na saída o resultado da soma dos números inteiros 
# perfeitos menos a soma dos números inteiros semiprimos.  

# OBS. pesquisar a definição de número perfeito e semiprimo.
# Analisar o(s) possível(eis) valor(es) para a chave k e caso 
# seja digitado um valor que não seja possível, uma mensagem deve 
# ser apresentada ao usuário.

# Aluna: Isadora Vanço

.data
ent: .asciiz "Insira o valor de Vet["
ent2: .asciiz "]"
.align 2
vet: .space 20

.text

main:
    la $a0, vet         # Endereço do vetor como parâmetro
    jal leitura         # Leitura do vetor
    move $a0, $v0       # Endereço do vetor retornado
    jal escrita         # Escrita do vetor
    li $v0, 10          # Código para finalizar o programa
    syscall             # Finaliza o programa

leitura:
    move $t0, $a0       # Salva o endereço base do vetor
    move $t1, $t0       # Endereço do vetor em i
    li $t2, 0           # i = 0
l:
    la $a0, ent         # Carrega o endereço da string
    li $v0, 4           # Código de impressão de inteiro
    syscall             # Imprime o indice i
    move $a0, $t2       # Carrega o indice do vetor
    li $v0, 1           # Código de impressão de inteiro
    syscall             # Imprime o indice i
    la $a0, ent2        # Carrega o endereço da string
    li $v0, 4           # Código de impressão de string
    syscall             # Impressão da string
    li $v0, 5           # Código de leitura de inteiro
    syscall             # Leitura do valor
    sw $v0, ($t1)       # Salva o valor lido em vet[i]
    add $t1, $t1, 4     # Endereço de vet[i + 1]
    addi $t2, $t2, 1    # i++
    blt $t2, 5, l       # if(i < 5) goto 1
    move $v0, $t0       # Endereço de vet para retorno
    jr $ra              # Retorna para a main

escrita:
    move $t0, $a0       # Salva o endereço base de vet
    move $t1, $t0       # Endereço de vet[i]
    li $t2, 0           # i = 0
e:
    lw $a0, ($t1)       # Carrega o valor de vet[i]
    li $v0, 1           # Código de impressão de inteiro
    syscall             # Imprime vet[i]
    li $a0, 32          # Código ASCII para espaço
    li $v0, 11          # Código de impressão de caractere
    syscall             # Imprime um espaço
    add $t1, $t1, 4     # Endereço de vet[i + 1]
    addi $t2, $t2, 1    # i++
    blt $t2, 5, e       # if(i < 5) goto e
    move $v0, $t0       # Endereço de vet para retorno
    jr $ra              # Retorna para a main