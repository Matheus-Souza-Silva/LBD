-- =====================================================
-- TRIGGERS - BANCO DE DADOS SUPERMERCADO
-- =====================================================

-- =====================================================
-- TRIGGER 1
-- REGRA:
-- Sempre que o salário de um vendedor for alterado,
-- registrar o salário anterior e o novo salário
-- na tabela HISTORICO_SALARIO.
--
-- Tipo:
-- AFTER UDPATE
-- =====================================================

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
    
    -- Neste caso verificamos se o salário realmente mudou
    IF OLD.SALARIO <> NEW.SALARIO
    
    -- Inserimos o registro do histórico