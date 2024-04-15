/**
 * Verificando os primos gêmeos e armazenando em um arquivo
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

// ************ AUXILIARES ************************************

int lerInteiro(char *string){
    int valor = 0;
    
    while(valor <= 0){
        printf("%s", string);
        scanf("%d", &valor);
    }

    return valor;
}

bool ehPrimo(int n){
    for(int i = 2; i < n; i++){
        if(n % i == 0){
            return false;
        }
    }

    return true;
}

// ************ ARQUIVO ************************************

FILE *abrirArquivo(char *nomeArquivo){
    FILE *arquivo = NULL;

    arquivo = fopen(nomeArquivo, "w");

    return arquivo;
}

void escreverArquivo(FILE *arquivo, char *string){
    fprintf(arquivo, "%s", string);
}

void fecharArquivo(FILE *arquivo){
    fclose(arquivo);
}

int main(int argc, char const *argv[])
{
    int n = lerInteiro("=> Digite um número maior que zero: ");
    FILE *arquivo = abrirArquivo("primosGemeos.txt");
    
    char string[50];
    sprintf(string, "Números primos gêmeos de 1 até %d:\n\n", n);
    
    escreverArquivo(arquivo, string);

    for(int i = 2; i <= n; i++){
        if(ehPrimo(i) && ehPrimo(i + 2)){
            fprintf(arquivo, "%d é primo gêmeo, pois %d também é primo\n", i, (i + 2));
        }
    }

    fecharArquivo(arquivo);

    return 0;
}