CREATE OR REPLACE FUNCTION public.toExtensive (val NUMERIC)
RETURNS VARCHAR AS
$body$
DECLARE
    resto NUMERIC := mod(val, 1); -- parte fracionária do valor
    inteiro INTEGER := val - resto; -- parte inteira do valor
    
    vlrs VARCHAR := CAST(inteiro AS VARCHAR);
    s VARCHAR := '';
    centavos VARCHAR := CAST(CAST(round(resto * 100) AS INTEGER) AS INTEGER);
    saux VARCHAR := '';
    vlrp VARCHAR := '';
    
    unidade VARCHAR[] := ARRAY['', 'um', 'dois', 'três', 'quatro', 'cinco',
             'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
             'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
             'dezessete', 'dezoito', 'dezenove'];
             
    centena VARCHAR[] := ARRAY['', 'cento', 'duzentos', 'trezentos',
             'quatrocentos', 'quinhentos', 'seiscentos',
             'setecentos', 'oitocentos', 'novecentos'];
             
    dezena VARCHAR[] := ARRAY['', '', 'vinte', 'trinta', 'quarenta', 'cinquenta',
             'sessenta', 'setenta', 'oitenta', 'noventa'];
             
    qualificas VARCHAR[] := ARRAY['', 'mil', 'milhão', 'bilhão', 'trilhão'];
    qualificap VARCHAR[] := ARRAY['', 'mil', 'milhões', 'bilhões', 'trilhões'];
    
    n INTEGER;
    unid INTEGER;
    dez INTEGER;
    cent INTEGER;
    tam INTEGER;
    i INTEGER := 0;
    
    umreal boolean := false;
    tem boolean := false;
BEGIN

    IF (val = 0) THEN
        RETURN 'zero';
    END IF;
    
    IF (length(vlrs) > 15) THEN
       RETURN 'Erro: valor superior a 999 trilhões';
    END IF;
    
    -- definindo o extenso da parte inteira do valor
    WHILE (vlrs != '0') LOOP
       tam := length(vlrs);
       IF (tam > 3) THEN
          vlrp := substr(vlrs, tam - 2, tam);
          vlrs := substr(vlrs, 0, tam - 2);
       ELSE -- Última parte do valor
          vlrp := vlrs;
          vlrs := '0';
       END IF;
       
       IF (vlrp != '000') THEN -- #UM
           saux := '';
           IF (vlrp = '100') THEN -- #DOIS
              saux := 'cem';
           ELSE -- #DOIS
              n := CAST(vlrp AS INTEGER);
              cent := n / 100;
              dez := mod(n, 100) / 10;
              unid := mod(mod(n, 100), 10);
              IF (cent != 0) THEN
                 saux := centena[cent + 1];
              END IF;
              IF (mod(n, 100) <= 19) THEN -- #TREIS
                 IF (length(saux) != 0) THEN
                    IF ((unid + dez) != 0) THEN
                       saux := saux || ' e ' || unidade[mod(n, 100) + 1];
                    END IF;
                 ELSE
                    saux := unidade[mod(n, 100) + 1];
                 END IF;
              ELSE -- #TREIS                 
                 IF (length(saux) != 0) THEN
                    saux := saux || ' e ' || dezena[dez + 1];
                 ELSE
                    saux := dezena[dez + 1];
                 END IF;
                 IF (unid != 0) THEN
                    IF (length(saux) != 0) THEN
                       saux := saux || ' e ' || unidade[unid + 1];
                    ELSE
                       saux := unidade[unid + 1];
                    END IF;
                 END IF;
              END IF; -- #TREIS   
           END IF; -- #DOIS
           
           IF ((vlrp = '1') OR (vlrp = '001')) THEN
              IF (i = 0) THEN
                 umreal := true;
              ELSE
                 saux := saux || ' ' || qualificas[i + 1];
              END IF;
           ELSE
              IF (i != 0) THEN
                 saux := saux || ' ' || qualificap[i + 1];
              END IF;
           END IF;
           IF (length(s) != 0) THEN
              s := saux || ', ' || s;
           ELSE
              s := saux;
           END IF;
        END IF; -- #UM
        
        IF (((i = 0) OR (i = 1)) AND length(s) != 0) THEN
           tem := true; -- tem centena ou mil no valor
        END IF;
        i := i + 1;
    END LOOP;
    
    IF (length(s) != 0) THEN
       IF (umreal) THEN
          s := s || ' real';
       ELSE
          IF (tem) THEN
             s := s || ' reais';
          ELSE
             s := s || 'de reais';
          END IF;
       END IF;
    END IF;
    
    -- definindo o extenso dos centavos do valor
    IF (centavos != '0') THEN -- valor com centavos
       IF (length(s) != 0) THEN -- se não é valor somente com centavos
          s := s || ' e ';
       END IF;
       IF (centavos = '1') THEN
          s := s || 'um centavo';
       ELSE
          n := CAST(centavos AS INTEGER);
          IF (n <= 19) THEN
             s := s || unidade[n + 1];
          ELSE
             unid := mod(n, 10);
             dez := n / 10;
             s := s || dezena[dez + 1];
             IF (unid != 0) THEN
                s := s || ' e ' || unidade[unid + 1];
             END IF;
          END IF;
          s := s || ' centavos';
       END IF;
    END IF;
    
    RETURN s;
END
$body$
LANGUAGE 'plpgsql';