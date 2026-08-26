CREATE DATABASE supermercado;
USE supermercado;

CREATE TABLE pessoa (
	codigo INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
    logradouro VARCHAR(120),
    cidade VARCHAR(60) NOT NULL,
    uf CHAR(2) NOT NULL,
    cep VARCHAR(9),
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL
 );
 
 CREATE TABLE login (
	pessoa_codigo INT PRIMARY KEY,
    usuario VARCHAR(40) NOT NULL,
    senha_hash VARCHAR(60) NOT NULL,
    ultimo_acesso DATETIME DEFAULT NOW(),
    FOREIGN KEY (pessoa_codigo) REFERENCES pessoa (codigo)
    ON DELETE CASCADE
 );
 
 CREATE TABLE cliente (
	codigo INT PRIMARY KEY,
	cpf VARCHAR(18) NOT NULL UNIQUE,
    data_cadastro TIMESTAMP,
    FOREIGN KEY (codigo) REFERENCES pessoa (codigo)
 );
 
 CREATE TABLE vendedor (
	codigo INT PRIMARY KEY,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    salario DECIMAL(7,2) NOT NULL,
    faixa_comissao ENUM('A', 'B', 'C'),
    ativo TINYINT(1) NOT NULL,
    FOREIGN KEY (codigo) REFERENCES pessoa (codigo)
 );
 
 CREATE TABLE pedido (
	codigo INT PRIMARY KEY,
    codigo_cliente INT,
    codigo_vendedor INT,
    FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo),
    FOREIGN KEY (codigo_vendedor) REFERENCES vendedor (codigo),
    data_pedido TIMESTAMP NOT NULL,
    confirmado TINYINT(1) NOT NULL,
    valor_total DECIMAL(10,2)
 );
 
 CREATE TABLE produto (
	codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    preco_base DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
 );
 
 CREATE TABLE imagem (
	numero_imagem INT PRIMARY KEY,
	codigo_produto INT,
    FOREIGN KEY (codigo_produto) REFERENCES produto (codigo),
    url VARCHAR(200) NOT NULL,
    descricao VARCHAR(200)
 );
 
 CREATE TABLE historico_salario (
	codigo INT PRIMARY KEY,
    codigo_vendedor INT NOT NULL,
    nome_vendedor VARCHAR(100),
    salario_antigo DECIMAL(10,2),
    salario_novo DECIMAL(10,2),
    data_hora_alteracao TIMESTAMP
 );