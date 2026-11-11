-- =====================================================================
-- LISTA DE EXERCÍCIOS — JOINS, UNION e UNION ALL  (versão do aluno)
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
-- Escreva sua consulta abaixo de cada enunciado.
-- =====================================================================

USE SUPERMERCADO;


-- =====================================================================
-- EXERCÍCIO 01 — INNER JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste o NOME, o CPF, a CIDADE e a UF de todos os clientes cadastrados,
-- em ordem alfabética de nome.
-- Tabelas: PESSOA, CLIENTE
--
-- Sua resposta:

SELECT PESSOA.NOME, CLIENTE.CPF, PESSOA.CIDADE, PESSOA.UF
FROM PESSOA
INNER JOIN CLIENTE
ON PESSOA.CODIGO = CLIENTE.CODIGO
ORDER BY PESSOA.NOME;

-- =====================================================================
-- EXERCÍCIO 02 — INNER JOIN — 3 tabelas (básico/intermediário)
-- =====================================================================
-- Mostre o código do pedido, a data, o NOME do cliente e o valor total
-- de todos os pedidos CONFIRMADOS, do mais antigo para o mais recente.
-- Tabelas: PEDIDO, CLIENTE, PESSOA
--
-- Sua resposta:

SELECT PEDIDO.CODIGO AS CODIGO_PEDIDO, PEDIDO.DATA_PEDIDO, CLIENTE.CODIGO AS CODIGO_CLIENTE, PESSOA.NOME, PEDIDO.VALOR_TOTAL
FROM PESSOA
INNER JOIN CLIENTE ON PESSOA.CODIGO = CLIENTE.CODIGO
LEFT JOIN PEDIDO ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
WHERE PEDIDO.CONFIRMADO = 1
ORDER BY PEDIDO.DATA_PEDIDO;

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
-- Sua resposta:

SELECT PEDIDO.CODIGO, PESSOA.NOME AS NOME_CLIENTE, LOGIN.USUARIO, PESSOA.NOME AS NOME_VENDEDOR, 
HISTORICO_SALARIO.SALARIO_NOVO, PRODUTO.NOME, ITEM_PEDIDO.QUANTIDADE, ITEM_PEDIDO.SUBTOTAL, IMAGEM.URL
FROM PESSOA
INNER JOIN LOGIN ON PESSOA.CODIGO = LOGIN.CODIGO
INNER JOIN CLIENTE ON PESSOA.CODIGO = CLIENTE.CODIGO
INNER JOIN VENDEDOR ON PESSOA.CODIGO = VENDEDOR.CODIGO
INNER JOIN HISTORICO_SALARIO ON VENDEDOR.CODIGO = HISTORICO_SALARIO.CODIGO_VENDEDOR
INNER JOIN PEDIDO ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
INNER JOIN ITEM_PEDIDO ON PEDIDO.CODIGO = ITEM_PEDIDO.CODIGO_PEDIDO
INNER JOIN PRODUTO ON ITEM_PEDIDO.CODIGO_PRODUTO = PRODUTO.CODIGO
INNER JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO
WHERE PEDIDO.CONFIRMADO = 1 AND IMAGEM.NUMERO_IMAGEM = 1 AND HISTORICO_SALARIO.DATA_HORA_ALTERACAO >= '2026-06-01'
ORDER BY PEDIDO.CODIGO, PRODUTO.NOME;

-- =====================================================================
-- EXERCÍCIO 04 — LEFT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Liste TODOS os produtos (código e nome) com os pedidos em que aparecem e
-- a quantidade vendida. Produtos que nunca foram vendidos também devem
-- aparecer na listagem.
-- Tabelas: PRODUTO, ITEM_PEDIDO
--
-- Sua resposta:

SELECT PRODUTO.CODIGO, PRODUTO.NOME, ITEM_PEDIDO.QUANTIDADE
FROM PRODUTO
LEFT JOIN ITEM_PEDIDO ON PRODUTO.CODIGO = ITEM_PEDIDO.CODIGO_PRODUTO;

-- =====================================================================
-- EXERCÍCIO 05 — LEFT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Para CADA cliente, mostre o nome, a quantidade de pedidos realizados e o
-- total gasto. Clientes que nunca fizeram pedido devem aparecer com 0.
-- Ordene pela quantidade de pedidos (maior primeiro) e depois pelo nome.
-- Tabelas: CLIENTE, PESSOA, PEDIDO
--
-- Sua resposta:

SELECT CLIENTE.CODIGO, PESSOA.NOME, PEDIDO.VALOR_TOTAL
FROM CLIENTE
LEFT JOIN PESSOA ON PESSOA.CODIGO = CLIENTE.CODIGO
LEFT JOIN PEDIDO ON PEDIDO.COD_CLIENTE = CLIENTE.CODIGO
ORDER BY PESSOA.NOME;

-- =====================================================================
-- EXERCÍCIO 06 — RIGHT JOIN — 2 tabelas (básico)
-- =====================================================================
-- Usando RIGHT JOIN, liste TODOS os produtos com suas imagens (número e URL).
-- Produtos sem imagem também devem aparecer.
-- Tabelas: IMAGEM, PRODUTO (nesta ordem no FROM)
--
-- Sua resposta:

SELECT PRODUTO.CODIGO, PRODUTO.NOME, IMAGEM.NUMERO_IMAGEM, IMAGEM.URL
FROM IMAGEM
RIGHT JOIN PRODUTO ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

-- =====================================================================
-- EXERCÍCIO 07 — RIGHT JOIN — 3 tabelas (intermediário)
-- =====================================================================
-- Usando RIGHT JOIN, mostre o nome de TODOS os vendedores, a faixa de
-- comissão, a quantidade de pedidos atendidos e o total vendido.
-- Vendedores sem nenhum pedido devem aparecer com 0.
-- Ordene pelo total vendido (maior primeiro).
-- Tabelas: PEDIDO, VENDEDOR, PESSOA (comece o FROM por PEDIDO)
--
-- Sua resposta:

SELECT PESSOA.NOME, VENDEDOR.FAIXA_COMISSAO, PEDIDO.VALOR_TOTAL
FROM PEDIDO
RIGHT JOIN VENDEDOR ON VENDEDOR.CODIGO = PEDIDO.COD_VENDEDOR
INNER JOIN PESSOA ON VENDEDOR.CODIGO = PESSOA.CODIGO
ORDER BY PEDIDO.VALOR_TOTAL;

-- =====================================================================
-- EXERCÍCIO 08 — SELF JOIN (básico)
-- =====================================================================
-- Liste os pares de pessoas que moram na MESMA cidade, mostrando o nome das
-- duas pessoas e a cidade. Cada par deve aparecer uma única vez e uma pessoa
-- não pode formar par com ela mesma.
-- Tabela: PESSOA (unida com ela mesma)
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 09 — UNION (básico)
-- =====================================================================
-- Liste, sem repetição, todas as cidades (e UF) onde existem clientes
-- OU vendedores.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- Sua resposta:




-- =====================================================================
-- EXERCÍCIO 10 — UNION ALL (básico)
-- =====================================================================
-- Monte uma lista de contatos com NOME, EMAIL e uma coluna TIPO ('CLIENTE'
-- ou 'VENDEDOR') reunindo clientes e vendedores. Mantenha as repetições.
-- Ordene por nome e tipo.
-- Tabelas: CLIENTE, VENDEDOR, PESSOA
--
-- Sua resposta:



