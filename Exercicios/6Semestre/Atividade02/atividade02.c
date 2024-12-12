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