# Atividade 02 - MIPS (2/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.

1. O código abaixo realiza a leitura de 2 strings (string1 e string2) de tamanho máximo de 100 caracteres. Complete o código desenvolvendo a função intercala (intercala o conteúdo da string 1 com o conteúdo da string 2 e armazena o resultado em string3).

```
.data
ent1: .asciiz "Insira a string 1: "
ent2: .asciiz "Insira a string 2: "
str1: .space 100
str2: .space 100
str3: .space 200

.text
main:
    la $a0, ent1    # Parâmetro: mensagem
    la $a1, str1    # Parâmetro: endereço da string
    jal leitura     # Leitura (mensagem, string)

    la $a0, ent2    # Parâmetro: mensagem
    la $a1, str2    # Parâmetro: endereço da string
    jal leitura     # Leitura (mensagem, string)

    la $a0, str1    # Parâmetro: endereço da string 1
    la $a1, str2    # Parâmetro: endereço da string 2
    la $a2, str3    # Parâmetro: endereço da string 3
    jal intercala   # Intercala (str1, str2, str3)

    move $a0, $v0   # Move o retorno da string resultante
    li $v0, 4       # Código de impressão de string
    syscall         # Imprime a string intercalada

    li $v0, 10      # Código para finalizar o programa 
    syscall         # Finaliza o programa

leitura:
    li $v0, 4       # Código para impressão de string
    syscall         # Imprime a string
    
    move $a0, $a1   # Endereço da string para leitura
    li $a1, 100     # Número máximo de caracteres
    
    li $v0, 8       # Código de leitura da string
    syscall         # Faz a leitura da string

    jr $ra          # Retorna para a main

intercala:
```

2. Elaborar um programa, em código MIPS, que faça a leitura de uma string ASCII e verifique se a mesma é um palíndromo (retorne 1 se for palíndromo e 0 se não for palíndromo).  