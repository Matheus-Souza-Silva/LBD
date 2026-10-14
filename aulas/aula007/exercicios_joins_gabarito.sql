-- =====================================================================
-- LISTA DE EXERCÍCIOS — JOINS, UNION e UNION ALL  (com gabarito)
-- Banco: SUPERMERCADO
-- Pré-requisito: executar bd_supermercado.sql e inserts_supermercado.sql
--
--   INNER JOIN ........ exercícios 01, 02 e 03
--   LEFT JOIN ......... exercícios 04 e 05
--   RIGHT JOIN ........ exercícios 06 e 07
--   SELF JOIN ......... exercício  08
--   UNION ............. exercício  09
--   UNION ALL ......... exercício  10
--
-- Todos os gabaritos foram testados (MariaDB 10.11 / compatível com MySQL 8).
-- =====================================================================

USE SUPERMERCADO;


-- =====================================================================
-- EXERCÍCIO 01 — INNER JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste o NOME, o CPF, a CIDADE e a UF de todos os clientes cadastrados,
-- em ordem alfabética de nome.
-- Tabelas: PESSOA, CLIENTE
--
-- GABARITO:
SELECT P.NOME, C.CPF, P.CIDADE, P.UF
FROM PESSOA P
INNER JOIN CLIENTE C ON C.CODIGO = P.CODIGO
ORDER BY P.NOME;

-- Resultado esperado:
-- +----------------+----------------+--------------+----+
-- | NOME           | CPF            | CIDADE       | UF |
-- +----------------+----------------+--------------+----+
-- | Ana Souza      | 111.111.111-11 | Brasília     | DF |
-- | Bruno Lima     | 222.222.222-22 | Taguatinga   | DF |
-- | Carla Mendes   | 333.333.333-33 | Goiânia      | GO |
-- | Diego Rocha    | 444.444.444-44 | Brasília     | DF |
-- | Eduarda Alves  | 555.555.555-55 | Águas Claras | DF |
-- | Felipe Costa   | 666.666.666-66 | Anápolis     | GO |
-- | Lucas Ferreira | 121.212.121-21 | Uberlândia   | MG |
-- +----------------+----------------+--------------+----+
-- (7 linhas)
--
-- Comentários:
-- Só aparecem pessoas que existem nas DUAS tabelas. Karina Duarte (11) e os
-- vendedores que não são clientes ficam de fora.

-- =====================================================================
-- EXERCÍCIO 02 — INNER JOIN — 3 tabelas (básico/intermediário)
-- =====================================================================
-- Mostre o código do pedido, a data, o NOME do cliente e o valor total
-- de todos os pedidos CONFIRMADOS, do mais antigo para o mais recente.
-- Tabelas: PEDIDO, CLIENTE, PESSOA
--
-- GABARITO:
SELECT PE.CODIGO AS PEDIDO, PE.DATA_PEDIDO, P.NOME AS CLIENTE, PE.VALOR_TOTAL
FROM PEDIDO PE
INNER JOIN CLIENTE C ON C.CODIGO = PE.COD_CLIENTE
INNER JOIN PESSOA  P ON P.CODIGO = C.CODIGO
WHERE PE.CONFIRMADO = 1
ORDER BY PE.DATA_PEDIDO;

-- Resultado esperado:
-- +--------+---------------------+---------------+-------------+
-- | PEDIDO | DATA_PEDIDO         | CLIENTE       | VALOR_TOTAL |
-- +--------+---------------------+---------------+-------------+
-- | 1      | 2026-09-01 10:15:00 | Ana Souza     | 113.01      |
-- | 2      | 2026-09-03 16:20:00 | Bruno Lima    | 28.48       |
-- | 4      | 2026-09-10 18:05:00 | Ana Souza     | 52.70       |
-- | 5      | 2026-09-12 11:30:00 | Diego Rocha   | 91.38       |
-- | 6      | 2026-09-15 14:50:00 | Eduarda Alves | 29.76       |
-- | 8      | 2026-09-25 08:25:00 | Bruno Lima    | 57.70       |
-- +--------+---------------------+---------------+-------------+
-- (6 linhas)
--
-- Comentários:
-- O nome do cliente não está em CLIENTE, e sim em PESSOA — por isso a
-- terceira tabela. Os pedidos 3 e 7 (CONFIRMADO = 0) não aparecem.

-- =====================================================================
-- EXERCÍCIO 03 — INNER JOIN — o máximo de tabelas do banco (intermediário)
-- =====================================================================
-- Monte um relatório detalhado dos pedidos CONFIRMADOS contendo:
-- código do pedido, nome do cliente, usuário (login) do cliente, nome do
-- vendedor, salário do vendedor após o reajuste, nome do produto,
-- quantidade, subtotal e a URL da imagem PRINCIPAL do produto (NUMERO_IMAGEM = 1).
-- Considere apenas reajustes salariais feitos a partir de 01/06/2026.
-- Ordene por pedido e nome do produto.
-- Tabelas: TODAS as 9 do banco (PESSOA é usada duas vezes, com apelidos
-- diferentes: uma para o cliente e outra para o vendedor).
--
-- GABARITO:
SELECT PE.CODIGO               AS PEDIDO,
       PC.NOME                 AS CLIENTE,
       L.USUARIO               AS LOGIN_CLIENTE,
       PV.NOME                 AS VENDEDOR,
       H.SALARIO_NOVO          AS SALARIO_APOS_REAJUSTE,
       PR.NOME                 AS PRODUTO,
       IP.QUANTIDADE,
       IP.SUBTOTAL,
       IM.URL                  AS IMAGEM_PRINCIPAL
FROM PEDIDO PE
INNER JOIN CLIENTE           C  ON C.CODIGO  = PE.COD_CLIENTE
INNER JOIN PESSOA            PC ON PC.CODIGO = C.CODIGO
INNER JOIN LOGIN             L  ON L.CODIGO  = PC.CODIGO
INNER JOIN VENDEDOR          V  ON V.CODIGO  = PE.COD_VENDEDOR
INNER JOIN PESSOA            PV ON PV.CODIGO = V.CODIGO
INNER JOIN HISTORICO_SALARIO H  ON H.CODIGO_VENDEDOR = V.CODIGO
INNER JOIN ITEM_PEDIDO       IP ON IP.CODIGO_PEDIDO  = PE.CODIGO
INNER JOIN PRODUTO           PR ON PR.CODIGO = IP.CODIGO_PRODUTO
INNER JOIN IMAGEM            IM ON IM.CODIGO_PRODUTO = PR.CODIGO
WHERE PE.CONFIRMADO = 1
  AND IM.NUMERO_IMAGEM = 1
  AND H.DATA_HORA_ALTERACAO >= '2026-06-01'
ORDER BY PE.CODIGO, PR.NOME;

-- Resultado esperado:
-- +--------+---------------+---------------+----------------+-----------------------+---------------------+------------+----------+----------------------------------------------------+
-- | PEDIDO | CLIENTE       | LOGIN_CLIENTE | VENDEDOR       | SALARIO_APOS_REAJUSTE | PRODUTO             | QUANTIDADE | SUBTOTAL | IMAGEM_PRINCIPAL                                   |
-- +--------+---------------+---------------+----------------+-----------------------+---------------------+------------+----------+----------------------------------------------------+
-- | 1      | Ana Souza     | ana.souza     | Gabriela Nunes | 3200.00               | Arroz Tipo 1 5kg    | 2          | 55.80    | https://cdn.supermercado.com/img/arroz_frente.jpg  |
-- | 1      | Ana Souza     | ana.souza     | Gabriela Nunes | 3200.00               | Feijão Carioca 1kg  | 3          | 25.47    | https://cdn.supermercado.com/img/feijao_frente.jpg |
-- | 1      | Ana Souza     | ana.souza     | Gabriela Nunes | 3200.00               | Leite Integral 1L   | 6          | 31.74    | https://cdn.supermercado.com/img/leite_frente.jpg  |
-- | 2      | Bruno Lima    | bruno.lima    | Henrique Prado | 2700.00               | Açúcar Refinado 1kg | 2          | 9.58     | https://cdn.supermercado.com/img/acucar_frente.jpg |
-- | 2      | Bruno Lima    | bruno.lima    | Henrique Prado | 2700.00               | Café Torrado 500g   | 1          | 18.90    | https://cdn.supermercado.com/img/cafe_frente.jpg   |
-- | 4      | Ana Souza     | ana.souza     | Isabela Torres | 3100.00               | Café Torrado 500g   | 2          | 37.80    | https://cdn.supermercado.com/img/cafe_frente.jpg   |
-- | 6      | Eduarda Alves | eduarda.alves | Henrique Prado | 2700.00               | Açúcar Refinado 1kg | 1          | 4.79     | https://cdn.supermercado.com/img/acucar_frente.jpg |
-- | 6      | Eduarda Alves | eduarda.alves | Henrique Prado | 2700.00               | Feijão Carioca 1kg  | 2          | 16.98    | https://cdn.supermercado.com/img/feijao_frente.jpg |
-- | 6      | Eduarda Alves | eduarda.alves | Henrique Prado | 2700.00               | Óleo de Soja 900ml  | 1          | 7.99     | https://cdn.supermercado.com/img/oleo_frente.jpg   |
-- | 8      | Bruno Lima    | bruno.lima    | Gabriela Nunes | 3200.00               | Arroz Tipo 1 5kg    | 1          | 27.90    | https://cdn.supermercado.com/img/arroz_frente.jpg  |
-- +--------+---------------+---------------+----------------+-----------------------+---------------------+------------+----------+----------------------------------------------------+
-- (10 linhas)
--
-- Comentários:
-- - PESSOA aparece 2x (PC = cliente, PV = vendedor): uso obrigatório de alias.
-- - HISTORICO_SALARIO não tem FOREIGN KEY, mas CODIGO_VENDEDOR se relaciona
--   logicamente com VENDEDOR.CODIGO — JOIN não depende de FK declarada.
-- - Linhas "somem" por causa do INNER JOIN: o pedido 5 sai (Eduarda não tem
--   reajuste no histórico), o Sabão em Pó sai (produto sem imagem).
-- - Sem o filtro de data, a Gabriela apareceria duplicada (2 reajustes).

-- =====================================================================
-- EXERCÍCIO 04 — LEFT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste TODOS os produtos (código e nome) com os pedidos em que aparecem e
-- a quantidade vendida. Produtos que nunca foram vendidos também devem
-- aparecer na listagem.
-- Tabelas: PRODUTO, ITEM_PEDIDO
--
-- GABARITO:
SELECT PR.CODIGO, PR.NOME, IP.CODIGO_PEDIDO, IP.QUANTIDADE
FROM PRODUTO PR
LEFT JOIN ITEM_PEDIDO IP ON IP.CODIGO_PRODUTO = PR.CODIGO
ORDER BY PR.CODIGO, IP.CODIGO_PEDIDO;

-- Resultado esperado:
-- +--------+---------------------------+---------------+------------+
-- | CODIGO | NOME                      | CODIGO_PEDIDO | QUANTIDADE |
-- +--------+---------------------------+---------------+------------+
-- | 1      | Arroz Tipo 1 5kg          | 1             | 2          |
-- | 1      | Arroz Tipo 1 5kg          | 5             | 1          |
-- | 1      | Arroz Tipo 1 5kg          | 8             | 1          |
-- | 2      | Feijão Carioca 1kg        | 1             | 3          |
-- | 2      | Feijão Carioca 1kg        | 6             | 2          |
-- | 3      | Café Torrado 500g         | 2             | 1          |
-- | 3      | Café Torrado 500g         | 4             | 2          |
-- | 4      | Leite Integral 1L         | 1             | 6          |
-- | 4      | Leite Integral 1L         | 5             | 12         |
-- | 5      | Óleo de Soja 900ml        | 3             | 2          |
-- | 5      | Óleo de Soja 900ml        | 6             | 1          |
-- | 6      | Açúcar Refinado 1kg       | 2             | 2          |
-- | 6      | Açúcar Refinado 1kg       | 6             | 1          |
-- | 7      | Macarrão Espaguete 500g   | 3             | 4          |
-- | 7      | Macarrão Espaguete 500g   | 7             | 3          |
-- | 8      | Sabão em Pó 1kg           | 4             | 1          |
-- | 8      | Sabão em Pó 1kg           | 8             | 2          |
-- | 9      | Azeite Extra Virgem 500ml | NULL          | NULL       |
-- | 10     | Chocolate em Barra 90g    | NULL          | NULL       |
-- +--------+---------------------------+---------------+------------+
-- (19 linhas)
--
-- Comentários:
-- Azeite (9) e Chocolate (10) aparecem com NULL: nunca foram vendidos.
-- Desafio extra: adicione WHERE IP.CODIGO_PEDIDO IS NULL para listar apenas
-- os produtos nunca vendidos.

-- =====================================================================
-- EXERCÍCIO 05 — LEFT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Para CADA cliente, mostre o nome, a quantidade de pedidos realizados e o
-- total gasto. Clientes que nunca fizeram pedido devem aparecer com 0.
-- Ordene pela quantidade de pedidos (maior primeiro) e depois pelo nome.
-- Tabelas: CLIENTE, PESSOA, PEDIDO
--
-- GABARITO:
SELECT P.NOME AS CLIENTE,
       COUNT(PE.CODIGO)              AS QTD_PEDIDOS,
       COALESCE(SUM(PE.VALOR_TOTAL), 0) AS TOTAL_GASTO
FROM CLIENTE C
INNER JOIN PESSOA P ON P.CODIGO = C.CODIGO
LEFT  JOIN PEDIDO PE ON PE.COD_CLIENTE = C.CODIGO
GROUP BY C.CODIGO, P.NOME
ORDER BY QTD_PEDIDOS DESC, P.NOME;

-- Resultado esperado:
-- +----------------+-------------+-------------+
-- | CLIENTE        | QTD_PEDIDOS | TOTAL_GASTO |
-- +----------------+-------------+-------------+
-- | Ana Souza      | 2           | 165.71      |
-- | Bruno Lima     | 2           | 86.18       |
-- | Carla Mendes   | 1           | 34.34       |
-- | Diego Rocha    | 1           | 91.38       |
-- | Eduarda Alves  | 1           | 29.76       |
-- | Lucas Ferreira | 1           | 13.77       |
-- | Felipe Costa   | 0           | 0.00        |
-- +----------------+-------------+-------------+
-- (7 linhas)
--
-- Comentários:
-- - Felipe Costa aparece com 0 pedidos graças ao LEFT JOIN.
-- - COUNT(PE.CODIGO) conta só valores não nulos (COUNT(*) daria 1 para o Felipe!).
-- - COALESCE troca o NULL da soma por 0.

-- =====================================================================
-- EXERCÍCIO 06 — RIGHT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Usando RIGHT JOIN, liste TODOS os produtos com suas imagens (número e URL).
-- Produtos sem imagem também devem aparecer.
-- Tabelas: IMAGEM, PRODUTO (nesta ordem no FROM)
--
-- GABARITO:
SELECT PR.CODIGO, PR.NOME, IM.NUMERO_IMAGEM, IM.URL
FROM IMAGEM IM
RIGHT JOIN PRODUTO PR ON PR.CODIGO = IM.CODIGO_PRODUTO
ORDER BY PR.CODIGO, IM.NUMERO_IMAGEM;

-- Resultado esperado:
-- +--------+---------------------------+---------------+----------------------------------------------------+
-- | CODIGO | NOME                      | NUMERO_IMAGEM | URL                                                |
-- +--------+---------------------------+---------------+----------------------------------------------------+
-- | 1      | Arroz Tipo 1 5kg          | 1             | https://cdn.supermercado.com/img/arroz_frente.jpg  |
-- | 1      | Arroz Tipo 1 5kg          | 2             | https://cdn.supermercado.com/img/arroz_verso.jpg   |
-- | 2      | Feijão Carioca 1kg        | 1             | https://cdn.supermercado.com/img/feijao_frente.jpg |
-- | 3      | Café Torrado 500g         | 1             | https://cdn.supermercado.com/img/cafe_frente.jpg   |
-- | 3      | Café Torrado 500g         | 2             | https://cdn.supermercado.com/img/cafe_xicara.jpg   |
-- | 4      | Leite Integral 1L         | 1             | https://cdn.supermercado.com/img/leite_frente.jpg  |
-- | 5      | Óleo de Soja 900ml        | 1             | https://cdn.supermercado.com/img/oleo_frente.jpg   |
-- | 6      | Açúcar Refinado 1kg       | 1             | https://cdn.supermercado.com/img/acucar_frente.jpg |
-- | 7      | Macarrão Espaguete 500g   | NULL          | NULL                                               |
-- | 8      | Sabão em Pó 1kg           | NULL          | NULL                                               |
-- | 9      | Azeite Extra Virgem 500ml | NULL          | NULL                                               |
-- | 10     | Chocolate em Barra 90g    | NULL          | NULL                                               |
-- +--------+---------------------------+---------------+----------------------------------------------------+
-- (12 linhas)
--
-- Comentários:
-- PRODUTO está à DIREITA, então todos os produtos são preservados.
-- Produtos 7 a 10 aparecem com NULL. Compare: é o mesmo resultado de
-- PRODUTO LEFT JOIN IMAGEM — RIGHT JOIN é o LEFT JOIN "espelhado".

-- =====================================================================
-- EXERCÍCIO 07 — RIGHT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Usando RIGHT JOIN, mostre o nome de TODOS os vendedores, a faixa de
-- comissão, a quantidade de pedidos atendidos e o total vendido.
-- Vendedores sem nenhum pedido devem aparecer com 0.
-- Ordene pelo total vendido (maior primeiro).
-- Tabelas: PEDIDO, VENDEDOR, PESSOA (comece o FROM por PEDIDO)
--
-- GABARITO:
SELECT P.NOME AS VENDEDOR,
       V.FAIXA_COMISSAO,
       COUNT(PE.CODIGO)                 AS QTD_PEDIDOS,
       COALESCE(SUM(PE.VALOR_TOTAL), 0) AS TOTAL_VENDIDO
FROM PEDIDO PE
RIGHT JOIN VENDEDOR V ON V.CODIGO = PE.COD_VENDEDOR
INNER JOIN PESSOA   P ON P.CODIGO = V.CODIGO
GROUP BY V.CODIGO, P.NOME, V.FAIXA_COMISSAO
ORDER BY TOTAL_VENDIDO DESC;

-- Resultado esperado:
-- +------------------+----------------+-------------+---------------+
-- | VENDEDOR         | FAIXA_COMISSAO | QTD_PEDIDOS | TOTAL_VENDIDO |
-- +------------------+----------------+-------------+---------------+
-- | Gabriela Nunes   | A              | 3           | 205.05        |
-- | Eduarda Alves    | C              | 1           | 91.38         |
-- | Isabela Torres   | A              | 2           | 66.47         |
-- | Henrique Prado   | B              | 2           | 58.24         |
-- | João Pedro Ramos | D              | 0           | 0.00          |
-- +------------------+----------------+-------------+---------------+
-- (5 linhas)
--
-- Comentários:
-- João Pedro Ramos (vendedor 10) aparece com 0 pedidos.
-- O RIGHT JOIN preserva os vendedores; o INNER JOIN com PESSOA só busca o
-- nome (todo vendedor é uma pessoa, então não se perde nenhuma linha).

-- =====================================================================
-- EXERCÍCIO 08 — SELF JOIN (básico)
-- =====================================================================
-- Liste os pares de pessoas que moram na MESMA cidade, mostrando o nome das
-- duas pessoas e a cidade. Cada par deve aparecer uma única vez e uma pessoa
-- não pode formar par com ela mesma.
-- Tabela: PESSOA (unida com ela mesma)
--
-- GABARITO:
SELECT A.NOME AS PESSOA_1, B.NOME AS PESSOA_2, A.CIDADE
FROM PESSOA A
INNER JOIN PESSOA B
        ON A.CIDADE = B.CIDADE
       AND A.CODIGO < B.CODIGO
ORDER BY A.CIDADE, A.NOME;

-- Resultado esperado:
-- +----------------+----------------+------------+
-- | PESSOA_1       | PESSOA_2       | CIDADE     |
-- +----------------+----------------+------------+
-- | Ana Souza      | Diego Rocha    | Brasília   |
-- | Ana Souza      | Gabriela Nunes | Brasília   |
-- | Ana Souza      | Karina Duarte  | Brasília   |
-- | Diego Rocha    | Gabriela Nunes | Brasília   |
-- | Diego Rocha    | Karina Duarte  | Brasília   |
-- | Gabriela Nunes | Karina Duarte  | Brasília   |
-- | Carla Mendes   | Henrique Prado | Goiânia    |
-- | Bruno Lima     | Isabela Torres | Taguatinga |
-- +----------------+----------------+------------+
-- (8 linhas)
--
-- Comentários:
-- A.CODIGO < B.CODIGO evita (a) a pessoa pareada com ela mesma e
-- (b) pares repetidos invertidos (Ana–Diego e Diego–Ana).
-- Teste trocando por <> e veja o resultado dobrar.

-- =====================================================================
-- EXERCÍCIO 09 — UNION (básico)
-- =====================================================================
-- Liste, sem repetição, todas as cidades (e UF) onde existem clientes
-- OU vendedores.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- GABARITO:
SELECT P.CIDADE, P.UF
FROM CLIENTE C
INNER JOIN PESSOA P ON P.CODIGO = C.CODIGO
UNION
SELECT P.CIDADE, P.UF
FROM VENDEDOR V
INNER JOIN PESSOA P ON P.CODIGO = V.CODIGO
ORDER BY CIDADE;

-- Resultado esperado:
-- +--------------+----+
-- | CIDADE       | UF |
-- +--------------+----+
-- | Águas Claras | DF |
-- | Anápolis     | GO |
-- | Brasília     | DF |
-- | Ceilândia    | DF |
-- | Goiânia      | GO |
-- | Taguatinga   | DF |
-- | Uberlândia   | MG |
-- +--------------+----+
-- (7 linhas)
--
-- Comentários:
-- Brasília, Goiânia, Taguatinga e Águas Claras têm clientes e vendedores,
-- mas aparecem uma única vez: UNION elimina duplicatas. Ceilândia vem só do
-- vendedor João Pedro; Anápolis e Uberlândia, só de clientes.

-- =====================================================================
-- EXERCÍCIO 10 — UNION ALL (básico)
-- =====================================================================
-- Monte uma lista de contatos com NOME, EMAIL e uma coluna TIPO ('CLIENTE'
-- ou 'VENDEDOR') reunindo clientes e vendedores. Mantenha as repetições.
-- Ordene por nome e tipo.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- GABARITO:
SELECT P.NOME, P.EMAIL, 'CLIENTE' AS TIPO
FROM CLIENTE C
INNER JOIN PESSOA P ON P.CODIGO = C.CODIGO
UNION ALL
SELECT P.NOME, P.EMAIL, 'VENDEDOR' AS TIPO
FROM VENDEDOR V
INNER JOIN PESSOA P ON P.CODIGO = V.CODIGO
ORDER BY NOME, TIPO;

-- Resultado esperado:
-- +------------------+--------------------------+----------+
-- | NOME             | EMAIL                    | TIPO     |
-- +------------------+--------------------------+----------+
-- | Ana Souza        | ana.souza@email.com      | CLIENTE  |
-- | Bruno Lima       | bruno.lima@email.com     | CLIENTE  |
-- | Carla Mendes     | carla.mendes@email.com   | CLIENTE  |
-- | Diego Rocha      | diego.rocha@email.com    | CLIENTE  |
-- | Eduarda Alves    | eduarda.alves@email.com  | CLIENTE  |
-- | Eduarda Alves    | eduarda.alves@email.com  | VENDEDOR |
-- | Felipe Costa     | felipe.costa@email.com   | CLIENTE  |
-- | Gabriela Nunes   | gabriela.nunes@email.com | VENDEDOR |
-- | Henrique Prado   | henrique.prado@email.com | VENDEDOR |
-- | Isabela Torres   | isabela.torres@email.com | VENDEDOR |
-- | João Pedro Ramos | joao.ramos@email.com     | VENDEDOR |
-- | Lucas Ferreira   | lucas.ferreira@email.com | CLIENTE  |
-- +------------------+--------------------------+----------+
-- (12 linhas)
--
-- Comentários:
-- Eduarda Alves aparece DUAS vezes porque é cliente e vendedora: UNION ALL
-- não remove repetições (e é mais rápido que UNION por não precisar
-- verificar duplicatas). Pergunta para a turma: se tirássemos a coluna TIPO
-- e usássemos UNION, quantas linhas sobrariam? (Resposta: 11.)
