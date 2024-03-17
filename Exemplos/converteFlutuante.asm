.data
valorInteiro: .word 8    
valorFloat: .float 0.0
strValorA: .asciiz "\n=> Valor de A (inteiro): "
strValorB: .asciiz "\n=> Valor de B (float): "

.text
.globl main
main:

# Valores antes da conversão
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

lw $a0, valorInteiro          # $a0 = *valorInteiro
li $v0, 1               # Código para imprimir inteiro
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorFloat        # $f12 = *valorFloat
li $v0, 2               # Código para imprimir float simples
syscall

# Faz a conversão
lw $t0, valorInteiro
# mtcI (move to coprocessor 1) => copia o conteúdo de $t0 para $f6
mtc1 $t0, $f6
# cvt.s.w (convert single word) => converte o valor inteiro para single
cvt.s.w $f8, $f6
# s.s (save single) => Salva o valor single no endereço
s.s $f8, valorFloat

# Valores depois da conversão
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

lw $a0, valorInteiro    # $a0 = *valorInteiro
li $v0, 1               # Código para imprimir inteiro
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.s $f12, valorFloat    # $f12 = *valorFloat
li $v0, 2               # Código para imprimir float simples
syscall

li $v0, 10
syscall