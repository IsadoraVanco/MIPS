/**
 * Base para o código MIPS
*/
#include <stdio.h>

#define TAMANHO_VETOR 12

void leitura(int *vetor){
    for(int i = 0; i < TAMANHO_VETOR; i++){
        printf("Vetor [%d]: ", i);
        scanf("%d", &vetor[i]);
    }
}

void escrita(int *vetor){
    for(int i = 0; i < TAMANHO_VETOR; i++){
        printf("%d ", vetor[i]);
    }
    printf("\n");
}

void ordena(int *vetor){
    //bubble => um pouco lento

    int temp;
    for(int i = 0; i < TAMANHO_VETOR - 1; i++){
        for(int j = 0; j < TAMANHO_VETOR - i - 1; j++){
            if(vetor[j] > vetor[j + 1]){
                temp = vetor[j];
                vetor[j] = vetor[j + 1];
                vetor[j + 1] = temp;
            }
        }
    }
}

void somaPares(int *vetor){
    int soma = 0;

    for(int i = 0; i < TAMANHO_VETOR; i++){
        if(vetor[i] == 0){
            continue;
        }else if(vetor[i] % 2 == 0){
            printf("%d ", vetor[i]);
            soma += vetor[i];
        }
    }

    printf("\nTotal: %d\n", soma);
}

void intervalo(int *vetor){
    int chaveK;
    int soma = 0;

    printf("Insira uma chave inteira: ");
    scanf("%d", &chaveK);
    
    while(chaveK < 0){
        printf("A chave deve ser maior que 1!\n");
        printf("Insira uma chave inteira: ");
        scanf("%d", &chaveK);
    }

    printf("Números que estão no intervalo de %d a %d:\n", chaveK, chaveK * 2);
    for(int i = 0; i < TAMANHO_VETOR; i++){
        if(vetor[i] > chaveK && vetor[i] < chaveK * 2){
            printf("%d ", vetor[i]);
            soma++;
        }
    }

    printf("\nTotal: %d\n", soma);
}

void iguais(int *vetor){
    int chaveK;
    int soma = 0;

    printf("Insira uma chave inteira: ");
    scanf("%d", &chaveK);

    for(int i = 0; i < TAMANHO_VETOR; i++){
        if(vetor[i] == chaveK){
            soma++;
        }
    }

    printf("Total de repetições do número (%d): %d\n", chaveK, soma);
}

// Só positivos
int ehPerfeito(int numero){
    int soma = 0;

    for(int i = 1; i < numero; i++){
        if(numero % i == 0){
            soma += i;

            if(soma > numero){
                return 0;   // não é perfeito
            }
        }
    }

    if(soma == numero && numero != 0){
        return 1;   // é perfeito
    }

    return 0;
}

int ehPrimo(int numero){
    if(numero == 0 || numero == 1){
        return 0;
    }

    for(int i = 2; i < numero; i++){
        if(numero % i == 0){
            return 0; //não é primo
        }
    }

    return 1; //é primo
}

int ehSemiprimo(int numero){
    if(numero < 0){
        numero *= -1;
    }

    for(int i = 1; i < numero; i++){
        if(numero % i == 0){ //menos comparações
            if(ehPrimo(i)){
                int coeficiente = numero / i;

                if(ehPrimo(coeficiente)){
                    return 1; // é semiprimo
                }
            }
        }
    }

    return 0; // não é semiprimo
}

void perfeitos(int *vetor){
    int somaPerfeitos = 0;
    // int contPerfeitos = 0;
    int somaSemiprimos = 0;
    // int contPrimos = 0;

    for(int i = 0; i < TAMANHO_VETOR; i++){

        if(ehPerfeito(vetor[i])){
            somaPerfeitos += vetor[i];
            // contPerfeitos++;
            printf("%d) Perfeito: %d\n", vetor[i]);
        }
        if(ehSemiprimo(vetor[i])){
            somaSemiprimos += vetor[i];
            // contPrimos++;
            printf("%d) Semiprimos: %d\n", vetor[i]);
        }
    }
    printf("Soma dos númmeros perfeitos: %d\n", somaPerfeitos);
    printf("Soma dos númmeros semiprimos: %d\n", somaSemiprimos);
    printf("=>Perfeitos - Semiprimos = %d\n", somaPerfeitos - somaSemiprimos);
}

int main(int argc, char const *argv[])
{
    int vetor[TAMANHO_VETOR];

    printf("1) Lendo o vetor: \n");
    leitura(vetor);

    printf("\n2) Mostra o vetor: \n");
    escrita(vetor);

    ordena(vetor);
    printf("\n3) Mostra o vetor ordenado: \n");
    escrita(vetor);

    printf("\n4) Soma os pares: \n");
    somaPares(vetor);

    printf("\n5) Intervalo: \n");
    intervalo(vetor);

    printf("\n6) Iguais: \n");
    iguais(vetor);

    printf("\n7) Soma dos perfeitos e semiprimos: \n");
    perfeitos(vetor);

    return 0;
}
