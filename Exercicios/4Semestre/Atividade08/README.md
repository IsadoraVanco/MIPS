# Atividade 08 - MIPS (02/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.

1. Um número primo é considerado gêmeo se o próximo número primo for igual a ele mais dois. Elaborar um programa em MIPS para salvar todos os números gêmeos de 1 até N em um arquivo

2. Elaborar  um  programa,  em  código  MIPS,  que  receba  do  usuário  um  arquivo  texto.  Crie outro arquivo texto contendo o texto do arquivo de entrada, mas com as vogais substituídas por ‘*’ (asterisco).

3. O programa abaixo abre um arquivo com um vetor de inteiros, lê a i-ésima posição do vetor (i  indicado  pelo  usuário),  incrementa  uma  unidade  e  grava  no  mesmo  ponto  do  arquivo. Implementar o programa em código MIPS.

```
#include <stdio.h>
int main(void){
    int vet[4] = {5, 10, 15, 20};
    int i, elem;
    FILE *arq;

    arq = fopen("vet.dat", "w+b");

    if(arq != NULL){
        fwrite(vet, sizeof(int), 4, arq);
        scanf("%d", &i);
        
        if(i >= 0 && i < 4){
            fseek(arq, i * sizeof(int), SEEK_SET);
            fread(&elem, sizeof(int), 1, arq);
            elem = elem + 1;
            fseek(arq, -sizeof(int), SEEK_CUR);
            fwrite(&elem, sizeof(int), 1, arq);
        }

        rewind(arq);
        fread(vet, sizeof(int), 4, arq);

        for(i = 0; i < 4; i++){
            printf("%d", vet[i]);
            fclose(arq);
        }
    }else{
        printf("Não foi possível abrir o arquivo");
    }

    return 0;
}
```

Exemplo de código para escrita em um arquivo:

```
.data
Arquivo: .asciiz "teste.txt"
Msg: .asciiz "Escrevendo em um arquivo"

.text
main:
    la $a0, Arquivo
    li $a1, 1       # Somente escrita
    li $v0, 13      # Abertura de arquivo
    syscall

    move $a0, $v0   # Parâmetro file descriptor
    li $a1, Msg
    li $a2, 24      # Número de caracteres
    li $v0, 15      # Escrita em arquivo
    syscall

    li $v0, 16      # Fechar arquivo
    syscall

    li $v0, 10      # Finalizar programa
    syscall
```

4. Elaborar um programa, em MIPS, que leia um arquivo que contenha as dimensões de uma matriz (linha e coluna), a quantidade de posições que serão anuladas, e as posições a serem anuladas (linha e coluna). O programa lê esse arquivo e, em seguida, produz um novo arquivo com a matriz com as dimensões dadas no arquivo lido, e todas as posições especifica das no arquivo ZERADAS e o restante recebendo o valor 1.

Exemplo:
```
arquivo “matriz.txt” 
3 3 2 -> matriz 3x3, 2 posições anuladas
1 0   -> Coordenada que será anulada
1 2   -> Coordenada que será anulada

arquivo “matriz saida.txt” 
1 1 1 
0 1 0 
1 1 1 
```

5. Escreva um programa, em MIPS, que receba dois arquivos textos e determine se existe pelo  menos  uma mesma  sequência  de  palavras  de  tamanho  maior  ou  igual  a  cinco  (5)  em ambos os arquivos

Exemplo de código para escrita de valores ímpares em um arquivo
```
.data
Buffer: .space 20
newLine: .asciiz "\r\n"
Arquivo: .asciiz "impares.txt"

.text
main:
    la $a0, Arquivo
    li $a1, 1       # Somente escrita
    li $v0, 13      # Abertura do arquivo
    syscall

    move $s0, $v0
    jal escreveImpar

    move $a0, $s0
    li $v0, 16     # Fechar arquivo
    syscall

    li $v0, 10
    syscall

intString:
    div $a0, $a0, 10
    mfhi $t0
    
    subi $sp, $sp, 4
    
    sw $t0, ($sp)
    addi $v0, $v0, 1

    bnez $a0, intString     # if(n != 0): goto intString

    i:
        lw $t0, ($sp)
        addi $sp, $sp, 4
        addi $t0, $t0, 48
        sb $t0, ($a1)       # Armazena no buffer de saida

        addi $a1, $a1, 1
        addi $t1, $t1, 1

        bne $t1, $v0, i     # if(iterações != num. caracteres): goto i 

        sb $zero, ($a1)     # buffer = NULL
        jr $ra

escreveImpar:
    move $t2, $ra

    e:
        li $v0, 5   # Leitura de inteiro
        syscall

        blez $v0, s # if(n == 0): goto s

        andi $t0, $v0, 1    # Armazena 0 se N for par, 1 se é ímpar

        beqz $t0, e         # if(n par): goto e
        
        move $a0, $v0       
        la $a1, Buffer 
        li $v0, 0
        li $t1, 0
        jal intString

        move $a0, $s0
        la $a1, Buffer
        move $a2, $v0
        li $v0, 15      # Escrita de arquivo
        syscall

        la $a1, newLine
        li $a2, 2       # Número de caracteres
        li $v0, 15      # Escrita de arquivo
        syscall

        j e

    s:
        jr $ra
```