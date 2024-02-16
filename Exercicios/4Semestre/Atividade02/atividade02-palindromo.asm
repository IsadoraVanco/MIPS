# 2. Elaborar um programa, em código MIPS, que faça a leitura 
# de uma string ASCII e verifique se a mesma é um palíndromo 
# (retorne 1 se for palíndromo e 0 se não for palíndromo).  

# Aluna: Isadora Vanço
.data
ent1: .asciiz "Insira a string: "
resultado: .asciiz "=>Resultado: "
strEhPalindromo: .asciiz "É palindromo\n"
strNaoEhPalindromo: .asciiz "Não é palindromo\n"

.align 2
str: .space 200

.text 
.globl main 
main:
    la $a0, ent1                            # Parâmetro: mensagem
    la $a1, str                             # Parâmetro: endereço da string
    jal leitura                             # Leitura (mensagem, string)

    la $a0, resultado   
    li $v0, 4       
    syscall          

    # Retorna 1 se for palindromo, se não, retorna 0
    la $a0, str
    jal verificaPalindromo

    beq $v0, 0, naoPalindromo               # if($v0 == 0): goto naoPalindromo
    
    la $a0, strEhPalindromo                 # Move o retorno da string resultante
    li $v0, 4                               # Código de impressão de string
    syscall                                 # Imprime a string intercalada
    
    j fim

    naoPalindromo:
        la $a0, strNaoEhPalindromo          # Move o retorno da string resultante
        li $v0, 4                           # Código de impressão de string
        syscall                             # Imprime a string intercalada

    fim:
        li $v0, 10                          # Código para finalizar o programa 
        syscall                             # Finaliza o programa

leitura:
    li $v0, 4                               # Código para impressão de string
    syscall                                 # Imprime a string
    
    move $a0, $a1                           # Endereço da string para leitura
    li $a1, 100                             # Número máximo de caracteres
    
    li $v0, 8                               # Código de leitura da string
    syscall                                 # Faz a leitura da string

    jr $ra                                  # Retorna para a main

verificaPalindromo:
    # $s0 = '\0'
    li $s0, 0
    # $s1 = '\n'
    li $s1, 10
    # $s2 = &string
    move $s2, $a0

    # $t0 = i
    li $t0, 0
    # $t1 = f
    li $t1, 0
    # $t2 = &string[i] = Primeiros caracteres
    move $t2, $a0
    # $t4 = &string[f] = Ultimos caracteres
    move $t3, $a0

    # Se a string é apenas '\n' ou '\0' (Acho que não precisa, mas por garantia...)
    # $t4 = string[f]
    lb $t4, ($t3)
    beq $t4, $s0, verificaExtremos          # if(string[f] == '\0'): goto verificaExtremos
    beq $t4, $s1, verificaExtremos          # if(string[f] == '\n'): goto verificaExtremos

    # Procura pelo último caractere
    procuraUltimo:
        # $t4 = &string[f + 1]
        addi $t4, $t3, 1

        # $t5 = string[f + 1]
        lb $t5, ($t4)

        # Se string[f] já é o último caractere
        beq $t5, $s0, verificaExtremos      # if(string[f + 1] == '\0'): goto verificaExtremos
        beq $t5, $s1, verificaExtremos      # if(string[f + 1] == '\n'): goto verificaExtremos

        # f++
        addi $t1, $t1, 1
        addi $t3, $t3, 1    

        j procuraUltimo
    
    # Verifica os extremos
    verificaExtremos:
        # Chegou no meio da string sem erros
        bge $t0, $t1, retornaPalindromo     # if(i >= f): goto retornaPalindromo

        # $t4 = string[i]
        lb $t4, ($t2)
        # $t5 = string[f]
        lb $t5, ($t3)

        bne $t4, $t5, retornaNaoPalindromo  # if(string[i] != string[f]): goto retornaNaoPalindromo

        # i++
        addi $t0, $t0, 1    
        addi $t2, $t2, 1

        # f--
        subi $t1, $t1, 1    
        subi $t3, $t3, 1

        j verificaExtremos

    retornaNaoPalindromo:
        li $v0, 0                           # return 0
        jr $ra

    retornaPalindromo:
        li $v0, 1                           # return 1
        jr $ra