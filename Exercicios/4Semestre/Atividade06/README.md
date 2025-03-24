# Atividade 06 - MIPS (02/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.

1. Elaborar um programa, em código em MIPS, que dado uma sequência de n números reais, determinar os números que compõem a sequência e o número de vezes que cada um ocorre na mesma. Alocar dinamicamente a sequência de números em um vetor. Exemplo:
```
Leitura:
n = 8 
Sequência: -1.7,  3.0,  0.0,  1.5,  0.0, -1.7,  2.3, -1,7 
```
```
Saída:  
-1.7 ocorre 3 vezes  
3.0 ocorre 1 vez  
0.0 ocorre 2 vezes  
1.5 ocorre 1 vez  
2.3 ocorre 1 vez
```

2. Elaborar um programa, em código MIPS, para que dados x real e n natural, calcular uma aproximação para cos (x) através dos n primeiros termos da seguinte série:
```
    cos(x) = 1 + (x^2/ 2!) + ... + [(-1)^k * (x^2k)/(2k!)] ...
```

3. Para  n  alunos  de  uma  determinada  turma  são  atribuídas  ao  longo  do  bimestre  3  notas. Elaborar um programa, em código MIPS, que calcule a média aritmética das provas de cada  aluno,  a  média  da  classe,  o  número  de  aprovados  e  o  número  de  reprovados  (critério  de aprovação: média maior ou igual a 6.0). Utilizar uma matriz com alocação dinâmica e funções no desenvolvimento do programa.  