.data
double1: .double 3.1415
double2: .double 1.3456
doubleResposta1: .double 0.0
doubleResposta2: .double 0.0
float1: .float 6.99
float2: .float 2.44
floatResposta1: .float 0.0
floatResposta2: .float 0.0
strValorA: .asciiz "\n=> Valor de A (double): "
strValorB: .asciiz "\n=> Valor de B (double): "
strValorC: .asciiz "\n=> Valor de C (float): "
strValorD: .asciiz "\n=> Valor de D (float): "

.text
.globl main
main:
# Valores antes da conversão
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

lw $a0, intPi           # $a0 = *intPi
li $v0, 1               # Código para imprimir inteiro
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.d $f12, pi            # $f12 = *pi
li $v0, 3               # Código para imprimir float double
syscall

# Faz a conversão
# l.d (load double) => carrega o valor double do endereço
l.d $f10, pi
# cvt.w.d (convert word double) => converte o valor inteiro para double
cvt.w.d $f12, $f10
# mtcI (move from coprocessor 1) => copia o conteúdo do coprocessador FPU no registrador destino
mfc1 $t1, $f12
sw $t1, intPi

# Valores depois da conversão
la $a0, strValorA       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

lw $a0, intPi           # $a0 = *intPi
li $v0, 1               # Código para imprimir inteiro
syscall

la $a0, strValorB       # Carrega o endereço da string
li $v0, 4               # Código de impressão de string
syscall                 # Imprime a string

l.d $f12, pi            # $f12 = *pi
li $v0, 3               # Código para imprimir float double
syscall

li $v0, 10
syscall