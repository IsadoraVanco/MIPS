# Slide 51
# Implementar no código MIPS o procedimento dado em C:
# int calculo (int x, int y, int z, int w) {
# int f;
# f=[(x+y) *(z+w)] – 5
# return f;
# }

.data 
valor: .asciiz "\nDigite um valor: "
string: .asciiz "\nO resultado do número mágico é "

.text
.globl main
main:
    # Leitura dos valores

    # $s0 = x
    jal leValor 
    add $s0, $zero, $v0 

    # $s1 = y
    jal leValor 
    add $s1, $zero, $v0 

    # $s2 = w
    jal leValor 
    add $s2, $zero, $v0 

    # $s3 = z
    jal leValor 
    add $s3, $zero, $v0 

    # $t0 = x + y
    add $t0, $s0, $s1

    # $t1 = w + z
    add $t1, $s2, $s3

    # $s4 = (x + y) * (w + z)
    mul $s4, $t0, $t1

    # $s4 -= 5
    subi $s4, $s4, 5

    # Print($s4)
    add $a0, $zero, $s4
    jal print

    j exit

leValor:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, valor # Configura o argumento da função
    syscall # Print(valor)

    li $v0, 5 # Configura o syscall para ler inteiros
    syscall # O número lido vai ficar em v0

    jr $ra # Volta para depois da chamada da função

print: 
    # O número será passado pelo argumento $a0
    add $t0, $zero, $a0

    la $a0, string
    li $v0, 4 
    syscall # Print(string)

    add $a0, $zero, $t0
    li $v0, 1 
    syscall # Print($a0)

    jr $ra # Volta para depois da chamada da função


exit: