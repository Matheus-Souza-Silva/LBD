-- ==========================================================
-- TRIGGERS - BANCO DE DADOS SUPERMERCADO
-- ----------------------------------------------------------
-- Pré-requisito: executar antes o script de criação do banco
-- (bd_supermercado.sql).
--
-- Estrutura de cada exemplo:
--   1) Comentário explicando a regra e o tipo da trigger
--   2) Criação da trigger
--   3) Comando que faz a trigger ser executada (teste)
--   4) SELECT para conferir o resultado
-- ==========================================================

USE SUPERMERCADO;

-- ==========================================================
-- DADOS DE APOIO PARA OS TESTES
-- ----------------------------------------------------------
-- O banco foi criado vazio. Para testar as triggers,
-- precisamos de pelo menos 1 vendedor e 1 cliente.
--
-- Lembrando: VENDEDOR e CLIENTE são especializações de
-- PESSOA, então primeiro inserimos em PESSOA e depois
-- usamos o mesmo CODIGO nas tabelas filhas.
-- ==========================================================

INSERT INTO PESSOA (NOME, LOGRADOURO, CIDADE, UF, CEP, EMAIL, TELEFONE)
VALUES ('Carlos Vendedor', 'Rua A, 10', 'Brasília', 'DF', '70000-000',
        'carlos@email.com', '(61)99999-0001');   -- CODIGO = 1

INSERT INTO PESSOA (NOME, LOGRADOURO, CIDADE, UF, CEP, EMAIL, TELEFONE)
VALUES ('Ana Cliente', 'Rua B, 20', 'Taguatinga', 'DF', '72000-000',
        'ana@email.com', '(61)99999-0002');      -- CODIGO = 2

INSERT INTO VENDEDOR (CODIGO, CNPJ, SALARIO, FAIXA_COMISSAO)
VALUES (1, '21.576.351/1491-90', 3000.00, 'B');

INSERT INTO CLIENTE (CODIGO, CPF)
VALUES (2, '123.456.789-00');

-- ==========================================================
-- TRIGGER 1
-- Regra:
-- Sempre que o salário de um vendedor for alterado,
-- registrar o salário anterior e o novo salário
-- na tabela HISTORICO_SALARIO.
--
-- Tipo:
-- AFTER UPDATE
--
-- Observação:
-- A tabela HISTORICO_SALARIO também guarda o NOME do
-- vendedor. Como o nome não está na tabela VENDEDOR
-- (ele fica em PESSOA), buscamos o nome com um SELECT
-- dentro da trigger.
-- ==========================================================

DROP TRIGGER IF EXISTS tg_historico_salario;

DELIMITER //

CREATE TRIGGER tg_historico_salario

-- AFTER significa que a trigger será executada
-- depois que o comando UPDATE terminar com sucesso
AFTER UPDATE ON VENDEDOR

-- FOR EACH ROW significa que a trigger será executada
-- para cada registro alterado
FOR EACH ROW

BEGIN
    -- OLD representa os valores antigos antes do UPDATE
    -- NEW representa os valores novos depois do UPDATE
    --
    -- Verificamos se o salário realmente mudou
    -- (se o UPDATE alterou só a faixa de comissão,
    -- por exemplo, nada é registrado)
    IF OLD.SALARIO <> NEW.SALARIO THEN

        -- Inserimos o registro do histórico
        INSERT INTO HISTORICO_SALARIO
        (
            CODIGO_VENDEDOR,
            NOME_VENDEDOR,
            SALARIO_ANTIGO,
            SALARIO_NOVO,
            DATA_HORA_ALTERACAO
        )
        VALUES
        (
            -- NEW.CODIGO pega o código do vendedor alterado
            NEW.CODIGO,

            -- Busca o nome do vendedor na tabela PESSOA
            (SELECT NOME FROM PESSOA WHERE CODIGO = NEW.CODIGO),

            -- OLD.SALARIO guarda o salário antes da alteração
            OLD.SALARIO,

            -- NEW.SALARIO guarda o salário depois da alteração
            NEW.SALARIO,

            -- Registra o momento da alteração
            NOW()
        );

    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger:
-- um UPDATE no salário do vendedor
-- ----------------------------------------------------------

UPDATE VENDEDOR
SET SALARIO = 3500.00
WHERE CODIGO = 1;

-- Conferindo o resultado
SELECT * FROM HISTORICO_SALARIO;

-- ==========================================================
-- TRIGGER 2
-- Regra:
-- Registrar no LOG_SISTEMA sempre que um pedido novo
-- for inserido.
--
-- Tipo:
-- AFTER INSERT
-- ==========================================================

-- A tabela LOG_SISTEMA não existe no banco original,
-- então criamos ela aqui (somente se ainda não existir)

CREATE TABLE IF NOT EXISTS LOG_SISTEMA
(
    CODIGO INT AUTO_INCREMENT PRIMARY KEY,
    TABELA VARCHAR(50),
    OPERACAO VARCHAR(20),
    DATA_EVENTO DATETIME,
    DESCRICAO VARCHAR(200)
);

DROP TRIGGER IF EXISTS tg_log_novo_pedido;

DELIMITER //

CREATE TRIGGER tg_log_novo_pedido

-- AFTER INSERT executa depois que um novo registro
-- for inserido na tabela PEDIDO
AFTER INSERT ON PEDIDO

-- Executa uma vez para cada pedido inserido
FOR EACH ROW

BEGIN
    -- Cria um registro de auditoria no sistema
    INSERT INTO LOG_SISTEMA (TABELA, OPERACAO, DATA_EVENTO, DESCRICAO)
    VALUES
    (
        'PEDIDO',
        'INSERT',
        NOW(),

        -- NEW.CODIGO representa o código do pedido criado
        -- (no AFTER INSERT o AUTO_INCREMENT já foi gerado)
        CONCAT('Novo pedido criado: ', NEW.CODIGO,
               ' | Cliente: ', NEW.COD_CLIENTE,
               ' | Vendedor: ', NEW.COD_VENDEDOR)
    );
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger:
-- um INSERT na tabela PEDIDO
--
-- Atenção: no nosso banco DATA_PEDIDO e CONFIRMADO são
-- NOT NULL, por isso precisam ser informados no INSERT.
-- ----------------------------------------------------------

INSERT INTO PEDIDO (COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, CONFIRMADO, VALOR_TOTAL)
VALUES (2, 1, NOW(), TRUE, 100.00);

-- Conferindo o resultado
SELECT * FROM PEDIDO;
SELECT * FROM LOG_SISTEMA;

-- ==========================================================
-- TRIGGER 3
-- Regra:
-- Não permitir cadastro de produto com estoque negativo.
-- Se vier um valor negativo, ele é trocado por 0.
--
-- Tipo:
-- BEFORE INSERT
-- ==========================================================

DROP TRIGGER IF EXISTS tg_validar_estoque;

DELIMITER //

CREATE TRIGGER tg_validar_estoque

-- BEFORE executa antes da gravação no banco,
-- permitindo alterar ou validar valores
BEFORE INSERT ON PRODUTO

-- Executa para cada produto inserido
FOR EACH ROW

BEGIN
    -- NEW representa o registro que está tentando ser inserido
    IF NEW.ESTOQUE < 0 THEN

        -- Altera o valor antes da gravação
        SET NEW.ESTOQUE = 0;

    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger:
-- um INSERT em PRODUTO com estoque negativo
-- ----------------------------------------------------------

INSERT INTO PRODUTO (NOME, DESCRICAO, PRECO_BASE, ESTOQUE)
VALUES ('Arroz 5kg', 'Arroz tipo 1', 25.90, -10);

-- Conferindo o resultado:
-- o estoque deve aparecer como 0, e não -10
SELECT * FROM PRODUTO;

-- ==========================================================
-- TRIGGER 4
-- Regra:
-- Um pedido sem valor não pode ficar confirmado.
-- Se VALOR_TOTAL for nulo ou menor/igual a zero,
-- o pedido é gravado com CONFIRMADO = FALSE.
--
-- Tipo:
-- BEFORE INSERT
-- ==========================================================

DROP TRIGGER IF EXISTS tg_validar_pedido;

DELIMITER //

CREATE TRIGGER tg_validar_pedido

-- Executa antes da inserção do pedido
BEFORE INSERT ON PEDIDO

-- Executa para cada novo pedido
FOR EACH ROW

BEGIN
    -- Verifica os dados que estão chegando
    IF NEW.VALOR_TOTAL IS NULL OR NEW.VALOR_TOTAL <= 0 THEN

        -- Modifica o valor antes de salvar
        -- NEW permite alterar dados que ainda serão inseridos
        SET NEW.CONFIRMADO = FALSE;

    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger:
-- um INSERT de pedido SEM valor tentando ficar confirmado
--
-- Observação para a aula: este INSERT também dispara a
-- TRIGGER 2 (AFTER INSERT ON PEDIDO). Ou seja, uma mesma
-- tabela pode ter uma trigger BEFORE e outra AFTER para o
-- mesmo evento.
-- ----------------------------------------------------------

INSERT INTO PEDIDO (COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, CONFIRMADO, VALOR_TOTAL)
VALUES (2, 1, NOW(), TRUE, NULL);

-- Conferindo o resultado:
-- o novo pedido deve aparecer com CONFIRMADO = 0
SELECT * FROM PEDIDO;
SELECT * FROM LOG_SISTEMA;

-- ==========================================================
-- PRODUTOS DE APOIO PARA AS PRÓXIMAS TRIGGERS
-- ----------------------------------------------------------
-- As triggers 5 e 6 trabalham com ITEM_PEDIDO e estoque,
-- então precisamos de produtos com estoque disponível.
-- ==========================================================

INSERT INTO PRODUTO (NOME, DESCRICAO, PRECO_BASE, ESTOQUE)
VALUES ('Feijão 1kg', 'Feijão carioca', 8.50, 50);   -- CODIGO = 2

INSERT INTO PRODUTO (NOME, DESCRICAO, PRECO_BASE, ESTOQUE)
VALUES ('Café 500g', 'Café torrado e moído', 15.90, 30);   -- CODIGO = 3

-- ==========================================================
-- TRIGGER 5
-- Regra:
-- Não permitir vender um produto com quantidade maior
-- que o estoque disponível. Além disso, calcular
-- automaticamente o SUBTOTAL do item.
--
-- Tipo:
-- BEFORE INSERT
--
-- Conceito novo: SIGNAL
-- As triggers 3 e 4 CORRIGIAM o dado e deixavam gravar.
-- Aqui a trigger RECUSA a operação: o SIGNAL gera um erro,
-- o INSERT é cancelado e nada é gravado.
-- SQLSTATE '45000' é o código usado para erros definidos
-- pelo próprio programador.
-- ==========================================================

DROP TRIGGER IF EXISTS tg_validar_item_pedido;

DELIMITER //

CREATE TRIGGER tg_validar_item_pedido

-- BEFORE: a validação precisa acontecer antes de gravar
BEFORE INSERT ON ITEM_PEDIDO

FOR EACH ROW

BEGIN
    -- DECLARE cria variáveis locais dentro da trigger
    -- (sempre no início do bloco BEGIN)
    DECLARE v_estoque INT;
    DECLARE v_mensagem VARCHAR(200);

    -- Busca o estoque atual do produto que está sendo vendido
    -- e guarda na variável v_estoque
    SELECT ESTOQUE INTO v_estoque
    FROM PRODUTO
    WHERE CODIGO = NEW.CODIGO_PRODUTO;

    -- Se a quantidade pedida for maior que o estoque,
    -- a operação é bloqueada
    IF NEW.QUANTIDADE > v_estoque THEN

        SET v_mensagem = CONCAT('Estoque insuficiente. Disponível: ',
                                v_estoque,
                                ' | Solicitado: ', NEW.QUANTIDADE);

        -- Gera o erro e cancela o INSERT
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_mensagem;

    END IF;

    -- Se passou pela validação, calcula o subtotal
    -- antes de gravar (o usuário não precisa informar)
    SET NEW.SUBTOTAL = NEW.QUANTIDADE * NEW.PRECO_UNITARIO;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger (caso válido):
-- inserir um item com quantidade dentro do estoque.
-- Repare que o SUBTOTAL não foi informado no INSERT.
-- ----------------------------------------------------------

INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (1, 2, 2, 8.50);

-- Conferindo o resultado:
-- o SUBTOTAL deve aparecer como 17.00
-- (o estoque do Feijão ainda NÃO muda: isso será
-- responsabilidade da TRIGGER 6)
SELECT * FROM ITEM_PEDIDO;

-- ----------------------------------------------------------
-- Comando que dispara a trigger (caso bloqueado):
-- o Café tem 30 unidades e estamos pedindo 100.
--
-- ATENÇÃO: este comando VAI GERAR ERRO de propósito.
-- Ele está comentado para não interromper a execução do
-- script. Remova o "-- " e execute somente ele.
-- ----------------------------------------------------------

-- INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
-- VALUES (1, 3, 100, 15.90);

-- Resultado esperado:
-- Error Code: 1644. Estoque insuficiente. Disponível: 30 | Solicitado: 100

-- ==========================================================
-- TRIGGER 6
-- Regra:
-- Ao inserir um item no pedido:
--   a) dar baixa no estoque do produto;
--   b) somar o subtotal do item no VALOR_TOTAL do pedido.
--
-- Tipo:
-- AFTER INSERT
--
-- Conceito novo: trigger que altera OUTRAS tabelas.
-- O evento acontece em ITEM_PEDIDO, mas a trigger
-- atualiza PRODUTO e PEDIDO.
--
-- Por que AFTER?
-- Só faz sentido baixar o estoque depois que o item foi
-- realmente gravado (ou seja, depois que passou pela
-- validação da TRIGGER 5).
--
-- Observação importante (MySQL):
-- Uma trigger NÃO pode alterar a mesma tabela que a
-- disparou (Error 1442). Por isso o total é atualizado em
-- PEDIDO a partir de uma trigger de ITEM_PEDIDO.
-- ==========================================================

DROP TRIGGER IF EXISTS tg_baixa_estoque_total_pedido;

DELIMITER //

CREATE TRIGGER tg_baixa_estoque_total_pedido

AFTER INSERT ON ITEM_PEDIDO

FOR EACH ROW

BEGIN
    -- a) Baixa no estoque do produto vendido
    UPDATE PRODUTO
    SET ESTOQUE = ESTOQUE - NEW.QUANTIDADE
    WHERE CODIGO = NEW.CODIGO_PRODUTO;

    -- b) Soma o subtotal do item no total do pedido
    -- IFNULL trata o caso do pedido que ainda está sem valor
    -- (NULL + qualquer número = NULL)
    UPDATE PEDIDO
    SET VALOR_TOTAL = IFNULL(VALOR_TOTAL, 0) + NEW.SUBTOTAL
    WHERE CODIGO = NEW.CODIGO_PEDIDO;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comandos que disparam a trigger:
-- criamos um pedido novo, sem valor, e inserimos 2 itens.
--
-- Observe a sequência de triggers envolvidas:
--   INSERT em PEDIDO      -> TRIGGER 4 (BEFORE) e TRIGGER 2 (AFTER)
--   INSERT em ITEM_PEDIDO -> TRIGGER 5 (BEFORE) e TRIGGER 6 (AFTER)
-- ----------------------------------------------------------

INSERT INTO PEDIDO (COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, CONFIRMADO, VALOR_TOTAL)
VALUES (2, 1, NOW(), FALSE, NULL);   -- CODIGO = 3

-- Estoque ANTES dos itens
SELECT CODIGO, NOME, ESTOQUE FROM PRODUTO;

INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (3, 2, 3, 8.50);    -- Feijão: subtotal 25.50

INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO)
VALUES (3, 3, 2, 15.90);   -- Café: subtotal 31.80

-- Conferindo o resultado:
-- Feijão: 50 -> 47 | Café: 30 -> 28
SELECT CODIGO, NOME, ESTOQUE FROM PRODUTO;

-- O pedido 3 deve estar com VALOR_TOTAL = 57.30
SELECT * FROM ITEM_PEDIDO WHERE CODIGO_PEDIDO = 3;
SELECT * FROM PEDIDO WHERE CODIGO = 3;

-- ==========================================================
-- TRIGGER 7
-- Regra:
-- Não permitir excluir um vendedor que possui pedidos.
-- Nesse caso, o correto é desativá-lo (ATIVO = 0).
--
-- Tipo:
-- BEFORE DELETE
--
-- Conceitos novos:
-- 1) No DELETE só existe OLD (o registro que está sendo
--    apagado). NEW não existe, pois não há valor novo.
-- 2) Exclusão lógica: em vez de apagar o registro,
--    marcamos como inativo. O histórico de vendas é mantido.
--
-- Observação:
-- A chave estrangeira de PEDIDO já impediria essa exclusão,
-- mas com uma mensagem técnica (Error 1451). A trigger
-- executa ANTES da verificação da FK e devolve uma mensagem
-- clara, explicando o que fazer.
-- ==========================================================

DROP TRIGGER IF EXISTS tg_impedir_exclusao_vendedor;

DELIMITER //

CREATE TRIGGER tg_impedir_exclusao_vendedor

BEFORE DELETE ON VENDEDOR

FOR EACH ROW

BEGIN
    -- OLD.CODIGO é o código do vendedor que está sendo excluído
    -- EXISTS retorna verdadeiro se encontrar pelo menos 1 pedido
    IF EXISTS (SELECT 1 FROM PEDIDO WHERE COD_VENDEDOR = OLD.CODIGO) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Vendedor possui pedidos e não pode ser excluído. Use UPDATE para definir ATIVO = 0.';
    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger (caso bloqueado):
-- o vendedor 1 possui pedidos.
--
-- ATENÇÃO: este comando VAI GERAR ERRO de propósito.
-- Remova o "-- " e execute somente ele.
-- ----------------------------------------------------------

-- DELETE FROM VENDEDOR WHERE CODIGO = 1;

-- Resultado esperado:
-- Error Code: 1644. Vendedor possui pedidos e não pode ser excluído...

-- ----------------------------------------------------------
-- A alternativa correta: exclusão lógica
--
-- Curiosidade: este UPDATE dispara a TRIGGER 1, mas como o
-- salário não mudou, nada é gravado em HISTORICO_SALARIO.
-- ----------------------------------------------------------

UPDATE VENDEDOR
SET ATIVO = 0
WHERE CODIGO = 1;

SELECT * FROM VENDEDOR;

-- ----------------------------------------------------------
-- Caso permitido: um vendedor SEM pedidos pode ser excluído.
-- A trigger é executada, não encontra pedidos e deixa passar.
-- ----------------------------------------------------------

INSERT INTO PESSOA (NOME, CIDADE, UF, EMAIL, TELEFONE)
VALUES ('Bruno Temporário', 'Brasília', 'DF', 'bruno@email.com', '(61)99999-0003');   -- CODIGO = 3

INSERT INTO VENDEDOR (CODIGO, CNPJ, SALARIO, FAIXA_COMISSAO)
VALUES (3, '98.765.432/0001-10', 2500.00, 'A');

DELETE FROM VENDEDOR WHERE CODIGO = 3;

-- O vendedor 3 não deve mais aparecer
SELECT * FROM VENDEDOR;

-- ==========================================================
-- TRIGGER 8
-- Regra:
-- Ao alterar o preço de um produto:
--   a) o preço não pode ficar negativo;
--   b) o preço não pode cair mais de 50% de uma só vez
--      (proteção contra erro de digitação).
--
-- Tipo:
-- BEFORE UPDATE
--
-- Conceito:
-- No UPDATE existem OLD e NEW ao mesmo tempo, o que
-- permite COMPARAR o valor antigo com o novo.
-- ==========================================================

DROP TRIGGER IF EXISTS tg_validar_preco_produto;

DELIMITER //

CREATE TRIGGER tg_validar_preco_produto

BEFORE UPDATE ON PRODUTO

FOR EACH ROW

BEGIN
    -- a) Preço negativo
    IF NEW.PRECO_BASE < 0 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'O preço do produto não pode ser negativo.';

    END IF;

    -- b) Redução maior que 50% em relação ao preço antigo
    IF NEW.PRECO_BASE < OLD.PRECO_BASE * 0.5 THEN

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Redução de preço maior que 50% não é permitida.';

    END IF;
END //

DELIMITER ;

-- ----------------------------------------------------------
-- Comando que dispara a trigger (caso válido):
-- Feijão de 8.50 para 7.90 (redução pequena)
-- ----------------------------------------------------------

UPDATE PRODUTO
SET PRECO_BASE = 7.90
WHERE CODIGO = 2;

SELECT * FROM PRODUTO;

-- ----------------------------------------------------------
-- Comando que dispara a trigger (caso bloqueado):
-- Café de 15.90 para 1.59 (provável erro de digitação)
--
-- ATENÇÃO: este comando VAI GERAR ERRO de propósito.
-- Remova o "-- " e execute somente ele.
-- ----------------------------------------------------------

-- UPDATE PRODUTO
-- SET PRECO_BASE = 1.59
-- WHERE CODIGO = 3;

-- Resultado esperado:
-- Error Code: 1644. Redução de preço maior que 50% não é permitida.

-- ----------------------------------------------------------
-- Para discussão em aula:
-- A TRIGGER 6 faz um UPDATE em PRODUTO (baixa de estoque).
-- Esse UPDATE também dispara a TRIGGER 8! Como o preço não
-- muda, a validação passa normalmente.
-- Ou seja: uma trigger pode disparar outra trigger.
-- ----------------------------------------------------------

-- ==========================================================
-- RESUMO DAS TRIGGERS CRIADAS
-- ----------------------------------------------------------
--  Nº | Nome                           | Momento | Evento | Tabela
--  1  | tg_historico_salario           | AFTER   | UPDATE | VENDEDOR
--  2  | tg_log_novo_pedido             | AFTER   | INSERT | PEDIDO
--  3  | tg_validar_estoque             | BEFORE  | INSERT | PRODUTO
--  4  | tg_validar_pedido              | BEFORE  | INSERT | PEDIDO
--  5  | tg_validar_item_pedido         | BEFORE  | INSERT | ITEM_PEDIDO
--  6  | tg_baixa_estoque_total_pedido  | AFTER   | INSERT | ITEM_PEDIDO
--  7  | tg_impedir_exclusao_vendedor   | BEFORE  | DELETE | VENDEDOR
--  8  | tg_validar_preco_produto       | BEFORE  | UPDATE | PRODUTO
--
-- Disponibilidade de OLD e NEW:
--   INSERT -> só NEW
--   UPDATE -> OLD e NEW
--   DELETE -> só OLD
--
-- Alterar NEW (SET NEW.campo = ...) só é possível em BEFORE.
-- ==========================================================

-- ==========================================================
-- CONSULTAR AS TRIGGERS CRIADAS NO BANCO
-- ==========================================================

SHOW TRIGGERS;

-- Para apagar uma trigger:
-- DROP TRIGGER nome_da_trigger;