-- ==========================================================
-- COMMIT E ROLLBACK
-- Controle de transações no banco de dados
--
-- COMMIT:
-- confirma definitivamente as alterações
--
-- ROLLBACK:
-- desfaz alterações ainda não confirmadas
--
-- SAVEPOINT:
-- cria um ponto intermediário dentro da transação
-- ==========================================================

-- ==========================================================
-- Exemplo 1
-- Inserindo um novo produto e confirmando a alteração
--
-- Situação:
-- Cadastro de um produto novo no supermercado
-- ==========================================================

START TRANSACTION;

-- Insere um novo produto temporariamente
INSERT INTO PRODUTO(NOME, ESTOQUE, PRECO_BASE)
VALUES('Chocolate Premium', 50, 15.90);

-- Visualiza o produto antes da confirmação
SELECT *
FROM PRODUTO
WHERE NOME = 'Chocolate Premium';

-- COMMIT confirma a operação
-- Após o COMMIT o INSERT não poderá ser desfeito
COMMIT;

-- ==========================================================
-- Exemplo 2
-- Inserção com erro e cancelamento da operação
--
-- Situação:
-- Funcionário tentou cadastrar produto
-- mas percebeu que os dados estavam errados
-- ==========================================================

START TRANSACTION;

INSERT INTO PRODUTO(NOME, ESTOQUE, PRECO_BASE)
VALUES('Produto Incorreto', 100, 999);

-- Consulta para verificar o registro temporário
SELECT *
FROM PRODUTO
WHERE NOME = 'Produto Incorreto';

-- ROLLBACK desfaz tudo desde o START TRANSACTION
-- O produto não será gravado
ROLLBACK;

-- Conferência:
-- o produto não deve existir
SELECT *
FROM PRODUTO
WHERE NOME = 'Produto Incorreto';

-- ==========================================================
-- Exemplo 3
-- Atualização de dados com possibilidade de cancelamento
--
-- Situação:
-- Alteração de preço de vários produtos
-- ==========================================================

START TRANSACTION;

UPDATE PRODUTO
SET PRECO_BASE = PRECO_BASE * 1.10;

-- Conferir alteração antes de confirmar
SELECT
NOME,
PRECO_BASE
FROM PRODUTO;

-- Caso esteja correto:
COMMIT;

-- Caso o reajuste esteja errado:
-- ROLLBACK;

-- ==========================================================
-- Exemplo 4
-- Venda de produto utilizando transação
--
-- Operação:
-- 1 - cria pedido
-- 2 - baixa estoque
--
-- As duas operações devem acontecer juntas
-- ==========================================================

START TRANSACTION;

-- Criando pedido
INSERT INTO PEDIDO (COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, VALOR_TOTAL)
VALUES (1, 1, NOW(), 200);

-- Reduzindo estoque do produto

UPDATE PRODUTO
SET ESTOQUE = ESTOQUE - 2
WHERE CODIGO = 1;

-- Se ambas operações estiverem corretas:
COMMIT;

-- Se uma delas der erro:
-- ROLLBACK;

-- ==========================================================
-- Exemplo 5
-- Usando SAVEPOINT
--
-- Permite desfazer apenas uma parte da transação
-- ==========================================================

START TRANSACTION;

-- Primeira alteração
UPDATE PRODUTO
SET PRECO_BASE = 20
WHERE CODIGO = 1;

-- Criando um ponto de retorno
SAVEPOINT ajuste_preco;

-- Segunda alteração
UPDATE PRODUTO
SET ESTOQUE = ESTOQUE - 5
WHERE CODIGO = 1;

-- Caso a alteração de estoque esteja errada,
-- volta apenas até o SAVEPOINT
ROLLBACK TO ajuste_preco;

-- O ajuste de preço continua mantido
-- A alteração de estoque foi desfeita

COMMIT;

-- ==========================================================
-- Exemplo 6
-- Cancelamento completo de uma operação
--
-- Simulando cancelamento de pedido
-- ==========================================================

START TRANSACTION;

DELETE FROM ITEM_PEDIDO
WHERE COD_PEDIDO = 1;

DELETE FROM PEDIDO
WHERE CODIGO = 1;

-- Usuário percebeu que apagou o pedido errado

ROLLBACK;

-- O pedido volta a existir

-- ==========================================================
-- Observação para aula:
--
-- START TRANSACTION inicia uma transação
--
-- COMMIT salva definitivamente
--
-- ROLLBACK desfaz alterações não confirmadas
--
-- SAVEPOINT permite desfazer parcialmente
--
-- Transações garantem:
--
-- Atomicidade:
-- tudo acontece ou nada acontece
--
-- Consistência:
-- banco permanece válido
-- ==========================================================