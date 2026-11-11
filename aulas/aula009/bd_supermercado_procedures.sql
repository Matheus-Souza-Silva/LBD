-- Procedure sem parâmetro — Listar produtos com estoque baixo

DELIMITER //

CREATE PROCEDURE sp_produtos_estoque_baixo()
BEGIN
    SELECT CODIGO, NOME, ESTOQUE, PRECO_BASE
    FROM PRODUTO
    WHERE ESTOQUE <= 10
    ORDER BY ESTOQUE ASC;
END //

DELIMITER ;

-- Execução:
CALL sp_produtos_estoque_baixo();

-- 2) Procedure sem parâmetro — Relatório de pedidos

DELIMITER //

CREATE PROCEDURE sp_relatorio_pedidos()
BEGIN
    SELECT P.CODIGO AS PEDIDO, C.NOME AS CLIENTE, V.NOME AS VENDEDOR, P.DATA_PEDIDO, P.VALOR_TOTAL, P.CONFIRMADO
    FROM PEDIDO P
    INNER JOIN CLIENTE CL ON P.COD_CLIENTE = CL.CODIGO
    INNER JOIN PESSOA C ON CL.CODIGO = C.CODIGO
    INNER JOIN VENDEDOR VD  ON P.COD_VENDEDOR = VD.CODIGO
    INNER JOIN PESSOA V ON VD.CODIGO = V.CODIGO
    ORDER BY P.DATA_PEDIDO DESC;
END //

DELIMITER ;

-- Execução:
CALL sp_relatorio_pedidos();

-- 3) Procedure com parâmetro — Buscar produtos por faixa de preço

DELIMITER //

CREATE PROCEDURE sp_produtos_por_preco( IN valor_min DECIMAL(10,2), IN valor_max DECIMAL(10,2))
BEGIN
    SELECT CODIGO, NOME, PRECO_BASE, ESTOQUE
    FROM PRODUTO
    WHERE PRECO_BASE BETWEEN valor_min AND valor_max
    ORDER BY PRECO_BASE;
END //

DELIMITER ;

-- Execução:
CALL sp_produtos_por_preco(5.00, 50.00);

-- 4) Procedure com parâmetro — Atualizar estoque após venda

DELIMITER //

CREATE PROCEDURE sp_baixar_estoque(IN produto_id INT, IN quantidade_vendida INT)
BEGIN
    UPDATE PRODUTO
    SET ESTOQUE = ESTOQUE - quantidade_vendida
    WHERE CODIGO = produto_id;
END //

DELIMITER ;

-- Execução:

CALL sp_baixar_estoque(3, 5);