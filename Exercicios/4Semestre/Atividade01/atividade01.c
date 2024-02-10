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
    // qual algoritmo utilizar?

    //quick => precisa de recursão e pode ser que n fique legal no mips
    //bubble => um pouco lento
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
    if(numero < 0){
        numero *= -1;
    }
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
    int contPerfeitos = 0;
    int somaPrimos = 0;
    int contPrimos = 0;

    for(int i = 0; i < TAMANHO_VETOR; i++){

        if(ehPerfeito(vetor[i])){
            somaPerfeitos += vetor[i];
            contPerfeitos++;
            printf("%d) Perfeito: %d\n", contPerfeitos, vetor[i]);
        }
        if(ehSemiprimo(vetor[i])){
            somaPrimos += vetor[i];
            contPrimos++;
            printf("%d) Semiprimos: %d\n",contPrimos, vetor[i]);
        }
    }
    printf("Soma dos %d númmeros perfeitos: %d\n", contPerfeitos, somaPerfeitos);
    printf("Soma dos %d númmeros semiprimos: %d\n", contPrimos, somaPrimos);
    printf("=>Perfeitos - Semiprimos = %d\n", somaPerfeitos - somaPrimos);
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
