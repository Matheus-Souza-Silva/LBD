-- ==========================================================
-- GRANT E REVOKE
-- Controle de acesso ao banco de dados
-- Banco utilizado: supermercado
-- ==========================================================

-- ==========================================================
-- Criando usuários do sistema
--
-- Cada usuário terá uma função diferente:
--
-- Gerente:
-- acesso amplo ao banco
--
-- Vendedor:
-- pode consultar produtos e criar pedidos
--
-- Financeiro:
-- pode consultar valores, mas não alterar dados
--
-- Estoque:
-- pode atualizar estoque dos produtos
--
-- Auditor:
-- apenas consulta dados
-- ==========================================================

CREATE USER 'gerente'@'localhost'
IDENTIFIED BY '123';

CREATE USER 'vendedor'@'localhost'
IDENTIFIED BY '123';

CREATE USER 'financeiro'@'localhost'
IDENTIFIED BY '123';

CREATE USER 'estoque'@'localhost'
IDENTIFIED BY '123';

CREATE USER 'auditor'@'localhost'
IDENTIFIED BY '123';

-- ==========================================================
-- EXEMPLO 1
-- Dar acesso total ao banco
--
-- O usuário gerente terá todas as permissões
-- em todas as tabelas do banco supermercado
--
-- ALL PRIVILEGES:
-- SELECT
-- INSERT
-- UPDATE
-- DELETE
-- CREATE
-- DROP
-- ALTER
-- entre outras
-- ==========================================================

GRANT ALL PRIVILEGES
ON supermercado.*
TO 'gerente'@'localhost';

-- ==========================================================
-- EXEMPLO 2
-- Dar acesso somente de consulta ao banco inteiro
--
-- Auditor pode visualizar informações,
-- mas não pode alterar nada.
-- ==========================================================

GRANT SELECT
ON supermercado.*
TO 'auditor'@'localhost';

-- ==========================================================
-- EXEMPLO 3
-- Dar acesso somente a uma tabela
--
-- O vendedor pode consultar produtos,
-- mas não vê clientes, pedidos etc.
-- ==========================================================

GRANT SELECT
ON supermercado.PRODUTO
TO 'vendedor'@'localhost';

-- ==========================================================
-- EXEMPLO 4
-- Dar permissão de INSERT em uma tabela
--
-- Vendedor pode cadastrar pedidos,
-- mas não alterar pedidos existentes.
-- ==========================================================

GRANT INSERT
ON supermercado.PEDIDO
TO 'vendedor'@'localhost';

-- ==========================================================
-- EXEMPLO 5
-- Permitir somente atualização de estoque
--
-- O funcionário do estoque não pode alterar preço,
-- nome ou outras informações do produto.
--
-- UPDATE pode ser limitado a uma coluna.
-- ==========================================================

GRANT UPDATE (ESTOQUE)
ON supermercado.PRODUTO
TO 'estoque'@'localhost';

-- ==========================================================
-- EXEMPLO 6
-- Permissão para atualizar preço
--
-- O setor financeiro pode alterar apenas
-- o valor dos produtos.
-- ==========================================================

GRANT UPDATE (PRECO_BASE)
ON supermercado.PRODUTO
TO 'financeiro'@'localhost';

-- ==========================================================
-- EXEMPLO 7
-- Permissão de leitura apenas de algumas colunas
--
-- O financeiro pode consultar valores,
-- mas não precisa ver o estoque.
-- ==========================================================

GRANT SELECT (CODIGO, NOME, PRECO_BASE)
ON supermercado.PRODUTO
TO 'financeiro'@'localhost';

-- ==========================================================
-- Conferir permissões dos usuários
-- ==========================================================

SHOW GRANTS FOR 'gerente'@'localhost';

SHOW GRANTS FOR 'vendedor'@'localhost';

SHOW GRANTS FOR 'estoque'@'localhost';

-- ==========================================================
-- REVOKE
-- Removendo permissões
-- ==========================================================

-- ==========================================================
-- EXEMPLO 8
-- Remover uma permissão específica
--
-- Vendedor não poderá mais inserir pedidos,
-- mas continua podendo consultar produtos.
-- ==========================================================

REVOKE INSERT
ON supermercado.PEDIDO
FROM 'vendedor'@'localhost';

-- ==========================================================
-- EXEMPLO 9
-- Remover acesso a uma coluna específica
--
-- Financeiro deixa de alterar o preço.
-- ==========================================================

REVOKE UPDATE (PRECO_BASE)
ON supermercado.PRODUTO
FROM 'financeiro'@'localhost';

-- ==========================================================
-- EXEMPLO 10
-- Remover acesso de uma tabela inteira
--
-- Auditor perde acesso à tabela PRODUTO,
-- mas continua tendo acesso às outras tabelas.
-- ==========================================================

REVOKE SELECT
ON supermercado.PRODUTO
FROM 'auditor'@'localhost';

-- ==========================================================
-- EXEMPLO 11
-- Remover todas as permissões e privilégios extras
-- ==========================================================

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'vendedor'@'localhost';

-- ==========================================================
-- Verificando novamente as permissões
-- ==========================================================

SHOW GRANTS FOR 'auditor'@'localhost';

SHOW GRANTS FOR 'vendedor'@'localhost';

-- ==========================================================
-- Remover usuários (opcional)
-- ==========================================================

DROP USER 'gerente'@'localhost';
DROP USER 'vendedor'@'localhost';
DROP USER 'financeiro'@'localhost';
DROP USER 'estoque'@'localhost';
DROP USER 'auditor'@'localhost';