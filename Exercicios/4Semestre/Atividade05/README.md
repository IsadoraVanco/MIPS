# Atividade 05 - MIPS (02/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.

Exemplo de tradução de código C utilizando malloc() para código MIPS:

```
int *n = malloc(sizeof(int));
*n = 3;

int *vet = malloc(sizeof(int) * 10);
vet[0] = 7;
vet[3] = 11;
vet[8] = 34;

char *s = malloc(sizeof(char) * 20);
scanf("%s", s);
```

```
li $a0, 4   # 4 Bytes (inteiro)
li $v0, 9   # Código de alocação dinâmica heap
syscall     # Aloca 4 Bytes (O endereço retorna em $v0)

move $t0, $v0    # Move para t0
li $t1, 3        # aux = 3
sw $t1, ($t0)    # *n = 3

li $a0, 40       # 40 Bytes (10 inteiros)
li $v0, 9        # Código de alocação dinâmica heap
syscall          # Aloca 4 Bytes (O endereço retorna em $v0)

move $t1, $v0    # Move para t1
li $t2, 7        # aux = 7
sw $t2, ($t1)    # v[0] = 7

li $t2, 11       # aux = 11
sw $t2, 12($t1)  # v[3] = 11

li $t2, 34       # aux = 34
sw $t2, 32($t1)  # v[8] = 34

li $a0, 20       # 20 Bytes (20 char)
li $v0, 9        # Código de alocação dinâmica heap
syscall          # Aloca 20 Bytes (O endereço retorna em $v0) 

move $a0, $v0    # Move o endereço base da string
li $a1, 20       # Número máximo de caracteres
li $v0, 8        # Código para leitura de string
syscall          # scanf("%s", s)
```
 
Utilizando alocação dinâmica em MIPS, implementar os seguintes códigos: 
1. Elaborar um programa que faça a leitura de dois vetores (VetA e VetB) compostos, cada um,  de  n  elementos  inteiros  e  apresente  como  saída  a  somatória  dos  elementos  das posições  pares  de  VetA  subtraída  da  somatória  dos  elementos  das  posições  ímpares  de VetB
2. Desenvolver um programa que faça a leitura de um vetor Vet, de n elementos inteiros, e apresente como saída o maior  e o menor  elementos do vetor e suas  respectivas  posições (primeira posição = 1). 
3. Faça  um  programa  que  leia  dois  vetores  (VetC  e  VetD),  de  n  elementos  inteiros,  e apresente como saída outro vetor (VetE) contendo nas posições pares os valores do primeiro e nas posições impares os valores do segundo. 
4. Elaborar um programa que leia  um vetor Vet, de n elementos inteiros, e o “compacte”, ou seja, elimine as posições com valor igual a zero. Para isso, todos os elementos à frente do valor zero devem ser movidos uma posição para trás do vetor. Apresente como saída o vetor compactado (Vetcomp)