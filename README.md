# NumberToExtensive
Função plpgsql postgresql 9.6 que recebe  um valor do tipo numeric e retorna uma string com o valor por extenso.
A Função toExtensive foi adaptada de uma função java do arquigo [Valor por Extenso em uma Aplicação Java](https://www.devmedia.com.br/valor-por-extenso-em-uma-aplicacao-java/21897) da Devmedia publicado em 2011 por Omero Francisco

### Exemplos
    SELECT 1 AS exemplos, 400 AS valor, public.toextensive(400)
    UNION ALL
    SELECT 2 AS exemplos, 0.39 AS valor, public.toextensive(0.39)
    UNION ALL
    SELECT 3 AS exemplos, 1.29 AS valor, public.toextensive(1.29)
    UNION ALL
    SELECT 4 AS exemplos, 123.62 AS valor, public.toextensive(123.62)
    UNION ALL
    SELECT 5 AS exemplos, 54340210.31 AS valor, public.toextensive(54340210.31)
#### Resultados
exemplos | valor       | toextensive
---------|-------------|--------------------------------------------------------------------------------------------------
1        | 400         | quatrocentos reais
2        | 0,39        | trinta e nove centavos
3        | 1,29        | um real e vinte e nove centavos
4        | 123,62      | cento e vinte e três reais e sessenta e dois centavos
5        | 54340210,31 | cinquenta e quatro milhões, trezentos e quarenta mil, duzentos e dez reais e trinta e um centavos
    
