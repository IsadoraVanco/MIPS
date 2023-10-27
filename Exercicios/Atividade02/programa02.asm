# 2. Escreva os programas abaixo, utilizando procedimentos, 
# em código MIPS. O código deve comentado e testado no MARS. 
# Enviar o código fonte.

# #include <stdio.h>
# int squares [64];

# void storeValues (int n) {
#    int i;
#    for(i = 0; i < n ; i++) {
#        squares [i] = i * i;
#    }
#}

# int computeSum(int n) {
#    int i, sum;
#    sum = 0;
#    for (i = 0; i < n ; i++){
#        sum += squares [i];
#        return sum;
#    }
#}

# int main () {
#    int upTo;
#    scanf ("%d" &upTo) ;
#    storeValues(upTo);
#    printf("sum = %d\n", computeSum (upTo));
#    return 0;
#}

# Aluna: Isadora Vanço
.data
valor: .asciiz "\nDigite um valor: "
stringErroNegativos: .asciiz "\nO número fornecido é negativo ou nulo"
stringErroMaiores: .asciiz "\nO número fornecido é maior que 64"
stringSoma: .asciiz "\nsum = "
ln: .asciiz "\n"
squares: 
    .align 2 # Alinha o endereço de memória em um múltiplo de 2
    .space 264 # Reserva um espaço de 64 inteiros (4 bytes cada)

.text
.globl main
main:
    # Leitura do valor

    # $s0 = upTo
    jal scanf # Lê o valor de upTo
    add $s0, $zero, $v0 # upTo recebe o valor retornado

    # Verifica se está no intervalo esperado

    slti $t0, $s0, 1 # if (upTo < 1){$t0 = 1: $t0 = 0}
    bne $t0, $zero, erroNegativos # if($t0 != 0): erroNegativos

    addi $t0, $zero, 64 # $t0 = 64
    slt $t1, $t0, $s0 # if(64 < upTo){$t1 = 1: $t1 = 0}
    bne $t1, $zero, erroMaiores # if($t1 != 0): erroMaiores

    # Guarda os valores

    add $a0, $zero, $s0 # Passa o upTo como parâmetro para a função
    jal storeValues # Vai para a função storeValues

    # Computa os valores

    add $a0, $zero, $s0 # Passa o upTo como parâmetro para a função
    jal computeSum # Vai para a função computeSum
    # $s1 = computeSum(upTo)
    add $s1, $zero, $v0 # Guarda o valor retornado pela função

    # Imprime soma

    add $a0, $zero, $s1 # Passa a soma como parâmetro para a função
    jal printSoma # Vai para o print

    j exit

scanf:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, valor # Configura o argumento da função
    syscall # Print(valor)

    li $v0, 5 # Configura o syscall para ler inteiros
    syscall # O número lido vai ficar em v0

    jr $ra # Volta para depois da chamada da função

printSoma: 
    # O valor da soma será passado pelo argumento $a0

    add $t0, $zero, $a0 # $t0 = $a0

    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, stringSoma # Configura o argumento da função
    syscall # Print(stringSoma)

    add $a0, $zero, $t0 # Configura o argumento da função
    li $v0, 1 # Configura o syscall para escrever inteiros
    syscall # Print($a0)

    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, ln # Configura o argumento da função
    syscall # Print(ln)

    jr $ra # Volta para depois da chamada da função

erroNegativos:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, stringErroNegativos # Configura o argumento da função
    syscall # Print(stringErroNegativos)

    j exit # Vai para exit

erroMaiores:
    li $v0, 4 # Configura o syscall para escrever strings
    la $a0, stringErroMaiores # Configura o argumento da função
    syscall # Print(stringErroMaiores)

    j exit # Vai para exit

storeValues:
    # O valor n será passado pelo argumento $a0

    # $t0 = i
    add $t0, $zero, $zero # i = 0
    # $t1 = *squares
    la $t1, squares

    loopStore:
        beq $t0, $a0, return # if(i == $a0): return

        sll $t2, $t0, 2 # $t2 = 4 * i
        add $t2, $t2, $t1 # $t2 += squares

        mul $t3, $t0, $t0 # $t3 = i * i
        sw $t3, 0($t2) # squares[i] = i * i

        addi $t0, $t0, 1 # i++

        j loopStore # Vai para loopStore

    return:
    jr $ra # Volta para depois da chamada da função

computeSum:
    # O valor n será passado pelo argumento $a0

    # $t0 = i
    add $t0, $zero, $zero # i = 0
    # $t1 = *squares
    la $t1, squares
    # $t2 = sum
    add $t2, $zero, $zero # sum = 0

    loopCompute:
        beq $t0, $a0, returnSum # if(i == $a0): returnSum

        sll $t3, $t0, 2 # $t3 = 4 * i
        add $t3, $t3, $t1 # $t3 += squares

        lw $t4, 0($t3) # $t4 = squares[i]
        add $t2, $t2, $t4 # sum += squares[i]

        addi $t0, $t0, 1 # i++

        j loopCompute # Vai para loopCompute

    returnSum:
    # O resultado será retornado em $v0
    add $v0, $zero, $t2 # $v0 = sum
    jr $ra # Volta para depois da chamada da função

exit: