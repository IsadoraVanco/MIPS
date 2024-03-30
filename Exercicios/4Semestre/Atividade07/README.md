# Atividade 07 - MIPS (02/2023)

Créditos ao profº Fábio Martins, autor dos exercícios.

1. Elaborar um programa, em código MIPS, para que dada uma sequência de n números reais (vetor com alocação dinâmica), determine um segmento de nota máxima. 

    **Exemplo**: na sequência 5.0, 2.0, -2.0, -7.0, 3.0, 14.0, -3.0, 9.0, -6.0, 4.0, 1.0, a soma do maior segmento é 23.0, obtida pela soma dos números de 3.0 até 9.0.

2. Uma rotina muito utilizada por programadores em softwares comerciais é a da validação do Cadastro de Pessoa Física (CPF). Para realizar validação do CPF, é necessário seguir as regras do Ministério da Fazenda. No CPF, as regras de validação dizem que o mesmo deve ter 11 algarismos, onde os dois últimos são chamados de dígitos verificadores, ou seja, os dois últimos dígitos são criados a partir dos nove primeiros. 

    Para exemplificar, vamos utilizar o CPF 222.333.666-XX. 

    **I)** O primeiro passo é multiplicar o primeiro digito por 10, o segundo por 9, e assim por diante, até multiplicar o nono digito por 2 e somar os resultados das multiplicações. 
    
    Por exemplo, para o CPF 222.333.666-XX, esta conta ficará 2x10 + 2 x 9 + 2 x 8 + 3 x 7 + 3 x 6 + 3 x 5 + 6 x 4 + 6 x 3 + 6 x 2 = 162. 

    **II)** Em seguida, é necessário obter o resto da divisão deste resultado por 11. Se o resultado desta operação for menor que 2, o primeiro dígito verificador é zero (0). Caso contrário subtrai-se o valor obtido de 11. 
    
    No nosso caso, o resto da divisão de 162 por 11 é 8, ou seja, sendo assim nosso dígito verificador é 11-8 = 3 (três), já temos parte do CPF, confira: 222.333.666-3X. 

    **III)** Para o cálculo do segundo dígito será usado o primeiro dígito verificador já calculado. Analogamente ao cálculo do primeiro dígito, é necessário multiplicar 11 pelo primeiro dígito, 10 pelo segundo, 9 pelo terceiro, e assim por diante, até multiplicar o nono por 3. 
    
    **IV)** Além disso, é necessário multiplicar o primeiro dígito verificador por 2 e somar o resultado de todas as multiplicações. 
    
    Para o nosso exemplo, este passo ficaria 2 x 11 + 2 x 10 + 2 x 9 + 3 x 8 + 3 x 7 + 3 x 6 + 6 x 5 + 6 x 4 + 6 x 3 + 3 x 2 = 201

    **V)** Em seguida, é necessário obter o resto da divisão desta soma por 11. Analogamente ao passo anterior, se o resultado desta operação for menor que 2, o primeiro dígito verificador é zero (0). Caso contrário subtrai-se o valor obtido de 11. 
    
    No nosso caso, o resto da divisão de 201 por 11 é 3, ou seja, sendo assim nosso segundo dígito verificador 11 - 3 = 8 (oito). Dessa forma, o nosso CPF seria 222.333.666-38. 
    
    Baseado neste algoritmo, elaborar um programa,  em código MIPS, que leia um CPF, contendo 11 algarismos, separando os dígitos do CPF dos dígitos verificadores por um traço(xxxxxxxxx-xx). Em seguida, seu programa deve verificar se o CPF é válido ou não. Não esqueça de validar a entrada de dados, que deve conter 11 dígitos e um traço. 