/**
 * @brief Compacta vetores (base para o MIPS)
*/
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char const *argv[])
{
    int *vetor;
    int tamanho = 0;

    printf("Tamanho do vetor: ");
    scanf("%d", &tamanho);

    vetor = malloc(sizeof(int) * tamanho);

    for(int i = 0; i < tamanho; i++){
        printf("[%d]: ", i);
        scanf("%d", &vetor[i]);
    }

    // Compacta o vetor
    for(int j = 0; j < tamanho; j++){

        if(vetor[j] == 0){

            // Procura um válido e troca
            for(int k = j + 1; k < tamanho; k++){

                if(vetor[k] != 0){
                    vetor[j] = vetor[k];
                    vetor[k] = 0;
                    break;
                }
            }//arrumaIndice
        }
    }//fimCompactar

    for(int i = 0; i < tamanho; i++){
        printf("[%d]: %d\n", i, vetor[i]);
    }


    return 0;
}
