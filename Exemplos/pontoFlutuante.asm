.data
valorA: .float 8.32     # Valor de ponto flutuante simples
valorB: .float -0.43543534
strValorA: .asciiz "\n=> Valor de A: "
strValorB: .asciiz "\n=> Valor de B: "

.text
.globl main

# Faz a troca de dois números flutuantes
main:

# Valores antes da troca
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorA        # $f12 = *valorA
li $v0, 2               # Código para imprimir float simples
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorB        # $f12 = *valorB
li $v0, 2               # Código para imprimir float simples
syscall

l.s $f0, valorA     # Load Single (ponto flutuante simples)
l.s $f1, valorB

s.s $f1, valorA     # Store Single (ponto flutuante simples)
s.s $f0, valorB

# Valores depois da troca
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorA        # $f12 = *valorA
li $v0, 2               # Código para imprimir float simples
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorB        # $f12 = *valorB
li $v0, 2               # Código para imprimir float simples
syscall

li $v0, 10
syscall