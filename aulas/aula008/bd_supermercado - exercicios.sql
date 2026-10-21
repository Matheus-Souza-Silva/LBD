-- =========================================
-- LISTA DE EXERCÍCIOS — BANCO SUPERMERCADO
-- =========================================

-- =====================
-- PARTE 1 — SELECT
-- =====================

-- 1. Liste todos os dados da tabela PESSOA.

SELECT * -- SELECIONA COLUNAS
FROM PESSOA; -- SELECIONA TABELAS

-- 2. Liste apenas o nome e o email das pessoas.

SELECT NOME, EMAIL
FROM PESSOA;

-- 3. Liste todos os produtos cadastrados.

SELECT *
FROM PRODUTO;

-- =====================
-- PARTE 2 — DISTINCT
-- =====================

-- 4. Liste todas as cidades cadastradas, sem repetição.

SELECT DISTINCT CIDADE
FROM PESSOA;

-- 5. Liste os estados (UF) onde há pessoas cadastradas, sem duplicidade.

SELECT DISTINCT UF
FROM PESSOA;

-- =====================
-- PARTE 3 — LIMIT
-- =====================

-- 6. Liste os 5 primeiros registros da tabela PESSOA.

SELECT *
FROM PESSOA
LIMIT 5;

-- 7. Liste os 3 produtos mais baratos.

-- 8. Liste os 5 produtos mais caros.


-- =====================
-- PARTE 4 — WHERE
-- =====================

-- 9. Liste todas as pessoas que moram em Brasília.

SELECT *
FROM PESSOA
WHERE CIDADE = 'Brasília';

-- 10. Liste os produtos com preço maior que 10.

SELECT *
FROM PRODUTO
WHERE PRECO_BASE > 10;

-- 11. Liste os pedidos que ainda NÃO foram confirmados.

SELECT *
FROM PEDIDO
WHERE CONFIRMADO = 0;

-- =====================
-- PARTE 5 — OPERADORES LÓGICOS
-- =====================

-- 12. Liste pessoas que moram em São Paulo E possuem CEP cadastrado.

SELECT *
FROM PESSOA
WHERE CIDADE = 'Salvador' AND CEP IS NOT NULL;

SELECT *
FROM PESSOA
WHERE CIDADE = 'Salvador' AND CEP IS NULL;

SELECT *
FROM PESSOA
WHERE CIDADE = 'Salvador' OR CEP IS NOT NULL;

-- 13. Liste produtos com preço menor que 3 OU estoque maior que 200.

SELECT *
FROM PRODUTO
WHERE PRECO_BASE < 3 OR ESTOQUE > 200;

SELECT *
FROM PRODUTO
WHERE PRECO_BASE < 3 OR ESTOQUE >= 200;

-- =====================
-- PARTE 6 — IN
-- =====================

-- 14. Liste pessoas que moram em Brasília, Goiânia ou Curitiba.

SELECT *
FROM PESSOA
WHERE CIDADE = 'Brasília' OR CIDADE = 'Goiânia' OR CIDADE = 'Curitiba';

SELECT *
FROM PESSOA
WHERE CIDADE IN ('Brasília', 'Goiânia', 'Curitiba');

SELECT *
FROM PESSOA
WHERE CIDADE NOT IN ('Brasília', 'Goiânia', 'Curitiba');

-- =====================
-- PARTE 7 — BETWEEN
-- =====================

-- 15. Liste produtos com preço entre 5 e 20.

SELECT *
FROM PRODUTO
WHERE PRECO_BASE > 5 AND PRECO_BASE < 20;

SELECT *
FROM PRODUTO
WHERE PRECO_BASE >= 5 AND PRECO_BASE <= 20; -- IGUAL O BETWEEN

SELECT *
FROM PRODUTO
WHERE PRECO_BASE BETWEEN 5 AND 20;

SELECT *
FROM PRODUTO
WHERE NOME BETWEEN 'biscoito' AND 'leite';

SELECT *
FROM CLIENTE
WHERE DATA_CADASTRO BETWEEN '2026-09-30 09:13:36' AND '2026-09-31 09:13:36';

-- =====================
-- PARTE 8 — LIKE (BÁSICO + AVANÇADO)
-- =====================

-- 16. Liste pessoas cujo nome começa com 'A'.

SELECT NOME
FROM PESSOA
WHERE NOME LIKE 'A%';

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '[A-F]%';

-- 17. Liste pessoas cujo nome contém 'a'.

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '%A%';

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '%N%';

SELECT NOME
FROM PESSOA
WHERE NOME NOT LIKE '%N%';

-- 18. Liste emails que terminam com 'email.com'.

SELECT EMAIL
FROM PESSOA
WHERE EMAIL LIKE '%email.com';

-- 19. Liste pessoas cujo nome tenha exatamente 5 letras.

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '_____';

-- 20. Liste pessoas cujo nome tenha 'a' como segunda letra.

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '_a%';

-- 21. Liste pessoas cujo nome termina com 'a'.

SELECT NOME
FROM PESSOA
WHERE NOME LIKE '%a';

-- 22. Liste pessoas cujo nome NÃO começa com 'A'.

SELECT NOME
FROM PESSOA
WHERE NOME NOT LIKE 'A%';

-- =====================
-- PARTE 9 — NULL / NOT
-- =====================

-- 23. Liste pessoas que NÃO possuem CEP cadastrado.

SELECT *
FROM PESSOA
WHERE CEP IS NULL;

-- 24. Liste pedidos que ainda não possuem valor total.

SELECT *
FROM PEDIDO
WHERE VALOR_TOTAL IS NULL;

-- 25. Liste produtos que NÃO possuem descrição.

SELECT *
FROM PRODUTO
WHERE DESCRICAO IS NULL;

-- =====================
-- PARTE 10 — ORDER BY
-- =====================

-- 26. Liste os produtos ordenados por preço crescente.

SELECT PRECO_BASE
FROM PRODUTO
ORDER BY PRECO_BASE; -- SEMPRE A ÚLITMA ETAPA DO QUERY

SELECT PRECO_BASE
FROM PRODUTO
ORDER BY PRECO_BASE ASC; -- MESMA COISA QUE O SEM CLAUSE (ASCENDENTE)

SELECT *
FROM PRODUTO
ORDER BY PRECO_BASE, ESTOQUE;

SELECT *
FROM PRODUTO
ORDER BY PRECO_BASE, ESTOQUE DESC;

SELECT *
FROM PRODUTO
WHERE PRECO_BASE = 25
ORDER BY PRECO_BASE, ESTOQUE DESC;

-- 27. Liste as pessoas ordenadas por nome em ordem decrescente.

SELECT NOME
FROM PESSOA
ORDER BY NOME DESC;

-- =====================
-- PARTE 11 — INNER JOIN
-- =====================

SELECT CLIENTE.CPF AS CPF_CLIENTE, PESSOA.EMAIL AS EMAIL_PESSOA
FROM CLIENTE
INNER JOIN PESSOA
ON CLIENTE.CODIGO = PESSOA.CODIGO;

SELECT *
FROM PRODUTO
INNER JOIN IMAGEM
ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

SELECT *
FROM VENDEDOR
INNER JOIN PESSOA
ON PESSOA.CODIGO = VENDEDOR.CODIGO;

SELECT PESSOA.CODIGO, PESSOA.NOME, PESSOA.EMAIL, LOGIN.USUARIO, LOGIN.ULTIMO_ACESSO
FROM PESSOA
INNER JOIN LOGIN
ON PESSOA.CODIGO = LOGIN.CODIGO;

-- SQL que retorne: Nome, Email, CPF de todos os clientes, que residam em GO e DF, e o resultado, em ordem alfabetica de nome

SELECT PESSOA.NOME, PESSOA.EMAIL, CLIENTE.CPF
FROM PESSOA
INNER JOIN CLIENTE
ON PESSOA.CODIGO = CLIENTE.CODIGO
WHERE PESSOA.UF IN ('GO', 'DF')
ORDER BY PESSOA.NOME;

SELECT CLIENTE.CPF, PEDIDO.DATA_PEDIDO, PEDIDO.CONFIRMADO, PEDIDO.VALOR_TOTAL
FROM CLIENTE
INNER JOIN PEDIDO
ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
WHERE VALOR_TOTAL > 50
ORDER BY VALOR_TOTAL DESC;

SELECT CLIENTE.CPF, PEDIDO.DATA_PEDIDO, PEDIDO.CONFIRMADO, PEDIDO.VALOR_TOTAL
FROM CLIENTE
INNER JOIN PEDIDO
ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
WHERE CLIENTE.CPF = '111' AND CONFIRMADO = 1
ORDER BY VALOR_TOTAL DESC;

SELECT VENDEDOR.CNPJ, PEDIDO.DATA_PEDIDO, PEDIDO.CONFIRMADO, PEDIDO.VALOR_TOTAL
FROM VENDEDOR
INNER JOIN PEDIDO
ON VENDEDOR.CODIGO = PEDIDO.COD_VENDEDOR
WHERE VENDEDOR.CODIGO = 9 AND PEDIDO.VALOR_TOTAL > 50
ORDER BY PEDIDO.DATA_PEDIDO;

SELECT PESSOA.NOME, CLIENTE.CPF AS CLIENTE, VENDEDOR.CNPJ AS VENDEDOR, PEDIDO.DATA_PEDIDO, PEDIDO.CONFIRMADO
FROM PEDIDO
INNER JOIN CLIENTE ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
INNER JOIN VENDEDOR ON VENDEDOR.CODIGO = PEDIDO.COD_VENDEDOR
INNER JOIN PESSOA ON PESSOA.CODIGO = CLIENTE.CODIGO;

-- 28. Liste o nome do cliente e a data dos pedidos.

SELECT PESSOA.NOME, PEDIDO.DATA_PEDIDO
FROM CLIENTE
INNER JOIN PESSOA
ON CLIENTE.CODIGO = PESSOA.CODIGO
INNER JOIN PEDIDO
ON PEDIDO.COD_CLIENTE = CLIENTE.CODIGO;

-- 29. Liste o nome do vendedor e o valor dos pedidos realizados por ele.

SELECT PESSOA.NOME, PEDIDO.VALOR_TOTAL
FROM PESSOA
INNER JOIN VENDEDOR
ON VENDEDOR.CODIGO = PESSOA.CODIGO
INNER JOIN PEDIDO
ON PEDIDO.COD_VENDEDOR = VENDEDOR.CODIGO;

-- =====================
-- PARTE 12 — LEFT JOIN
-- =====================

SELECT PESSOA.CODIGO, PESSOA.NOME, LOGIN.CODIGO, LOGIN.NOME
FROM PESSOA
LEFT JOIN LOGIN ON PESSOA.CODIGO = LOGIN.CODIGO
WHERE PESSOA.NOME LIKE 'E%'
ORDER BY PESSSOA.NOME;

-- Diferença entre Inner Join e Left Join

SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM PRODUTO
INNER JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM PRODUTO
LEFT JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

-- Invertendo a ordem das tabelas

SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM IMAGEM
LEFT OUTER JOIN PRODUTO ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO; -- O left outer join funciona igual a left join

SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM PRODUTO
RIGHT JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

-- Juntando as duas tabelas

SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM PRODUTO
LEFT JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO
UNION
SELECT PRODUTO.CODIGO AS COD_PRODUTO, IMAGEM.CODIGO_PRODUTO AS COD_IMAGEM, PRODUTO.NOME AS NOME_PRODUTO, IMAGEM.URL
FROM PRODUTO
RIGHT JOIN IMAGEM ON PRODUTO.CODIGO = IMAGEM.CODIGO_PRODUTO;

-- 30. Liste todas as pessoas e seus respectivos logins (se tiverem).

SELECT PESSOA.CODIGO, PESSOA.NOME, LOGIN.USUARIO
FROM PESSOA
LEFT JOIN LOGIN
ON PESSOA.CODIGO = LOGIN.CODIGO;

-- 31. Liste todos os clientes e seus pedidos, incluindo clientes sem pedidos.

SELECT CLIENTE.CODIGO AS CODIGO_CLIENTE, PESSOA.NOME, PEDIDO.CODIGO AS CODIGO_PEDIDO
FROM PESSOA
INNER JOIN CLIENTE
ON PESSOA.CODIGO = CLIENTE.CODIGO
LEFT JOIN PEDIDO
ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE;

-- 32. Liste as pessoas que NÃO possuem login.

SELECT PESSOA.CODIGO, PESSOA.NOME, LOGIN.USUARIO
FROM PESSOA
LEFT JOIN LOGIN
ON PESSOA.CODIGO = LOGIN.CODIGO
WHERE LOGIN.CODIGO IS NULL;

-- 33. Liste os clientes que ainda NÃO fizeram pedidos.

SELECT CLIENTE.CODIGO AS CODIGO_CLIENTE, PESSOA.NOME, PEDIDO.CODIGO AS CODIGO_PEDIDO
FROM PESSOA
INNER JOIN CLIENTE
ON PESSOA.CODIGO = CLIENTE.CODIGO
LEFT JOIN PEDIDO
ON CLIENTE.CODIGO = PEDIDO.COD_CLIENTE
WHERE PEDIDO.CONFIRMADO = 0;

-- Union que junta as colunas em uma só

SELECT CLIENTE.CODIGO, CLIENTE.CPF FROM CLIENTE
UNION
SELECT VENDEDOR.CODIGO, VENDEDOR.CNPJ FROM VENDEDOR
ORDER BY CODIGO;

SELECT CLIENTE.CODIGO, CLIENTE.CPF FROM CLIENTE
UNION ALL
SELECT VENDEDOR.CODIGO, VENDEDOR.CNPJ FROM VENDEDOR
ORDER BY CODIGO;

-- =====================
-- PARTE 13 — MULTI JOIN
-- =====================

-- 34. Liste: nome do cliente, nome do produto e quantidade comprada.

-- 35. Liste: nome do cliente, data do pedido e quantidade total de itens no pedido.

-- 36. Liste: nome do vendedor, nome do cliente e valor do pedido.

-- 37. Liste: nome do produto, quantidade vendida e nome do cliente.

-- =====================
-- ESPECIALIZAÇÃO (HERANÇA)
-- =====================

-- 56. Liste todas as pessoas indicando se são clientes (Dica: usar LEFT JOIN).

-- 57. Liste todas as pessoas indicando se são vendedores.

-- 58. Liste as pessoas que são clientes E vendedores ao mesmo tempo.

-- 59. Liste as pessoas que NÃO são nem clientes nem vendedores.


-- =====================
-- PARTE 14 — FUNÇÕES (CÁLCULO)
-- =====================

SELECT MIN(PRECO_BASE) AS MENOR_VALOR, MAX(ESTOQUE) AS MAIOR_ESTOQUE
FROM PRODUTO;

SELECT SUM(PRECO_BASE) AS SOMA_PRECO
FROM PRODUTO;

SELECT AVG(PRECO_BASE) AS MEDIA_PRECO
FROM PRODUTO;

SELECT COUNT(*) AS NUM_PESSOAS
FROM PESSOA;

SELECT PRECO_BASE, PRECO_BASE * 1.1 AS PRECO_CORRIGIDO
FROM PRODUTO;

-- =====================
-- PARTE 15 — FUNÇÕES PRONTAS
-- =====================

-- 41. Liste o nome das pessoas em letras maiúsculas e o email em letras minúsculas.

-- 42. Liste os pedidos mostrando: código, data formatada (DD/MM/AAAA) e ano do pedido.


-- =====================
-- PARTE 16 — GROUP BY
-- =====================

SELECT UF, COUNT(CODIGO) AS QUANTIDADE
FROM PESSOA
WHERE UF IN ('GO', 'DF', 'PR')
GROUP BY UF
ORDER BY UF;

-- 43. Conte quantas pessoas existem por cidade.

SELECT CIDADE, COUNT(CODIGO) AS PESSOAS
FROM PESSOA
GROUP BY CIDADE
ORDER BY COUNT(CODIGO);

-- 44. Calcule o total de estoque de produtos.

SELECT NOME, SUM(ESTOQUE)
FROM PRODUTO
GROUP BY NOME;

-- 45. Calcule a quantidade total de itens por pedido.

SELECT CODIGO_PEDIDO, SUM(QUANTIDADE)
FROM ITEM_PEDIDO
GROUP BY CODIGO_PEDIDO;

-- 46. Conte quantos pedidos cada cliente realizou.

SELECT COD_CLIENTE AS PEDIDO, COUNT(COD_CLIENTE)
FROM PEDIDO
GROUP BY COD_CLIENTE;

-- 47. Calcule o valor total vendido por vendedor.

SELECT PEDIDO.COD_VENDEDOR, PESSOA.NOME, SUM(PEDIDO.VALOR_TOTAL)
FROM PEDIDO
INNER JOIN PESSOA ON PESSOA.CODIGO = PEDIDO.COD_VENDEDOR
GROUP BY PEDIDO.COD_VENDEDOR
HAVING SUM(PEDIDO.VALOR_TOTAL) > 50
ORDER BY SUM(PEDIDO.VALOR_TOTAL) DESC;

-- =====================
-- PARTE 17 — HAVING
-- =====================

-- 48. Liste clientes que fizeram mais de 1 pedido.

-- 49. Liste vendedores cujo total de vendas ultrapassa 100.

-- 50. Liste pedidos que possuem mais de 1 item.


-- =====================
-- PARTE 18 — CONSULTAS COMPLETAS
-- =====================

-- 51. Liste os produtos mais vendidos (somando quantidades).

-- 52. Liste pedidos com seus clientes, vendedores e valor total.

-- 53. Liste clientes que nunca fizeram pedidos.


-- =====================
-- DESAFIO
-- =====================

-- 54. Para cada cliente, mostrar: nome, quantidade de pedidos e valor total gasto.

-- 55. Liste os 3 produtos mais vendidos.