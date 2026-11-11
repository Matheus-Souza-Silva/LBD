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