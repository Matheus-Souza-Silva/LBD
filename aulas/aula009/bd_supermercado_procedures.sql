-- Procedure sem parâmetro - Listar produtos com estoque baixo

DELIMITER // -- Define que (//) é o fim do código em vez do (;)

DROP PROCEDURE IF EXISTS sp_produtos_estoque_baixo //

CREATE PROCEDURE sp_produtos_estoque_baixo()
BEGIN
	SELECT CODIGO, NOME, ESTOQUE, PRECO_BASE
    FROM PRODUTO
    WHERE ESTOQUE <= 10
    ORDER BY ESTOQUE ASC;
END //

DELIMITER //

DROP PROCEDURE IF EXISTS sp_produtos_por_preco //

CREATE PROCEDURE sp_produtos_por_preco(IN valor_min DECIMAL(10,2), IN valor_max DECIMAL(10,2))
BEGIN
	SELECT CODIGO, NOME, PRECO_BASE, ESTOQUE
    FROM PRODUTO
    WHERE PRECO_BASE BETWEEN valor_min AND valor_max
    ORDER BY PRECO_BASE ASC;
END //

DELIMITER //
    
DROP PROCEDURE IF EXISTS sp_cliente_pessoa //

CREATE PROCEDURE sp_cliente_pessoa()
BEGIN
	SELECT CLIENTE.CPF AS CPF_CLIENTE, PESSOA.EMAIL AS EMAIL_PESSOA
	FROM CLIENTE
	INNER JOIN PESSOA
	ON CLIENTE.CODIGO = PESSOA.CODIGO;
END //

DELIMITER ;