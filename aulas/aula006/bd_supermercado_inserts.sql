-- =====================
-- PESSOA
-- =====================
INSERT INTO PESSOA (NOME, LOGRADOURO, CIDADE, UF, CEP, EMAIL, TELEFONE) VALUES
('Ana Souza','Rua A','Brasília','DF','70000-001','ana@email.com','1111'),
('Bruno Lima','Rua B','Brasília','DF','70000-002','bruno@email.com','2222'),
('Carla Mendes',NULL,'Goiânia','GO',NULL,'carla@email.com','3333'),
('Daniel Rocha','Rua D','Goiânia','GO','74000-004','daniel@email.com','4444'),
('Eduardo Alves','Rua E','São Paulo','SP','01000-005','edu@email.com','5555'),
('Fernanda Costa',NULL,'São Paulo','SP','01000-006','fernanda@email.com','6666'),
('Gabriel Santos','Rua G','Rio de Janeiro','RJ','20000-007','gabriel@email.com','7777'),
('Helena Martins','Rua H','Rio de Janeiro','RJ',NULL,'helena@email.com','8888'),
('Igor Pereira','Rua I','Curitiba','PR','80000-009','igor@email.com','9999'),
('Juliana Ramos','Rua J','Curitiba','PR','80000-010','juliana@email.com','1010'),
('Lucas Freitas','Rua K','Salvador','BA','40000-011','lucas@email.com','1112'),
('Marina Lopes','Rua L','Salvador','BA',NULL,'marina@email.com','1313');

-- =====================
-- LOGIN (alguns sem acesso e algumas pessoas sem login)
-- =====================
INSERT INTO LOGIN (CODIGO, USUARIO, SENHA_HASH, ULTIMO_ACESSO) VALUES
(1,'ana','h1',NOW()),
(2,'bruno','h2',NOW()),
(3,'carla','h3',NULL),
(5,'edu','h5',NOW()),
(6,'fernanda','h6',NOW()),
(7,'gabriel','h7',NOW()),
(8,'helena','h8',NULL),
(9,'igor','h9',NOW()),
(10,'juliana','h10',NOW()),
(11,'lucas','h11',NOW());

-- =====================
-- CLIENTE
-- =====================
INSERT INTO CLIENTE (CODIGO, CPF) VALUES
(1,'111'),(2,'222'),(3,'333'),(4,'444'),(5,'555'),
(6,'666'),(7,'777'),(8,'888'),(9,'999'),(10,'000');

-- =====================
-- VENDEDOR (alguns clientes também são vendedores)
-- =====================
INSERT INTO VENDEDOR (CODIGO, CNPJ, SALARIO, FAIXA_COMISSAO, ATIVO) VALUES
(3,'c1',2800,'A',1),
(4,'c2',2600,'B',1),
(5,'c3',3000,'A',1),
(6,'c4',2500,'C',1),
(7,'c5',2700,'D',1),
(8,'c6',2900,'A',1),
(9,'c7',3100,'B',1),
(10,'c8',2300,'C',0),
(11,'c9',3200,'A',1),
(12,'c10',2400,'D',1);

-- =====================
-- PRODUTO (com e sem descrição)
-- =====================
INSERT INTO PRODUTO (NOME, DESCRICAO, PRECO_BASE, ESTOQUE) VALUES
('Arroz','Tipo 1',25,100),
('Feijão','Carioca',8.5,200),
('Macarrão',NULL,4,150),
('Óleo','Soja',6.5,80),
('Açúcar',NULL,3.8,120),
('Sal','Refinado',2.5,90),
('Café','500g',12,60),
('Leite','1L',4.5,300),
('Biscoito','Recheado',2,250),
('Refrigerante','2L',7,180);

-- =====================
-- PEDIDO (cliente com vários pedidos e pedidos sem valor total)
-- =====================
INSERT INTO PEDIDO (COD_CLIENTE, COD_VENDEDOR, DATA_PEDIDO, CONFIRMADO, VALOR_TOTAL) VALUES
(1,3,NOW(),1,50),
(1,4,NOW(),1,80),
(2,3,NOW(),1,30),
(3,5,NOW(),0,NULL),
(4,6,NOW(),1,100),
(5,7,NOW(),1,60),
(6,8,NOW(),1,45),
(7,9,NOW(),1,70),
(8,10,NOW(),0,NULL),
(9,11,NOW(),1,90),
(10,12,NOW(),1,120);

-- =====================
-- ITEM_PEDIDO (pedido com 1 e com vários itens / subtotal NULL)
-- =====================
INSERT INTO ITEM_PEDIDO (CODIGO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, PRECO_UNITARIO, SUBTOTAL) VALUES
(1,1,2,25,50),
(2,2,5,8.5,42.5),
(2,3,3,4,12),
(3,4,2,6.5,NULL),
(4,5,5,3.8,19),
(5,6,4,2.5,10),
(6,7,3,12,36),
(7,8,6,4.5,27),
(8,9,10,2,20),
(9,10,4,7,28),
(10,1,1,25,NULL);

-- =====================
-- IMAGEM (produto com 1 e várias imagens / descrição NULL)
-- =====================
INSERT INTO IMAGEM (CODIGO_PRODUTO, NUMERO_IMAGEM, URL, DESCRICAO) VALUES
(1,1,'img1','Frente'),
(1,2,'img2','Verso'),
(2,1,'img3',NULL),
(3,1,'img4',NULL),
(4,1,'img5','Garrafa'),
(5,1,'img6',NULL),
(6,1,'img7','Sal'),
(7,1,'img8','Café'),
(8,1,'img9','Leite'),
(9,1,'img10','Biscoito'),
(10,1,'img11','Refrigerante'),
(10,2,'img12','Lateral');