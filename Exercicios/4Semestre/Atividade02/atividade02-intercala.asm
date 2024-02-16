# 1. O código abaixo realiza a leitura de 2 strings (string1 e string2) 
# de tamanho máximo de 100 caracteres. Complete o código desenvolvendo 
# a função intercala (intercala o conteúdo da string 1 com o conteúdo 
# da string 2 e armazena o resultado em string3) 

# Aluna: Isadora Vanço
.data
ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "Insira a string 2: "
resultado: .asciiz "=>Resultado: "

.align 2
str1: .space 100
str2: .space 100
str3: .space 200

.text
.globl main 
main:
    la $a0, ent1        # Parâmetro: mensagem
    la $a1, str1        # Parâmetro: endereço da string
    jal leitura         # Leitura (mensagem, string)

    la $a0, ent2        # Parâmetro: mensagem
    la $a1, str2        # Parâmetro: endereço da string
    jal leitura         # Leitura (mensagem, string)

    la $a0, str1        # Parâmetro: endereço da string 1
    la $a1, str2        # Parâmetro: endereço da string 2
    la $a2, str3        # Parâmetro: endereço da string 3
    jal intercala       # Intercala (str1, str2, str3)

    la $a0, resultado # Move o retorno da string resultante
    li $v0, 4           # Código de impressão de string
    syscall             # Imprime a string de resultado

    la $a0, str3      # Move o retorno da string resultante
    li $v0, 4           # Código de impressão de string
    syscall             # Imprime a string intercalada

    li $v0, 10          # Código para finalizar o programa 
    syscall             # Finaliza o programa

leitura:
    li $v0, 4       # Código para impressão de string
    syscall         # Imprime a string
    
    move $a0, $a1   # Endereço da string para leitura
    li $a1, 100     # Número máximo de caracteres
    
    li $v0, 8       # Código de leitura da string
    syscall         # Faz a leitura da string

    jr $ra          # Retorna para a main

intercala:
    # $s0 = '\0'
    li $s0, 0
    # $s1 = '\n'
    li $s1, 10
    # $s2 = &string3[i]
    move $s2, $a2
    # $s3 = &string3
    move $s3, $a2

    # $t0 = i
    li $t0, 0
    # $t1 = str1
    li $t1, 0
    # $t2 = str2
    li $t2, 0
    # $t3 = &string1[str1]
    move $t3, $a0
    # $t4 = string2[str2]
    move $t4, $a1

    lIntercala:
        # $t5 = string1[str1]
        lb $t5, ($t3)              

        beq $t5, $s0, fimStr1         # if(string1[str1] == '\0'): goto fimStr1
        beq $t5, $s1, fimStr1        # if(string1[str1] == '\n'): goto fimStr1

        sb $t5, ($s2)               # string3[i] = string1[str1]
        addi $t3, $t3, 1            # &string1[str1 + 1]
        addi $s2, $s2, 1            # &string3[i + 1]
        addi $t0, $t0, 1            # i++

        j verificaStr2

        fimStr1:
            addi $t1, $zero, -1     # str1 = -1

        verificaStr2:
            # $t5 = string2[str2]
            lb $t5, ($t4)

            beq $t5, $s0, fimStr2         # if(string2[str2] == '\0'): goto fimStr2
            beq $t5, $s1, fimStr2        # if(string2[str2] == '\n'): goto fimStr2

            sb $t5, ($s2)               # string3[i] = string2[str2]
            addi $t4, $t4, 1            # &string2[str1 + 1]
            addi $s2, $s2, 1            # &string3[i + 1]
            addi $t0, $t0, 1            # i++

            j verificaFim

            fimStr2:
                addi $t2, $zero, -1     # str2 = -1

        verificaFim:
            blt $t0, 200, verificaFim2
            j finaliza

        verificaFim2:
            beq $t1, -1, verificaFim3   # if(str1 == -1): goto verificaFim3
            j lIntercala
        
        verificaFim3:
            beq $t2, -1, finaliza       # if(str2 == -1): goto finaliza
            j lIntercala

        finaliza:
            sb $s0, ($s2)               # string3[i] = '\0'
            sub $s2, $s2, $t0
            move $v0, $s3               # $v0 = &string3

            jr $ra
