CREATE DATABASE cliente_telefone;
USE cliente_telefone;
CREATE TABLE cliente (
	codigo INT PRIMARY KEY,
	nome VARCHAR(200),
    cpf VARCHAR(11),
    email VARCHAR(100),
    data_nasc VARCHAR(10)
);
CREATE TABLE telefone (
	codigo INT PRIMARY KEY,
    ddd VARCHAR(2),
    numero VARCHAR(12),
    cod_cliente INT,
    FOREIGN KEY (cod_cliente) REFERENCES cliente (codigo)
);