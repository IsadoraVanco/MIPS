# Atividade 02

Créditos ao prof° Wesley Attrot, autor do exercício.

Considere o seguinte trecho de código:

```
int potencia(int base, int expoente)
{
    if(expoente == 0)
    {
        return 1;
    }
    else
    {
        return base * potencia(base, expoente-1);
    }
}

int main()
{
    int base;
    int expoente;

    printf("Entre com a base:"); scanf("%d", &base);
    printf("Entre com o expoente:"); scanf("%d", &expoente);
    printf("Resultado: %d\n", potencia(base, expoente));

    return 0;
}
```

Traduza o código apresentado para assembly de MIPS e execute o mesmo em um simulador para verificar que o mesmo funciona corretamente. Durante a tradução para assembly, as variáveis locais devem ser mapeadas para os registradores $s0, $s1, .... 

A função int potencia(...) retorna um valor no registrador $v0. Lembre-se de salvar/restaurar os devidos valores na pilha. Para os comandos printf e scanf utilize as syscalls presentes nos simuladores.