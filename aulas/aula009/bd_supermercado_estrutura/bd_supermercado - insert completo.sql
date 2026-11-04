-- =====================================================================
-- INSERTS - BANCO SUPERMERCADO
-- Execute DEPOIS do script de criação (bd_supermercado.sql).
-- Os dados foram pensados para que TODOS os exercícios retornem linhas,
-- inclusive os casos "sem correspondência" de LEFT/RIGHT JOIN:
--   * Felipe Costa (6)    -> cliente SEM pedidos
--   * João Pedro (10)     -> vendedor SEM pedidos
--   * Karina Duarte (11)  -> pessoa que não é cliente nem vendedora
--   * Eduarda Alves (5)   -> é cliente E vendedora ao mesmo tempo
--   * Produtos 9 e 10     -> nunca foram vendidos
--   * Produtos 7 a 10     -> não têm imagem
--   * Pessoas 6, 10, 11, 12 -> sem login
-- =====================================================================

USE SUPERMERCADO;
SET NAMES utf8mb4;  -- garante que os acentos sejam gravados corretamente

-- ---------------------------------------------------------------------
-- PESSOA
-- ---------------------------------------------------------------------
INSERT INTO PESSOA (CODIGO, NOME, LOGRADOURO, CIDADE, UF, CEP, EMAIL, TELEFONE) VALUES
(1,  'Ana Souza',        'QS 07 Lote 01',          'Brasília',     'DF', '71966-700', 'ana.souza@email.com',      '(61) 99811-1001'),
(2,  'Bruno Lima',       'QNA 12 Casa 05',         'Taguatinga',   'DF', '72110-120', 'bruno.lima@email.com',     '(61) 99811-1002'),
(3,  'Carla Mendes',     'Rua 10, nº 230',         'Goiânia',      'GO', '74120-010', 'carla.mendes@email.com',   '(62) 99811-1003'),
(4,  'Diego Rocha',      'SQN 210 Bloco B',        'Brasília',     'DF', '70862-020', 'diego.rocha@email.com',    '(61) 99811-1004'),
(5,  'Eduarda Alves',    'Rua 25 Norte, Lote 3',   'Águas Claras', 'DF', '71919-180', 'eduarda.alves@email.com',  '(61) 99811-1005'),
(6,  'Felipe Costa',     'Av. Brasil, nº 900',     'Anápolis',     'GO', '75113-570', 'felipe.costa@email.com',   '(62) 99811-1006'),
(7,  'Gabriela Nunes',   'SQS 308 Bloco C',        'Brasília',     'DF', '70355-030', 'gabriela.nunes@email.com', '(61) 99811-1007'),
(8,  'Henrique Prado',   'Av. T-63, nº 1500',      'Goiânia',      'GO', '74230-100', 'henrique.prado@email.com', '(62) 99811-1008'),
(9,  'Isabela Torres',   'QSB 03 Casa 12',         'Taguatinga',   'DF', '72015-030', 'isabela.torres@email.com', '(61) 99811-1009'),
(10, 'João Pedro Ramos', 'QNM 18 Conjunto F',      'Ceilândia',    'DF', '72215-180', 'joao.ramos@email.com',     '(61) 99811-1010'),
(11, 'Karina Duarte',    'SHIN QI 05 Conjunto 2',  'Brasília',     'DF', '71505-020', 'karina.duarte@email.com',  '(61) 99811-1011'),
(12, 'Lucas Ferreira',   'Av. João Naves, nº 400', 'Uberlândia',   'MG', '38408-100', 'lucas.ferreira@email.com', '(34) 99811-1012');

-- ---------------------------------------------------------------------
-- LOGIN (senha_hash fictícia, apenas ilustrativa)
-- ---------------------------------------------------------------------
INSERT INTO LOGIN (CODIGO, USUARIO, SENHA_HASH, ULTIMO_ACESSO) VALUES
(1, 'ana.souza',      '$2y$10$abcdefghijklmnopqrstuuA1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-01 09:12:00'),
(2, 'bruno.lima',     '$2y$10$abcdefghijklmnopqrstuuB1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-03 14:30:00'),
(3, 'carla.mendes',   '$2y$10$abcdefghijklmnopqrstuuC1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-09-28 19:45:00'),
(4, 'diego.rocha',    '$2y$10$abcdefghijklmnopqrstuuD1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-05 08:05:00'),
(5, 'eduarda.alves',  '$2y$10$abcdefghijklmnopqrstuuE1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-06 10:20:00'),
(7, 'gabriela.nunes', '$2y$10$abcdefghijklmnopqrstuuG1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-07 07:55:00'),
(8, 'henrique.prado', '$2y$10$abcdefghijklmnopqrstuuH1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-02 16:40:00'),
(9, 'isabela.torres', '$2y$10$abcdefghijklmnopqrstuuI1b2C3d4E5f6G7h8I9j0K1l2M3n4O5p', '2026-10-04 11:10:00');

-- ---------------------------------------------------------------------
-- CLIENTE (pessoas 1, 2, 3, 4, 5, 6 e 12)
-- ---------------------------------------------------------------------
INSERT INTO CLIENTE (CODIGO, CPF, DATA_CADASTRO) VALUES
(1,  '111.111.111-11', '2026-01-10 10:00:00'),
(2,  '222.222.222-22', '2026-02-15 11:30:00'),
(3,  '333.333.333-33', '2026-03-20 09:15:00'),
(4,  '444.444.444-44', '2026-04-05 15:45:00'),
(5,  '555.555.555-55', '2026-05-12 13:20:00'),
(6,  '666.666.666-66', '2026-06-18 17:00:00'),
(12, '121.212.121-21', '2026-07-22 08:40:00');

-- ---------------------------------------------------------------------
-- VENDEDOR (pessoas 5, 7, 8, 9 e 10)
-- ---------------------------------------------------------------------
INSERT INTO VENDEDOR (CODIGO, CNPJ, SALARIO, FAIXA_COMISSAO, ATIVO) VALUES
(5,  '55.555.555/0001-55', 2600.00, 'C', 1),
(7,  '77.777.777/0001-77', 3200.00, 'A', 1),
(8,  '88.888.888/0001-88', 2700.00, 'B', 1),
(9,  '99.999.999/0001-99', 3100.00, 'A', 1),
(10, '10.101.010/0001-10', 2400.00, 'D', 0);

-- ---------------------------------------------------------------------
-- HISTORICO_SALARIO
-- ---------------------------------------------------------------------
INSERT INTO HISTORICO_SALARIO (CODIGO_VENDEDOR, NOME_VENDEDOR, SALARIO_ANTIGO, SALARIO_NOVO, DATA_HORA_ALTERACAO) VALUES
(7, 'Gabriela Nunes', 2800.00, 3000.00, '2026-03-01 08:00:00'),
(7, 'Gabriela Nunes', 3000.00, 3200.00, '2026-08-01 08:00:00'),
(8, 'Henrique Prado', 2500.00, 2700.00, '2026-06-01 08:00:00'),
(9, 'Isabela Torres', 3000.00, 3100.00, '2026-07-01 08:00:00');

-- ---------------------------------------------------------------------
-- PRODUTO
-- ---------------------------------------------------------------------
INSERT INTO PRODUTO (CODIGO, NOME, DESCRICAO, PRECO_BASE, ESTOQUE) VALUES
(1,  'Arroz Tipo 1 5kg',          'Arroz branco agulhinha tipo 1',      27.90, 120),
(2,  'Feijão Carioca 1kg',        'Feijão carioca tipo 1',               8.49, 200),
(3,  'Café Torrado 500g',         'Café torrado e moído tradicional',   18.90,  80),
(4,  'Leite Integral 1L',         'Leite UHT integral',                  5.29, 300),
(5,  'Óleo de Soja 900ml',        'Óleo de soja refinado',               7.99, 150),
(6,  'Açúcar Refinado 1kg',       'Açúcar refinado especial',            4.79, 180),
(7,  'Macarrão Espaguete 500g',   'Massa de sêmola nº 8',                4.59, 140),
(8,  'Sabão em Pó 1kg',           'Sabão em pó multiação',              14.90,  60),
(9,  'Azeite Extra Virgem 500ml', 'Azeite de oliva extra virgem',       39.90,  25),
(10, 'Chocolate em Barra 90g',    'Chocolate ao leite',                  6.49,  90);

-- ---------------------------------------------------------------------
-- IMAGEM (produtos 1 a 6; produtos 1 e 3 têm duas imagens)
-- ---------------------------------------------------------------------
INSERT INTO IMAGEM (CODIGO_PRODUTO, NUMERO_IMAGEM, URL, DESCRICAO) VALUES
(1, 1, 'https://cdn.supermercado.com/img/arroz_frente.jpg',   'Arroz - frente da embalagem'),
(1, 2, 'https://cdn.supermercado.com/img/arroz_verso.jpg',    'Arroz - verso da embalagem'),
(2, 1, 'https://cdn.supermercado.com/img/feijao_frente.jpg',  'Feijão - frente da embalagem'),
(3, 1, 'https://cdn.supermercado.com/img/cafe_frente.jpg',    'Café - frente da embalagem'),
(3, 2, 'https://cdn.supermercado.com/img/cafe_xicara.jpg',    'Café - sugestão de preparo'),
(4, 1, 'https://cdn.supermercado.com/img/leite_frente.jpg',   'Leite - caixa 1L'),
(5, 1, 'https://cdn.supermercado.com/img/oleo_frente.jpg',    'Óleo - garrafa 900ml'),
(6, 1, 'https://cdn.supermercado.com/img/acucar_frente.jpg',  'Açúcar - pacote 1kg');

-- ---------------------------------------------------------------------
-- PEDIDO (cliente 6 e vendedor 10 propositalmente sem pedidos)
-- ---------------------------------------------------------------------
INSERT INTO PEDIDO (CODIGO, COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, CONFIRMADO, VALOR_TOTAL) VALUES
(1, 1,  7, '2026-09-01 10:15:00', 1, 113.01),
(2, 2,  8, '2026-09-03 16:20:00', 1,  28.48),
(3, 3,  7, '2026-09-05 09:40:00', 0,  34.34),
(4, 1,  9, '2026-09-10 18:05:00', 1,  52.70),
(5, 4,  5, '2026-09-12 11:30:00', 1,  91.38),
(6, 5,  8, '2026-09-15 14:50:00', 1,  29.76),
(7, 12, 9, '2026-09-20 19:10:00', 0,  13.77),
(8, 2,  7, '2026-09-25 08:25:00', 1,  57.70);

-- ---------------------------------------------------------------------
-- ITEM_PEDIDO (SUBTOTAL = QUANTIDADE * PRECO_UNITARIO)
-- Produtos 9 e 10 nunca vendidos.
-- ---------------------------------------------------------------------
INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO, SUBTOTAL) VALUES
(1, 1,  2, 27.90, 55.80),
(1, 2,  3,  8.49, 25.47),
(1, 4,  6,  5.29, 31.74),
(2, 3,  1, 18.90, 18.90),
(2, 6,  2,  4.79,  9.58),
(3, 5,  2,  7.99, 15.98),
(3, 7,  4,  4.59, 18.36),
(4, 8,  1, 14.90, 14.90),
(4, 3,  2, 18.90, 37.80),
(5, 1,  1, 27.90, 27.90),
(5, 4, 12,  5.29, 63.48),
(6, 2,  2,  8.49, 16.98),
(6, 5,  1,  7.99,  7.99),
(6, 6,  1,  4.79,  4.79),
(7, 7,  3,  4.59, 13.77),
(8, 1,  1, 27.90, 27.90),
(8, 8,  2, 14.90, 29.80);
