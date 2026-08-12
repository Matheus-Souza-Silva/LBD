CREATE DATABASE tela_login;
USE tela_login;
CREATE TABLE usuario (
	codigo INT PRIMARY KEY,
    nome VARCHAR(200),
    email VARCHAR(100),
    telefone VARCHAR(14)
);
CREATE TABLE login (
	codigo INT PRIMARY KEY,
    username VARCHAR(45),
    senha VARCHAR(30),
    cod_usuario INT,
    FOREIGN KEY (cod_usuario) REFERENCES usuario (codigo)
);