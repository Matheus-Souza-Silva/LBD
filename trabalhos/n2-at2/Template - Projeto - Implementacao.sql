/* PROJETO FINAL - LABORATÓRIO DE BANCO DE DADOS
Instruções e Estrutura do Arquivo .sql

Identificação do Grupo: 
Inserir os nomes completos e números de matrícula dos integrantes do grupo

KARL EMMANUEL DIENGU MIHINDU	UC25100657
KAWANY BEATRIZ ARAÚJO SOUSA		UC25200027
MARIANA CARDOSO LIMA			UC25200783
MATHEUS SOUZA SILVA				UC25103040

Alterações na Modelagem
Indique se houve alterações na modelagem de dados:
( ) Sim. O arquivo atualizado foi enviado novamente no AVA. 
(X) Não.

ORIENTAÇÕES GERAIS
- As respostas devem ser inseridas diretamente no local indicado pelos enunciados. 
- Arquivos desorganizados não serão corrigidos.
- Consultas SQL muito simples não serão aceitas. Evitem respostas com apenas SELECT, FROM e ORDER BY. 
- Elaborem as queries com atenção aos critérios exigidos.
- A presença na apresentação é obrigatória para a atribuição de nota. Alunos ausentes receberão nota zero no trabalho.

O trabalho deve ser entregue em um único arquivo no formato .sql, contendo todos os itens descritos a seguir:
*/

-- 1. Criação do Banco de Dados e Estrutura
-- Criação do banco de dados.

DROP DATABASE IF EXISTS STREAMING;

CREATE DATABASE IF NOT EXISTS STREAMING
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;

USE STREAMING;

SET NAMES utf8mb4;

-- Criação das tabelas conforme a modelagem apresentada.

CREATE TABLE IF NOT EXISTS PLANO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
    NOME_PLANO VARCHAR(45) NOT NULL,
    DESCRICAO VARCHAR(200),
    PRECO DECIMAL(10,2) NOT NULL,
    QUALIDADE_VIDEO ENUM('SD','HD','FULL_HD','4K') NOT NULL DEFAULT 'HD',
    LIMITE_TELAS SMALLINT NOT NULL DEFAULT 1,
    PERMITE_DOWNLOAD TINYINT(1) NOT NULL DEFAULT 0,
    ATIVO TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS ASSINATURA (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
    CODIGO_PLANO INT NOT NULL,
    CODIGO_ASSINATURA VARCHAR(30) NOT NULL UNIQUE,
    DATA_INICIO DATE NOT NULL,
    DATA_FIM DATE,
    STATUS_ASSINATURA ENUM('ATIVA','SUSPENSA','CANCELADA') NOT NULL DEFAULT 'ATIVA',
    RENOVACAO_AUTOMATICA TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (CODIGO_PLANO) REFERENCES PLANO (CODIGO)
);

CREATE TABLE IF NOT EXISTS USUARIO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
    CODIGO_ASSINATURA INT NOT NULL UNIQUE,
	NOME VARCHAR(100) NOT NULL,
	EMAIL VARCHAR(100) NOT NULL UNIQUE,
	SENHA_HASH VARCHAR(60) NOT NULL,
	CPF CHAR(11) NOT NULL UNIQUE,
	DATA_NASCIMENTO DATE NOT NULL,
	TELEFONE VARCHAR(15),
	DATA_CADASTRO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ATIVO TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (CODIGO_ASSINATURA) REFERENCES ASSINATURA (CODIGO)
);

CREATE TABLE IF NOT EXISTS GENERO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	NOME_GENERO VARCHAR(45) NOT NULL UNIQUE,
	DESCRICAO VARCHAR(200),
	CATEGORIA VARCHAR(40),
	DATA_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ATIVO TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS CONTEUDO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	TITULO VARCHAR(100) NOT NULL,
	SINOPSE TEXT,
	ANO_LANCAMENTO SMALLINT NOT NULL,
	CLASSIFICACAO_ETARIA ENUM('L','10','12','14','16','18') NOT NULL DEFAULT 'L',
	DATA_INCLUSAO_CATALOGO DATE NOT NULL,
	TIPO_CONTEUDO ENUM('FILME','SERIE') NOT NULL,
	TRAILER_URL VARCHAR(200),
	ATIVO TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS FILME (
	CODIGO INT PRIMARY KEY,
	DURACAO_MINUTOS SMALLINT NOT NULL,
	DIRETOR VARCHAR(100),
	ORCAMENTO DECIMAL(12,2),
	BILHETERIA DECIMAL(12,2),
	DATA_ESTREIA_CINEMA DATE,
	RESOLUCAO_MAXIMA ENUM('SD','HD','FULL_HD','4K') NOT NULL DEFAULT 'HD',
	IDIOMA_ORIGINAL VARCHAR(45),
	POSSUI_LEGENDA_PT TINYINT(1) NOT NULL DEFAULT 0,
	FOREIGN KEY (CODIGO) REFERENCES CONTEUDO (CODIGO)
);

CREATE TABLE IF NOT EXISTS SERIE (
	CODIGO INT PRIMARY KEY,
	DATA_PRIMEIRA_EXIBICAO DATE,
	EMISSORA_ORIGINAL VARCHAR(100),
	PAIS_ORIGEM VARCHAR(60),
	STATUS_PRODUCAO ENUM('EM_ANDAMENTO','FINALIZADA','CANCELADA') NOT NULL DEFAULT 'EM_ANDAMENTO',
	CRIADOR VARCHAR(100),
	FOREIGN KEY (CODIGO) REFERENCES CONTEUDO (CODIGO)
);

CREATE TABLE IF NOT EXISTS EPISODIO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_SERIE INT NOT NULL,
	TITULO_EPISODIO VARCHAR(100) NOT NULL,
	NUMERO_TEMPORADA SMALLINT NOT NULL,
	NUMERO_EPISODIO SMALLINT NOT NULL,
	DURACAO_MINUTO SMALLINT,
	DATA_EXIBICAO DATE,
	SINOPSE TEXT,
	UNIQUE (CODIGO_SERIE, NUMERO_TEMPORADA, NUMERO_EPISODIO),
	FOREIGN KEY (CODIGO_SERIE) REFERENCES SERIE (CODIGO)
);

CREATE TABLE IF NOT EXISTS CONTEUDO_GENERO (
	CODIGO_CONTEUDO INT,
	CODIGO_GENERO INT,
	PRINCIPAL TINYINT(1) NOT NULL DEFAULT 0,
	PESO_RELEVANCIA DECIMAL(4,2) NOT NULL DEFAULT 1.00,
	DATA_VINCULACAO DATE NOT NULL,
	OBSERVACAO VARCHAR(100),
	ATIVO TINYINT(1) NOT NULL DEFAULT 1,
	FOREIGN KEY (CODIGO_CONTEUDO) REFERENCES CONTEUDO (CODIGO),
	FOREIGN KEY (CODIGO_GENERO) REFERENCES GENERO (CODIGO),
	PRIMARY KEY (CODIGO_CONTEUDO, CODIGO_GENERO)
);

CREATE TABLE IF NOT EXISTS PERFIL (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_USUARIO INT NOT NULL,
	NOME_PERFIL VARCHAR(45) NOT NULL,
	TIPO_PERFIL ENUM('ADULTO','INFANTIL') NOT NULL DEFAULT 'ADULTO',
	CLASSIFICACAO_ETARIA_MAX ENUM('L','10','12','14','16','18') NOT NULL DEFAULT '18',
	IDIOMA_PREFERIDO VARCHAR(10) NOT NULL DEFAULT 'pt-BR',
	DATA_CRIACAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	ATIVO TINYINT(1) NOT NULL DEFAULT 1,
	UNIQUE (CODIGO_USUARIO, NOME_PERFIL),
	FOREIGN KEY (CODIGO_USUARIO) REFERENCES USUARIO (CODIGO)
);

CREATE TABLE IF NOT EXISTS DISPOSITIVO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_USUARIO INT NOT NULL,
	TIPO_DISPOSITIVO VARCHAR(30) NOT NULL,
	MODELO VARCHAR(60),
	SISTEMA_OPERACIONAL VARCHAR(40),
	DATA_ULTIMO_ACESSO DATETIME,
	ATIVO TINYINT(1) NOT NULL DEFAULT 1,
	FOREIGN KEY (CODIGO_USUARIO) REFERENCES USUARIO (CODIGO)
);

CREATE TABLE IF NOT EXISTS FORMA_PAGAMENTO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_USUARIO INT NOT NULL,
	TIPO_PAGAMENTO ENUM('CARTAO_CREDITO','PIX','BOLETO') NOT NULL,
	NOME_TITULAR VARCHAR(100),
	ULTIMOS_DIGITOS CHAR(4),
	BANDEIRA VARCHAR(30),
	DATA_VALIDADE DATE,
	STATUS TINYINT(1) NOT NULL DEFAULT 1,
	DATA_CADASTRO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (CODIGO_USUARIO) REFERENCES USUARIO (CODIGO)
);

CREATE TABLE IF NOT EXISTS PAGAMENTO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_FORMA_PAGAMENTO INT NOT NULL,
	DATA_PAGAMENTO DATETIME,
	DATA_VENCIMENTO DATE NOT NULL,
	VALOR DECIMAL(10,2) NOT NULL,
	STATUS_PAGAMENTO ENUM('PENDENTE','APROVADO','RECUSADO','ESTORNADO') NOT NULL DEFAULT 'PENDENTE',
	CODIGO_TRANSACAO VARCHAR(60) UNIQUE,
	FOREIGN KEY (CODIGO_FORMA_PAGAMENTO) REFERENCES FORMA_PAGAMENTO (CODIGO)
);

CREATE TABLE IF NOT EXISTS HISTORICO_VISUALIZACAO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_PERFIL INT NOT NULL,
	CODIGO_CONTEUDO INT NOT NULL,
	DATA_HORA_INICIO DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	DATA_HORA_FIM DATETIME,
	TEMPO_ASSISTIDO_SEG INT NOT NULL DEFAULT 0,
	PERCENTUAL_PROGRESSO DECIMAL(5,2) NOT NULL DEFAULT 0,
	CONCLUIDO TINYINT(1) NOT NULL DEFAULT 0,
	ORIGEM_ACESSO VARCHAR(30),
	FOREIGN KEY (CODIGO_PERFIL) REFERENCES PERFIL (CODIGO),
	FOREIGN KEY (CODIGO_CONTEUDO) REFERENCES CONTEUDO (CODIGO)
);

CREATE TABLE IF NOT EXISTS AVALIACAO (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_PERFIL INT NOT NULL,
	CODIGO_CONTEUDO INT NOT NULL,
	NOTA DECIMAL(3,1) NOT NULL,
	COMENTARIO TEXT,
	DATA_AVALIACAO DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	RECOMENDA TINYINT(1) NOT NULL DEFAULT 1,
	UNIQUE (CODIGO_PERFIL, CODIGO_CONTEUDO),
	FOREIGN KEY (CODIGO_PERFIL) REFERENCES PERFIL (CODIGO),
	FOREIGN KEY (CODIGO_CONTEUDO) REFERENCES CONTEUDO (CODIGO)
);

CREATE TABLE IF NOT EXISTS MINHA_LISTA (
	CODIGO INT PRIMARY KEY AUTO_INCREMENT,
	CODIGO_PERFIL INT NOT NULL,
	CODIGO_CONTEUDO INT NOT NULL,
	DATA_ADICAO TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIORIDADE SMALLINT NOT NULL DEFAULT 1,
	NOTIFICAR_LANCAMENTO TINYINT(1) NOT NULL DEFAULT 0,
	UNIQUE (CODIGO_PERFIL, CODIGO_CONTEUDO),
	FOREIGN KEY (CODIGO_PERFIL) REFERENCES PERFIL (CODIGO),
	FOREIGN KEY (CODIGO_CONTEUDO) REFERENCES CONTEUDO (CODIGO)
);

-- 2. Inserção de Dados
-- Inserção de dados em todas as tabelas. Cada tabela deve conter no mínimo 30 comandos INSERT. É permitido utilizar ferramentas auxiliares para gerar dados, como o ChatGPT ou geradores automáticos de dados fictícios.

START TRANSACTION;

-- ---------------------------------------------------------------------
-- 2.1 PLANO — 30 planos comerciais
-- ---------------------------------------------------------------------
INSERT INTO PLANO (CODIGO, NOME_PLANO, DESCRICAO, PRECO, QUALIDADE_VIDEO, LIMITE_TELAS, PERMITE_DOWNLOAD, ATIVO) VALUES
(1,  'Básico Mensal',            'Catálogo completo em SD para 1 tela, sem downloads.',           19.90,  'SD',      1,  0, 1),
(2,  'Básico Anual',             'Plano anual de entrada com cobrança única em SD.',              199.90, 'SD',      1,  0, 1),
(3,  'Padrão Mensal',            'HD em 2 telas simultâneas e download em 1 dispositivo.',        29.90,  'HD',      2,  1, 1),
(4,  'Padrão Anual',             'Versão anual do plano Padrão com desconto de 16%.',             299.90, 'HD',      2,  1, 1),
(5,  'Avançado Mensal',          'Full HD em 3 telas com downloads ilimitados.',                  39.90,  'FULL_HD', 3,  1, 1),
(6,  'Avançado Anual',           'Plano anual Avançado, indicado para famílias pequenas.',        399.90, 'FULL_HD', 3,  1, 1),
(7,  'Premium Mensal',           '4K HDR em 4 telas, áudio 5.1 e downloads ilimitados.',          54.90,  '4K',      4,  1, 1),
(8,  'Premium Anual',            'Plano anual Premium com o menor custo mensal em 4K.',           549.90, '4K',      4,  1, 1),
(9,  'Família Mensal',           '4K em 5 telas, perfis ilimitados e controle parental.',         64.90,  '4K',      5,  1, 1),
(10, 'Família Anual',            'Plano anual Família com 5 telas simultâneas em 4K.',            649.90, '4K',      5,  1, 1),
(11, 'Universitário Mensal',     'Meia-entrada para estudantes, HD em 1 tela.',                   14.90,  'HD',      1,  1, 1),
(12, 'Universitário Anual',      'Plano anual universitário com verificação semestral.',          149.90, 'HD',      1,  1, 1),
(13, 'Trimestral Padrão',        'Padrão trimestral, sem fidelidade e sem renovação automática.', 79.90,  'HD',      2,  1, 1),
(14, 'Semestral Padrão',         'Padrão semestral com desconto progressivo.',                    149.90, 'HD',      2,  1, 1),
(15, 'Trimestral Premium',       'Premium trimestral em 4K para até 4 telas.',                    149.90, '4K',      4,  1, 1),
(16, 'Semestral Premium',        'Premium semestral com desconto de 12%.',                        289.90, '4K',      4,  1, 1),
(17, 'Mobile Mensal',            'Apenas celular e tablet, SD em 1 tela.',                        12.90,  'SD',      1,  1, 1),
(18, 'Mobile Anual',             'Plano anual Mobile com o menor preço do catálogo.',             129.90, 'SD',      1,  1, 1),
(19, 'Duo Mensal',               'Full HD em 2 telas para duas pessoas.',                         34.90,  'FULL_HD', 2,  1, 1),
(20, 'Duo Anual',                'Plano anual Duo com desconto de 16%.',                          349.90, 'FULL_HD', 2,  1, 1),
(21, 'Teste 7 Dias',             'Período de teste gratuito de 7 dias em HD.',                    0.00,   'HD',      1,  0, 1),
(22, 'Teste 30 Dias',            'Período de teste gratuito de 30 dias em Full HD.',              0.00,   'FULL_HD', 2,  0, 1),
(23, 'Promocional Black Friday', 'Oferta promocional de Black Friday válida por 12 meses.',       9.90,   'HD',      2,  1, 1),
(24, 'Legado Mensal',            'Plano legado mantido apenas para clientes antigos.',            24.90,  'HD',      2,  0, 0),
(25, 'Legado Anual',             'Plano legado anual, sem novas adesões.',                        249.90, 'HD',      2,  0, 0),
(26, 'Cinema Mensal',            '4K em 2 telas com estreias de cinema antecipadas.',             44.90,  '4K',      2,  1, 1),
(27, 'Cinema Anual',             'Plano anual Cinema com acesso ao catálogo de estreias.',        449.90, '4K',      2,  1, 1),
(28, 'Kids Mensal',              'Conteúdo infantil em HD para 2 telas.',                         17.90,  'HD',      2,  1, 1),
(29, 'Kids Anual',               'Plano anual Kids com controle parental reforçado.',             179.90, 'HD',      2,  1, 1),
(30, 'Corporativo Mensal',       'Licença corporativa 4K para até 10 telas.',                     89.90,  '4K',      10, 1, 1);

-- ---------------------------------------------------------------------
-- 2.2 ASSINATURA — 30 contratos de assinatura
-- ---------------------------------------------------------------------
INSERT INTO ASSINATURA (CODIGO, CODIGO_PLANO, CODIGO_ASSINATURA, DATA_INICIO, DATA_FIM, STATUS_ASSINATURA, RENOVACAO_AUTOMATICA) VALUES
(1,  1,  'ASS-2025-0001', '2025-01-01', NULL,         'ATIVA',     1),
(2,  2,  'ASS-2025-0002', '2025-01-08', NULL,         'ATIVA',     1),
(3,  3,  'ASS-2025-0003', '2025-01-15', NULL,         'ATIVA',     1),
(4,  4,  'ASS-2025-0004', '2025-01-22', NULL,         'ATIVA',     1),
(5,  5,  'ASS-2025-0005', '2025-01-29', NULL,         'ATIVA',     1),
(6,  6,  'ASS-2025-0006', '2025-02-05', NULL,         'ATIVA',     1),
(7,  7,  'ASS-2025-0007', '2025-02-12', NULL,         'SUSPENSA',  0),
(8,  8,  'ASS-2025-0008', '2025-02-19', NULL,         'ATIVA',     1),
(9,  9,  'ASS-2025-0009', '2025-02-26', '2025-06-26', 'CANCELADA', 0),
(10, 10, 'ASS-2025-0010', '2025-03-05', NULL,         'ATIVA',     1),
(11, 11, 'ASS-2025-0011', '2025-03-12', NULL,         'ATIVA',     1),
(12, 12, 'ASS-2025-0012', '2025-03-19', NULL,         'ATIVA',     1),
(13, 13, 'ASS-2025-0013', '2025-03-26', NULL,         'ATIVA',     1),
(14, 14, 'ASS-2025-0014', '2025-04-02', NULL,         'SUSPENSA',  0),
(15, 15, 'ASS-2025-0015', '2025-04-09', NULL,         'ATIVA',     1),
(16, 16, 'ASS-2025-0016', '2025-04-16', NULL,         'ATIVA',     1),
(17, 17, 'ASS-2025-0017', '2025-04-23', NULL,         'ATIVA',     1),
(18, 18, 'ASS-2025-0018', '2025-04-30', '2025-08-28', 'CANCELADA', 0),
(19, 19, 'ASS-2025-0019', '2025-05-07', NULL,         'ATIVA',     1),
(20, 20, 'ASS-2025-0020', '2025-05-14', NULL,         'ATIVA',     1),
(21, 21, 'ASS-2025-0021', '2025-05-21', NULL,         'SUSPENSA',  0),
(22, 22, 'ASS-2025-0022', '2025-05-28', NULL,         'ATIVA',     1),
(23, 23, 'ASS-2025-0023', '2025-06-04', NULL,         'ATIVA',     1),
(24, 24, 'ASS-2025-0024', '2025-06-11', NULL,         'ATIVA',     1),
(25, 25, 'ASS-2025-0025', '2025-06-18', NULL,         'ATIVA',     1),
(26, 26, 'ASS-2025-0026', '2025-06-25', NULL,         'ATIVA',     1),
(27, 27, 'ASS-2025-0027', '2025-07-02', '2025-10-30', 'CANCELADA', 0),
(28, 28, 'ASS-2025-0028', '2025-07-09', NULL,         'SUSPENSA',  0),
(29, 29, 'ASS-2025-0029', '2025-07-16', NULL,         'ATIVA',     1),
(30, 30, 'ASS-2025-0030', '2025-07-23', NULL,         'ATIVA',     1);

-- ---------------------------------------------------------------------
-- 2.3 USUARIO — 30 clientes cadastrados
-- ---------------------------------------------------------------------
INSERT INTO USUARIO (CODIGO, CODIGO_ASSINATURA, NOME, EMAIL, SENHA_HASH, CPF, DATA_NASCIMENTO, TELEFONE, DATA_CADASTRO, ATIVO) VALUES
(1,  1,  'Ana Beatriz Ferreira',   'ana-beatriz-ferreira@exemplo.com',     '$2b$12$180f7600b42e4cd6944bda2cf2265705b4d9068a35b79a2d94046', '12345678909', '1973-05-19', '(11) 91123-4567', '2025-01-01 09:07:00', 1),
(2,  2,  'Bruno Carvalho Lima',    'bruno-carvalho-lima@email.com.br',     '$2b$12$2e61a0c55405c0fb201532535732f0216bd5007b69f38ef1661ef', '24691357882', '1976-10-04', '(21) 91246-9134', '2025-01-08 09:14:00', 1),
(3,  3,  'Carla Mendes Souza',     'carla-mendes-souza@correio.net',       '$2b$12$69308a34b85ac4c34eb46abe8586e8f81ef7ab3727181f14ef0cf', '37037036790', '1980-02-20', '(31) 91370-3701', '2025-01-15 09:21:00', 1),
(4,  4,  'Daniel Oliveira Ramos',  'daniel-oliveira-ramos@webmail.com.br', '$2b$12$b61e62e519617c4854ea062a8a5a1a0c64720dd9259d975b726bb', '49382715673', '1983-07-08', '(41) 91493-8268', '2025-01-22 09:28:00', 1),
(5,  5,  'Eduarda Santos Prado',   'eduarda-santos-prado@contato.com',     '$2b$12$f81aef005c2bad4f5c734024bcf2c9fc8b84e12fca3093b152478', '61728394546', '1986-11-23', '(51) 91617-2835', '2025-01-29 09:35:00', 1),
(6,  6,  'Felipe Nogueira Castro', 'felipe-nogueira-castro@exemplo.com',   '$2b$12$acf0a72979c1e78651625e289ba05d20e8c86e9438632013747ef', '74074073471', '1990-04-10', '(61) 91740-7402', '2025-02-05 09:42:00', 1),
(7,  7,  'Gabriela Almeida Reis',  'gabriela-almeida-reis@email.com.br',   '$2b$12$503db23bb8211acb70cee12a0c1e8a0cdbeb31e421c7d8b82547d', '86419752337', '1993-08-26', '(71) 91864-1969', '2025-02-12 09:49:00', 1),
(8,  8,  'Henrique Barbosa Pinto', 'henrique-barbosa-pinto@correio.net',   '$2b$12$5f7fc666f1ab2224cd3c3e5196c2360b7a1d5a07b5bd78e28c759', '98765431219', '1997-01-11', '(81) 91987-6536', '2025-02-19 09:56:00', 1),
(9,  9,  'Isabela Rocha Moreira',  'isabela-rocha-moreira@webmail.com.br', '$2b$12$fc95c7b9dba891ca14583444a3e630c661070810587938cd55070', '11111110140', '2000-05-29', '(91) 92111-1103', '2025-02-26 09:03:00', 0),
(10, 10, 'João Pedro Martins',     'joao-pedro-martins@contato.com',       '$2b$12$c93767414d426dbdc5a09b2ace1b113ee906092143dcc35cc6039', '23456789092', '1970-12-07', '(85) 92234-5670', '2025-03-05 09:10:00', 1),
(11, 11, 'Karina Duarte Freitas',  'karina-duarte-freitas@exemplo.com',    '$2b$12$34542757c82cbdb51bb3745e6ca7fda8e6fdbbaea7693d3e6f9b7', '35802467983', '1974-04-24', '(11) 92358-0237', '2025-03-12 09:17:00', 1),
(12, 12, 'Leonardo Vieira Costa',  'leonardo-vieira-costa@email.com.br',   '$2b$12$3ce294fa03888cc9892673ee422b71a24d94ab74eb3ab5fcee470', '48148146829', '1977-09-09', '(21) 92481-4804', '2025-03-19 09:24:00', 1),
(13, 13, 'Mariana Teixeira Lopes', 'mariana-teixeira-lopes@correio.net',   '$2b$12$90782a1927803e915debd42600499d6d41f38b149dcf2f8a98643', '60493825738', '1981-01-25', '(31) 92604-9371', '2025-03-26 09:31:00', 1),
(14, 14, 'Nathan Ribeiro Alves',   'nathan-ribeiro-alves@webmail.com.br',  '$2b$12$7193412201c9c9eb1162378e9ff8e0f16c5b612f676c359cf69a5', '72839504600', '1984-06-12', '(41) 92728-3938', '2025-04-02 09:38:00', 1),
(15, 15, 'Olívia Campos Batista',  'olivia-campos-batista@contato.com',    '$2b$12$a4e5e1fa4c36358bb12c462a917f1e9a66f83ff0bd66a874c20d1', '85185183500', '1987-10-29', '(51) 92851-8505', '2025-04-09 09:45:00', 1),
(16, 16, 'Paulo Sérgio Andrade',   'paulo-sergio-andrade@exemplo.com',     '$2b$12$b1da4d860f0df839147e7b9e56645c32b9db23fe6bccced2be2ad', '97530862456', '1991-03-16', '(61) 92975-3072', '2025-04-16 09:52:00', 1),
(17, 17, 'Queila Monteiro Dias',   'queila-monteiro-dias@email.com.br',    '$2b$12$1327b093909df167d15967c838a72245c7249e5d4ff8e729cfa22', '09876541366', '1994-08-01', '(71) 93098-7639', '2025-04-23 09:59:00', 1),
(18, 18, 'Rafael Cardoso Nunes',   'rafael-cardoso-nunes@correio.net',     '$2b$12$8ef8c16b7796cf38098b9098df950fc37190e3ed6e4cc1fdfb1e5', '22222220289', '1997-12-17', '(81) 93222-2206', '2025-04-30 09:06:00', 0),
(19, 19, 'Sabrina Fonseca Melo',   'sabrina-fonseca-melo@webmail.com.br',  '$2b$12$88dc615f5c5369059fa07187e6bd6d028884530a48bde78a51984', '34567899121', '2001-05-04', '(91) 93345-6773', '2025-05-07 09:13:00', 1),
(20, 20, 'Thiago Araújo Bezerra',  'thiago-araujo-bezerra@contato.com',    '$2b$12$4ee49b05921629703dbb483df55badb99e6e3fc38d41c631cd6aa', '46913578075', '1971-11-12', '(85) 93469-1340', '2025-05-14 09:20:00', 1),
(21, 21, 'Úrsula Paiva Correia',   'ursula-paiva-correia@exemplo.com',     '$2b$12$7c59a16fc50385ca32b05a389fca857ccb2b6c0e9b83ef02986ef', '59259256968', '1975-03-30', '(11) 93592-5907', '2025-05-21 09:27:00', 1),
(22, 22, 'Vinícius Braga Farias',  'vinicius-braga-farias@email.com.br',   '$2b$12$724660704cf46993e54572f0491796c0088ee39ca8c815a4b2949', '71604935839', '1978-08-15', '(21) 93716-0474', '2025-05-28 09:34:00', 1),
(23, 23, 'Wesley Tavares Cunha',   'wesley-tavares-cunha@correio.net',     '$2b$12$19bf8ec3dbcfe7b620a2068ed99b8eda9a98c768c2e597af78aaa', '83950614710', '1981-12-31', '(31) 93839-5041', '2025-06-04 09:41:00', 1),
(24, 24, 'Xênia Pires Machado',    'xenia-pires-machado@webmail.com.br',   '$2b$12$b1dc000052ca581c2e145be81958cc1aca5e5a5f89291c7071231', '96296293640', '1985-05-18', '(41) 93962-9608', '2025-06-11 09:48:00', 1),
(25, 25, 'Yasmin Fontes Barros',   'yasmin-fontes-barros@contato.com',     '$2b$12$d05ecc5add0faceb8060720c36c69bb0192bad7b29b6151ea4298', '08641972501', '1988-10-03', '(51) 94086-4175', '2025-06-18 09:55:00', 1),
(26, 26, 'Zélia Queiroz Sampaio',  'zelia-queiroz-sampaio@exemplo.com',    '$2b$12$9225dba5d9b2ce1686abf0d7aed8fd79dc62a6c4b6bdfae93575d', '20987651420', '1992-02-19', '(61) 94209-8742', '2025-06-25 09:02:00', 1),
(27, 27, 'André Luiz Peixoto',     'andre-luiz-peixoto@email.com.br',      '$2b$12$77e1b651a7277503cfe0aacd05fe941d77e2d15be572fe8a94219', '33333330318', '1995-07-07', '(71) 94333-3309', '2025-07-02 09:09:00', 0),
(28, 28, 'Bianca Salgado Torres',  'bianca-salgado-torres@correio.net',    '$2b$12$1207ba9a19e900d8e93489e76adba6d70c4c061fdcc5fb5f13e5a', '45679009285', '1998-11-22', '(81) 94456-7876', '2025-07-09 09:16:00', 1),
(29, 29, 'Caio Emanuel Furtado',   'caio-emanuel-furtado@webmail.com.br',  '$2b$12$42a21bb613d239ad4c97d5f8f00e43bb208f8c386891af45242a9', '58024688158', '2002-04-09', '(91) 94580-2443', '2025-07-16 09:23:00', 1),
(30, 30, 'Débora Regina Amaral',   'debora-regina-amaral@contato.com',     '$2b$12$c081808335cc12e81dc230f79a556a0cbb57651f3f774488f7dbb', '70370367065', '1972-10-17', '(85) 94703-7010', '2025-07-23 09:30:00', 1);

-- ---------------------------------------------------------------------
-- 2.4 GENERO — 30 gêneros do catálogo
-- ---------------------------------------------------------------------
INSERT INTO GENERO (CODIGO, NOME_GENERO, DESCRICAO, CATEGORIA, DATA_CRIACAO, ATIVO) VALUES
(1,  'Ação',              'Perseguições, confrontos e ritmo acelerado.',            'FICCAO',         '2024-03-02 09:00:00', 1),
(2,  'Aventura',          'Jornadas, descobertas e desafios em locais distantes.',  'FICCAO',         '2024-03-03 10:00:00', 1),
(3,  'Comédia',           'Humor leve, situações improváveis e diálogos rápidos.',  'ENTRETENIMENTO', '2024-03-04 11:00:00', 1),
(4,  'Drama',             'Conflitos humanos e conflitos familiares densos.',       'FICCAO',         '2024-03-05 12:00:00', 1),
(5,  'Terror',            'Suspense sobrenatural e atmosfera de medo.',             'FICCAO',         '2024-03-06 13:00:00', 1),
(6,  'Suspense',          'Tensão psicológica e reviravoltas narrativas.',          'FICCAO',         '2024-03-07 08:00:00', 1),
(7,  'Ficção Científica', 'Futuro, tecnologia e viagens espaciais.',                'FICCAO',         '2024-03-08 09:00:00', 1),
(8,  'Romance',           'Histórias de amor e relacionamentos afetivos.',          'ENTRETENIMENTO', '2024-03-09 10:00:00', 1),
(9,  'Documentário',      'Produções de não ficção sobre temas reais.',             'NAO_FICCAO',     '2024-03-10 11:00:00', 1),
(10, 'Animação',          'Obras animadas para todas as idades.',                   'INFANTIL',       '2024-03-11 12:00:00', 1),
(11, 'Musical',           'Narrativas conduzidas por música e coreografia.',        'ENTRETENIMENTO', '2024-03-12 13:00:00', 1),
(12, 'Guerra',            'Conflitos armados e suas consequências.',                'FICCAO',         '2024-03-13 08:00:00', 1),
(13, 'Faroeste',          'Velho Oeste, fronteiras e disputas por terra.',          'FICCAO',         '2024-03-14 09:00:00', 1),
(14, 'Policial',          'Investigações, crimes e perseguições.',                  'FICCAO',         '2024-03-15 10:00:00', 1),
(15, 'Fantasia',          'Mundos mágicos, criaturas e profecias.',                 'FICCAO',         '2024-03-16 11:00:00', 1),
(16, 'Mistério',          'Enigmas que precisam ser solucionados.',                 'FICCAO',         '2024-03-17 12:00:00', 1),
(17, 'Biografia',         'Trajetórias de personalidades reais.',                   'NAO_FICCAO',     '2024-03-18 13:00:00', 1),
(18, 'Esporte',           'Competições, bastidores e superação esportiva.',         'NAO_FICCAO',     '2024-03-19 08:00:00', 1),
(19, 'Infantil',          'Conteúdo educativo e recreativo para crianças.',         'INFANTIL',       '2024-03-20 09:00:00', 1),
(20, 'Nacional',          'Produções brasileiras de diferentes regiões.',           'NAO_FICCAO',     '2024-03-21 10:00:00', 1),
(21, 'Noir',              'Crimes urbanos e personagens moralmente ambíguos.',      'FICCAO',         '2024-03-22 11:00:00', 1),
(22, 'Catástrofe',        'Desastres naturais e sobrevivência em massa.',           'FICCAO',         '2024-03-23 12:00:00', 1),
(23, 'Espionagem',        'Agentes secretos, conspirações e traição.',              'FICCAO',         '2024-03-24 13:00:00', 1),
(24, 'Histórico',         'Reconstituições de períodos históricos.',                'NAO_FICCAO',     '2024-03-25 08:00:00', 1),
(25, 'Sobrenatural',      'Fenômenos inexplicáveis e entidades.',                   'FICCAO',         '2024-03-26 09:00:00', 1),
(26, 'Culinária',         'Gastronomia, receitas e competições de cozinha.',        'ENTRETENIMENTO', '2024-03-27 10:00:00', 1),
(27, 'Reality Show',      'Competições e convivência em formato reality.',          'ENTRETENIMENTO', '2024-03-28 11:00:00', 1),
(28, 'Talk Show',         'Entrevistas, debates e plateia ao vivo.',                'ENTRETENIMENTO', '2024-03-29 12:00:00', 0),
(29, 'Stand-up',          'Apresentações de humor em palco.',                       'ENTRETENIMENTO', '2024-03-30 13:00:00', 1),
(30, 'Cyberpunk',         'Futuro distópico marcado por tecnologia e corporações.', 'FICCAO',         '2024-03-31 08:00:00', 0);

-- ---------------------------------------------------------------------
-- 2.5 CONTEUDO — 60 obras (30 filmes + 30 séries)
-- ---------------------------------------------------------------------
INSERT INTO CONTEUDO (CODIGO, TITULO, SINOPSE, ANO_LANCAMENTO, CLASSIFICACAO_ETARIA, DATA_INCLUSAO_CATALOGO, TIPO_CONTEUDO, TRAILER_URL, ATIVO) VALUES
(1, 'O Último Farol', 'Um detetive aposentado volta à cidade natal depois de vinte anos na Serra do Mar. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2023, '12', '2024-01-27', 'FILME', 'https://trailer.streaming.com/o-ultimo-farol', 1),
(2, 'Código Vermelho', 'Uma enfermeira da periferia perde a memória após um acidente na fronteira com o Uruguai. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2022, '16', '2024-02-13', 'FILME', 'https://trailer.streaming.com/codigo-vermelho', 1),
(3, 'A Ponte de Ferro', 'Um piloto de testes se envolve em uma investigação proibida na periferia de São Paulo. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2021, '14', '2024-03-01', 'FILME', 'https://trailer.streaming.com/a-ponte-de-ferro', 1),
(4, 'Noite sem Fim', 'Uma jornalista investigativa encontra uma carta nunca enviada no centro histórico de Salvador. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2024, '16', '2024-03-18', 'FILME', 'https://trailer.streaming.com/noite-sem-fim', 1),
(5, 'Coração de Aço', 'Um músico fracassado recebe uma ligação anônima no sertão da Paraíba. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2020, '12', '2024-04-04', 'FILME', 'https://trailer.streaming.com/coracao-de-aco', 1),
(6, 'O Silêncio das Dunas', 'Uma advogada recém-formada encontra um diário escondido no interior de Minas Gerais. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2019, '14', '2024-04-21', 'FILME', 'https://trailer.streaming.com/o-silencio-das-dunas', 1),
(7, 'Rota 101', 'Um ex-soldado herda uma casa abandonada em uma pequena cidade do Paraná. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2023, '16', '2024-05-08', 'FILME', 'https://trailer.streaming.com/rota-101', 1),
(8, 'A Herança do Vale', 'Uma cientista de dados aceita um trabalho fora do país em um bairro operário de Porto Alegre. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2018, 'L', '2024-05-25', 'FILME', 'https://trailer.streaming.com/a-heranca-do-vale', 1),
(9, 'Fronteira Selvagem', 'Um mecânico de bairro assume um segredo de família em uma ilha do litoral norte. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2022, '16', '2024-06-11', 'FILME', 'https://trailer.streaming.com/fronteira-selvagem', 1),
(10, 'O Enigma de Lisboa', 'Uma adolescente prodígio descobre um arquivo confidencial no litoral de Santa Catarina. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2021, '14', '2024-06-28', 'FILME', 'https://trailer.streaming.com/o-enigma-de-lisboa', 1),
(11, 'Operação Aurora', 'Um cozinheiro famoso volta à cidade natal depois de vinte anos na Serra do Mar. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2024, '14', '2024-07-15', 'FILME', 'https://trailer.streaming.com/operacao-aurora', 1),
(12, 'A Casa Amarela', 'Uma fotógrafa de guerra perde a memória após um acidente na fronteira com o Uruguai. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2017, '10', '2024-08-01', 'FILME', 'https://trailer.streaming.com/a-casa-amarela', 1),
(13, 'Maré Alta', 'Um professor de física se envolve em uma investigação proibida na periferia de São Paulo. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2023, '12', '2024-08-18', 'FILME', 'https://trailer.streaming.com/mare-alta', 1),
(14, 'O Último Round', 'Uma delegada encontra uma carta nunca enviada no centro histórico de Salvador. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2022, '14', '2024-09-04', 'FILME', 'https://trailer.streaming.com/o-ultimo-round', 1),
(15, 'Cartas para Marte', 'Uma professora de história recebe uma ligação anônima no sertão da Paraíba. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2025, '10', '2024-09-21', 'FILME', 'https://trailer.streaming.com/cartas-para-marte', 1),
(16, 'A Cidade Submersa', 'Um detetive aposentado encontra um diário escondido no interior de Minas Gerais. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2020, '12', '2024-10-08', 'FILME', 'https://trailer.streaming.com/a-cidade-submersa', 1),
(17, 'Riso Solto', 'Uma enfermeira da periferia herda uma casa abandonada em uma pequena cidade do Paraná. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2019, 'L', '2024-10-25', 'FILME', 'https://trailer.streaming.com/riso-solto', 1),
(18, 'O Guardião da Floresta', 'Um piloto de testes aceita um trabalho fora do país em um bairro operário de Porto Alegre. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2021, 'L', '2024-11-11', 'FILME', 'https://trailer.streaming.com/o-guardiao-da-floresta', 1),
(19, 'Sangue e Areia', 'Uma jornalista investigativa assume um segredo de família em uma ilha do litoral norte. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2018, '18', '2024-11-28', 'FILME', 'https://trailer.streaming.com/sangue-e-areia', 1),
(20, 'Protocolo Zero', 'Um músico fracassado descobre um arquivo confidencial no litoral de Santa Catarina. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2024, '16', '2024-12-15', 'FILME', 'https://trailer.streaming.com/protocolo-zero', 1),
(21, 'Dois Verões', 'Uma advogada recém-formada volta à cidade natal depois de vinte anos na Serra do Mar. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2022, '12', '2025-01-01', 'FILME', 'https://trailer.streaming.com/dois-veroes', 1),
(22, 'A Voz do Deserto', 'Um ex-soldado perde a memória após um acidente na fronteira com o Uruguai. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2020, '14', '2025-01-18', 'FILME', 'https://trailer.streaming.com/a-voz-do-deserto', 1),
(23, 'Linha de Fuga', 'Uma cientista de dados se envolve em uma investigação proibida na periferia de São Paulo. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2023, '16', '2025-02-04', 'FILME', 'https://trailer.streaming.com/linha-de-fuga', 1),
(24, 'O Piano de Vidro', 'Um mecânico de bairro encontra uma carta nunca enviada no centro histórico de Salvador. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2016, '10', '2024-01-18', 'FILME', 'https://trailer.streaming.com/o-piano-de-vidro', 1),
(25, 'Caçadores de Tempestade', 'Uma adolescente prodígio recebe uma ligação anônima no sertão da Paraíba. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2021, '12', '2024-02-04', 'FILME', 'https://trailer.streaming.com/cacadores-de-tempestade', 1),
(26, 'A Última Carta', 'Um cozinheiro famoso encontra um diário escondido no interior de Minas Gerais. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2019, '10', '2024-02-21', 'FILME', 'https://trailer.streaming.com/a-ultima-carta', 1),
(27, 'Império de Cinzas', 'Uma fotógrafa de guerra herda uma casa abandonada em uma pequena cidade do Paraná. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2022, '18', '2024-03-09', 'FILME', 'https://trailer.streaming.com/imperio-de-cinzas', 1),
(28, 'Pequeno Grande Mundo', 'Um professor de física aceita um trabalho fora do país em um bairro operário de Porto Alegre. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2023, 'L', '2024-03-26', 'FILME', 'https://trailer.streaming.com/pequeno-grande-mundo', 1),
(29, 'O Trem das Onze', 'Uma delegada assume um segredo de família em uma ilha do litoral norte. Para seguir em frente, precisa decidir de que lado da lei quer estar.', 2018, '12', '2024-04-12', 'FILME', 'https://trailer.streaming.com/o-trem-das-onze', 1),
(30, 'Além do Horizonte Azul', 'Uma professora de história descobre um arquivo confidencial no litoral de Santa Catarina. Para seguir em frente, precisa escolher entre a verdade e a lealdade à família.', 2025, '10', '2024-04-29', 'FILME', 'https://trailer.streaming.com/alem-do-horizonte-azul', 1),
(31, 'Distrito 9', 'Em Distrito 9, um músico fracassado encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2021, '16', '2024-01-18', 'SERIE', 'https://trailer.streaming.com/distrito-9', 1),
(32, 'Herdeiros do Amanhã', 'Em Herdeiros do Amanhã, uma advogada recém-formada aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2022, '14', '2024-01-31', 'SERIE', 'https://trailer.streaming.com/herdeiros-do-amanha', 1),
(33, 'Clínica Central', 'Em Clínica Central, um ex-soldado perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2020, '12', '2024-02-13', 'SERIE', 'https://trailer.streaming.com/clinica-central', 1),
(34, 'Códigos do Poder', 'Em Códigos do Poder, uma cientista de dados encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2023, '16', '2024-02-26', 'SERIE', 'https://trailer.streaming.com/codigos-do-poder', 1),
(35, 'Vila Nova', 'Em Vila Nova, um mecânico de bairro descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2019, '12', '2024-03-10', 'SERIE', 'https://trailer.streaming.com/vila-nova', 1),
(36, 'Além do Véu', 'Em Além do Véu, uma adolescente prodígio encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2024, '16', '2024-03-23', 'SERIE', 'https://trailer.streaming.com/alem-do-veu', 1),
(37, 'Cozinha de Família', 'Em Cozinha de Família, um cozinheiro famoso aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2021, 'L', '2024-04-05', 'SERIE', 'https://trailer.streaming.com/cozinha-de-familia', 1),
(38, 'Plantão 24h', 'Em Plantão 24h, uma fotógrafa de guerra perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2018, '14', '2024-04-18', 'SERIE', 'https://trailer.streaming.com/plantao-24h', 1),
(39, 'A Coroa de Espinhos', 'Em A Coroa de Espinhos, um professor de física encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2022, '18', '2024-05-01', 'SERIE', 'https://trailer.streaming.com/a-coroa-de-espinhos', 1),
(40, 'Mistério na Serra', 'Em Mistério na Serra, uma delegada descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2023, '14', '2024-05-14', 'SERIE', 'https://trailer.streaming.com/misterio-na-serra', 1),
(41, 'Turma do Bairro', 'Em Turma do Bairro, uma professora de história encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2020, 'L', '2024-05-27', 'SERIE', 'https://trailer.streaming.com/turma-do-bairro', 1),
(42, 'Império Digital', 'Em Império Digital, um detetive aposentado aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2024, '14', '2024-06-09', 'SERIE', 'https://trailer.streaming.com/imperio-digital', 1),
(43, 'Raízes', 'Em Raízes, uma enfermeira da periferia perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2019, '10', '2024-06-22', 'SERIE', 'https://trailer.streaming.com/raizes', 1),
(44, 'Fronteiras do Tempo', 'Em Fronteiras do Tempo, um piloto de testes encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2022, '14', '2024-07-05', 'SERIE', 'https://trailer.streaming.com/fronteiras-do-tempo', 1),
(45, 'O Clube da Rua Sete', 'Em O Clube da Rua Sete, uma jornalista investigativa descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2021, '12', '2024-07-18', 'SERIE', 'https://trailer.streaming.com/o-clube-da-rua-sete', 1),
(46, 'Maré de Paixão', 'Em Maré de Paixão, um músico fracassado encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2023, '12', '2024-07-31', 'SERIE', 'https://trailer.streaming.com/mare-de-paixao', 1),
(47, 'Caçada Noturna', 'Em Caçada Noturna, uma advogada recém-formada aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2024, '16', '2024-08-13', 'SERIE', 'https://trailer.streaming.com/cacada-noturna', 1),
(48, 'Vozes da Cidade', 'Em Vozes da Cidade, um ex-soldado perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2020, '14', '2024-08-26', 'SERIE', 'https://trailer.streaming.com/vozes-da-cidade', 1),
(49, 'Laboratório 7', 'Em Laboratório 7, uma cientista de dados encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2022, '12', '2024-09-08', 'SERIE', 'https://trailer.streaming.com/laboratorio-7', 1),
(50, 'A Grande Virada', 'Em A Grande Virada, um mecânico de bairro descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2021, '10', '2024-09-21', 'SERIE', 'https://trailer.streaming.com/a-grande-virada', 1),
(51, 'Sonhos de Verão', 'Em Sonhos de Verão, uma adolescente prodígio encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2019, '10', '2024-10-04', 'SERIE', 'https://trailer.streaming.com/sonhos-de-verao', 1),
(52, 'O Preço da Verdade', 'Em O Preço da Verdade, um cozinheiro famoso aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2023, '16', '2024-10-17', 'SERIE', 'https://trailer.streaming.com/o-preco-da-verdade', 1),
(53, 'Feras do Asfalto', 'Em Feras do Asfalto, uma fotógrafa de guerra perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2022, '16', '2024-10-30', 'SERIE', 'https://trailer.streaming.com/feras-do-asfalto', 1),
(54, 'Ilha das Sombras', 'Em Ilha das Sombras, um professor de física encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2024, '18', '2024-11-12', 'SERIE', 'https://trailer.streaming.com/ilha-das-sombras', 1),
(55, 'Riso de Novela', 'Em Riso de Novela, uma delegada descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2018, '12', '2024-11-25', 'SERIE', 'https://trailer.streaming.com/riso-de-novela', 1),
(56, 'Projeto Ícaro', 'Em Projeto Ícaro, uma professora de história encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.', 2025, '14', '2024-12-08', 'SERIE', 'https://trailer.streaming.com/projeto-icaro', 1),
(57, 'Cozinha Selvagem', 'Em Cozinha Selvagem, um detetive aposentado aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.', 2021, 'L', '2024-12-21', 'SERIE', 'https://trailer.streaming.com/cozinha-selvagem', 1),
(58, 'A Sétima Porta', 'Em A Sétima Porta, uma enfermeira da periferia perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.', 2023, '16', '2025-01-03', 'SERIE', 'https://trailer.streaming.com/a-setima-porta', 1),
(59, 'Geração Z', 'Em Geração Z, um piloto de testes encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.', 2022, '12', '2025-01-16', 'SERIE', 'https://trailer.streaming.com/geracao-z', 1),
(60, 'Última Temporada', 'Em Última Temporada, uma jornalista investigativa descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.', 2024, '14', '2025-01-29', 'SERIE', 'https://trailer.streaming.com/ultima-temporada', 1);

-- ---------------------------------------------------------------------
-- 2.6 FILME — 30 filmes
-- ---------------------------------------------------------------------
INSERT INTO FILME (CODIGO, DURACAO_MINUTOS, DIRETOR, ORCAMENTO, BILHETERIA, DATA_ESTREIA_CINEMA, RESOLUCAO_MAXIMA, IDIOMA_ORIGINAL, POSSUI_LEGENDA_PT) VALUES
(1,  95,  'Helena Vasconcelos', 5200000.00,  9360000.00,   '2023-02-04', 'HD',      'Inglês',    1),
(2,  102, 'Rogério Bastos',     8900000.00,  27590000.00,  '2022-03-07', 'FULL_HD', 'Espanhol',  1),
(3,  109, 'Marcelo Tavares',    12600000.00, 17640000.00,  '2021-04-10', '4K',      'Francês',   1),
(4,  116, 'Juliana Prado',      16300000.00, 44010000.00,  '2024-05-13', 'SD',      'Coreano',   1),
(5,  123, 'Fernando Aguiar',    20000000.00, 20000000.00,  '2020-06-16', 'HD',      'Japonês',   0),
(6,  130, 'Patrícia Lemos',     23700000.00, 54510000.00,  NULL,         'FULL_HD', 'Português', 1),
(7,  137, 'Caio Bertoldo',      27400000.00, 16440000.00,  '2023-08-22', '4K',      'Inglês',    1),
(8,  144, 'Sônia Marques',      31100000.00, 59090000.00,  '2018-09-25', 'SD',      'Espanhol',  1),
(9,  151, 'Ricardo Sampaio',    34800000.00, 111360000.00, '2022-10-28', 'HD',      'Francês',   1),
(10, 88,  'Beatriz Coelho',     38500000.00, 57750000.00,  '2021-11-03', 'FULL_HD', 'Coreano',   0),
(11, 95,  'Gustavo Pires',      42200000.00, 118160000.00, '2024-12-06', '4K',      'Japonês',   1),
(12, 102, 'Lúcia Andrade',      45900000.00, 50490000.00,  NULL,         'SD',      'Português', 1),
(13, 109, 'Thiago Menezes',     49600000.00, 119040000.00, '2023-02-12', 'HD',      'Inglês',    1),
(14, 116, 'André Sobral',       53300000.00, 37310000.00,  '2022-03-15', 'FULL_HD', 'Espanhol',  1),
(15, 123, 'Camila Rezende',     57000000.00, 114000000.00, '2025-04-18', '4K',      'Francês',   0),
(16, 130, 'Eduardo Nogueira',   60700000.00, 200310000.00, '2020-05-21', 'SD',      'Coreano',   1),
(17, 137, 'Marina Duarte',      64400000.00, 103040000.00, '2019-06-24', 'HD',      'Japonês',   1),
(18, 144, 'Paulo Rangel',       68100000.00, 197490000.00, NULL,         'FULL_HD', 'Português', 1),
(19, 151, 'Vera Lúcia Fontes',  71800000.00, 86160000.00,  '2018-08-02', '4K',      'Inglês',    1),
(20, 88,  'Bruno Sá',           75500000.00, 188750000.00, '2024-09-05', 'SD',      'Espanhol',  0),
(21, 95,  'Clara Bittencourt',  79200000.00, 63360000.00,  '2022-10-08', 'HD',      'Francês',   1),
(22, 102, 'Igor Mascarenhas',   82900000.00, 174090000.00, '2020-11-11', 'FULL_HD', 'Coreano',   1),
(23, 109, 'Renata Falcão',      86600000.00, 294440000.00, '2023-12-14', '4K',      'Japonês',   1),
(24, 116, 'Otávio Lins',        90300000.00, 153510000.00, NULL,         'SD',      'Português', 1),
(25, 123, 'Débora Campos',      4000000.00,  12000000.00,  '2021-02-20', 'HD',      'Inglês',    0),
(26, 130, 'Sérgio Vasques',     7700000.00,  10010000.00,  '2019-03-23', 'FULL_HD', 'Espanhol',  1),
(27, 137, 'Mônica Assis',       11400000.00, 29640000.00,  '2022-04-26', '4K',      'Francês',   1),
(28, 144, 'Vinícius Rocha',     15100000.00, 13590000.00,  '2023-05-01', 'SD',      'Coreano',   1),
(29, 151, 'Heloísa Prado',      18800000.00, 41360000.00,  '2018-06-04', 'HD',      'Japonês',   1),
(30, 88,  'Alexandre Mota',     22500000.00, 11250000.00,  NULL,         'FULL_HD', 'Português', 0);

-- ---------------------------------------------------------------------
-- 2.7 SERIE — 30 séries
-- ---------------------------------------------------------------------
INSERT INTO SERIE (CODIGO, DATA_PRIMEIRA_EXIBICAO, EMISSORA_ORIGINAL, PAIS_ORIGEM, STATUS_PRODUCAO, CRIADOR) VALUES
(31, '2021-02-06', 'Stream Max',   'Estados Unidos', 'FINALIZADA',   'Fábio Nascimento'),
(32, '2022-03-11', 'TV Vale',      'Reino Unido',    'FINALIZADA',   'Lorena Vieira'),
(33, '2020-04-16', 'Rede Litoral', 'Coreia do Sul',  'FINALIZADA',   'Marta Siqueira'),
(34, '2023-05-21', 'Cine Brasil',  'Espanha',        'EM_ANDAMENTO', 'Rafael Bandeira'),
(35, '2019-06-26', 'Play Séries',  'Argentina',      'FINALIZADA',   'Tânia Rocha'),
(36, '2024-07-04', 'Canal Aurora', 'Brasil',         'EM_ANDAMENTO', 'César Azevedo'),
(37, '2021-08-09', 'Stream Max',   'Estados Unidos', 'FINALIZADA',   'Bianca Ferraz'),
(38, '2018-09-14', 'TV Vale',      'Reino Unido',    'FINALIZADA',   'Diego Matos'),
(39, '2022-10-19', 'Rede Litoral', 'Coreia do Sul',  'FINALIZADA',   'Elisa Monteiro'),
(40, '2023-11-24', 'Cine Brasil',  'Espanha',        'EM_ANDAMENTO', 'Nelson Guaraci'),
(41, '2020-12-02', 'Play Séries',  'Argentina',      'FINALIZADA',   'Sandra Kimura'),
(42, '2024-01-07', 'Canal Aurora', 'Brasil',         'EM_ANDAMENTO', 'Leandro Prado'),
(43, '2019-02-12', 'Stream Max',   'Estados Unidos', 'FINALIZADA',   'Aline Tupã'),
(44, '2022-03-17', 'TV Vale',      'Reino Unido',    'FINALIZADA',   'Mauro César Lima'),
(45, '2021-04-22', 'Rede Litoral', 'Coreia do Sul',  'FINALIZADA',   'Joana Freire'),
(46, '2023-05-27', 'Cine Brasil',  'Espanha',        'EM_ANDAMENTO', 'Roberta Sales'),
(47, '2024-06-05', 'Play Séries',  'Argentina',      'EM_ANDAMENTO', 'Ivan Torres'),
(48, '2020-07-10', 'Canal Aurora', 'Brasil',         'FINALIZADA',   'Kátia Nunes'),
(49, '2022-08-15', 'Stream Max',   'Estados Unidos', 'FINALIZADA',   'Otávio Galvão'),
(50, '2021-09-20', 'TV Vale',      'Reino Unido',    'FINALIZADA',   'Suely Braga'),
(51, '2019-10-25', 'Rede Litoral', 'Coreia do Sul',  'FINALIZADA',   'Pedro Alcântara'),
(52, '2023-11-03', 'Cine Brasil',  'Espanha',        'EM_ANDAMENTO', 'Mirela Castro'),
(53, '2022-12-08', 'Play Séries',  'Argentina',      'FINALIZADA',   'Jonas Ribeiro'),
(54, '2024-01-13', 'Canal Aurora', 'Brasil',         'EM_ANDAMENTO', 'Cláudia Vasques'),
(55, '2018-02-18', 'Stream Max',   'Estados Unidos', 'FINALIZADA',   'Zeca Portela'),
(56, '2025-03-23', 'TV Vale',      'Reino Unido',    'EM_ANDAMENTO', 'Larissa Fontes'),
(57, '2021-04-01', 'Rede Litoral', 'Coreia do Sul',  'FINALIZADA',   'Mateus Barreto'),
(58, '2023-05-06', 'Cine Brasil',  'Espanha',        'EM_ANDAMENTO', 'Renan Duarte'),
(59, '2022-06-11', 'Play Séries',  'Argentina',      'FINALIZADA',   'Cibele Andrade'),
(60, '2024-07-16', 'Canal Aurora', 'Brasil',         'EM_ANDAMENTO', 'Alexandre Pimentel');

-- ---------------------------------------------------------------------
-- 2.8 EPISODIO — 30 episódios
-- ---------------------------------------------------------------------
INSERT INTO EPISODIO (CODIGO, CODIGO_SERIE, TITULO_EPISODIO, NUMERO_TEMPORADA, NUMERO_EPISODIO, DURACAO_MINUTO, DATA_EXIBICAO, SINOPSE) VALUES
(1, 31, 'Distrito 9 — Piloto', 1, 1, 43, '2021-02-13', 'Em Distrito 9, um músico fracassado encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(2, 32, 'Herdeiros do Amanhã — Primeiras Pistas', 1, 1, 46, '2022-03-18', 'Em Herdeiros do Amanhã, uma advogada recém-formada aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.'),
(3, 33, 'Clínica Central — A Porta Fechada', 1, 1, 49, '2020-04-23', 'Em Clínica Central, um ex-soldado perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(4, 34, 'Códigos do Poder — Noites em Claro', 1, 1, 52, '2023-05-28', 'Em Códigos do Poder, uma cientista de dados encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(5, 35, 'Vila Nova — O Acordo', 1, 1, 55, '2019-07-03', 'Em Vila Nova, um mecânico de bairro descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(6, 36, 'Além do Véu — Fuga', 1, 1, 22, '2024-07-11', 'Em Além do Véu, uma adolescente prodígio encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(7, 37, 'Cozinha de Família — Sem Sinal', 1, 1, 25, '2021-08-16', 'Em Cozinha de Família, um cozinheiro famoso aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.'),
(8, 38, 'Plantão 24h — A Testemunha', 1, 1, 28, '2018-09-21', 'Em Plantão 24h, uma fotógrafa de guerra perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(9, 39, 'A Coroa de Espinhos — Linha Cruzada', 1, 1, 31, '2022-10-26', 'Em A Coroa de Espinhos, um professor de física encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(10, 40, 'Mistério na Serra — O Retorno', 1, 1, 34, '2023-12-01', 'Em Mistério na Serra, uma delegada descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(11, 41, 'Turma do Bairro — Águas Turvas', 1, 1, 37, '2020-12-09', 'Em Turma do Bairro, uma professora de história encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(12, 42, 'Império Digital — Ponto de Ruptura', 1, 1, 40, '2024-01-14', 'Em Império Digital, um detetive aposentado aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.'),
(13, 43, 'Raízes — A Última Chamada', 1, 1, 43, '2019-02-19', 'Em Raízes, uma enfermeira da periferia perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(14, 44, 'Fronteiras do Tempo — Vozes', 1, 1, 46, '2022-03-24', 'Em Fronteiras do Tempo, um piloto de testes encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(15, 45, 'O Clube da Rua Sete — O Preço', 1, 1, 49, '2021-04-29', 'Em O Clube da Rua Sete, uma jornalista investigativa descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(16, 46, 'Maré de Paixão — Herança', 1, 1, 52, '2023-06-03', 'Em Maré de Paixão, um músico fracassado encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(17, 47, 'Caçada Noturna — Desvio', 1, 1, 55, '2024-06-12', 'Em Caçada Noturna, uma advogada recém-formada aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.'),
(18, 48, 'Vozes da Cidade — A Queda', 1, 1, 22, '2020-07-17', 'Em Vozes da Cidade, um ex-soldado perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(19, 49, 'Laboratório 7 — Reencontro', 1, 1, 25, '2022-08-22', 'Em Laboratório 7, uma cientista de dados encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(20, 50, 'A Grande Virada — Silêncio', 1, 1, 28, '2021-09-27', 'Em A Grande Virada, um mecânico de bairro descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(21, 31, 'Distrito 9 — O Mapa', 1, 2, 33, '2021-02-20', 'Em Distrito 9, um ex-soldado perde a memória após um acidente na periferia de São Paulo e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(22, 32, 'Herdeiros do Amanhã — Tempestade', 1, 2, 38, '2022-03-25', 'Em Herdeiros do Amanhã, uma cientista de dados encontra um diário escondido na fronteira com o Uruguai e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(23, 33, 'Clínica Central — Confissão', 1, 2, 43, '2020-04-30', 'Em Clínica Central, um mecânico de bairro descobre um arquivo confidencial na Serra do Mar e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(24, 34, 'Códigos do Poder — A Troca', 1, 2, 48, '2023-06-04', 'Em Códigos do Poder, uma adolescente prodígio encontra uma carta nunca enviada no litoral de Santa Catarina e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(25, 35, 'Vila Nova — Fim de Linha', 1, 2, 53, '2019-07-10', 'Em Vila Nova, um cozinheiro famoso aceita um trabalho fora do país em uma ilha do litoral norte e, a cada episódio, precisa assumir as consequências de uma escolha antiga.'),
(26, 36, 'Além do Véu — O Julgamento', 1, 2, 22, '2024-07-18', 'Em Além do Véu, uma fotógrafa de guerra perde a memória após um acidente em um bairro operário de Porto Alegre e, a cada episódio, precisa proteger quem ama sem perder a própria identidade.'),
(27, 37, 'Cozinha de Família — Sob Suspeita', 1, 2, 27, '2021-08-23', 'Em Cozinha de Família, um professor de física encontra um diário escondido em uma pequena cidade do Paraná e, a cada episódio, precisa abrir mão do sucesso para salvar um amigo.'),
(28, 38, 'Plantão 24h — Contagem Regressiva', 1, 2, 32, '2018-09-28', 'Em Plantão 24h, uma delegada descobre um arquivo confidencial no interior de Minas Gerais e, a cada episódio, precisa revelar o que sabe antes que seja tarde.'),
(29, 39, 'A Coroa de Espinhos — O Abismo', 1, 2, 37, '2022-11-02', 'Em A Coroa de Espinhos, uma professora de história encontra uma carta nunca enviada no sertão da Paraíba e, a cada episódio, precisa decidir de que lado da lei quer estar.'),
(30, 40, 'Mistério na Serra — Depois do Fim', 1, 2, 42, '2023-12-08', 'Em Mistério na Serra, um detetive aposentado aceita um trabalho fora do país no centro histórico de Salvador e, a cada episódio, precisa assumir as consequências de uma escolha antiga.');

-- ---------------------------------------------------------------------
-- 2.9 CONTEUDO_GENERO — 30 vínculos conteúdo x gênero
-- ---------------------------------------------------------------------
INSERT INTO CONTEUDO_GENERO (CODIGO_CONTEUDO, CODIGO_GENERO, PRINCIPAL, PESO_RELEVANCIA, DATA_VINCULACAO, OBSERVACAO, ATIVO) VALUES
(1,  6,  0, 0.67, '2024-02-12', 'Tema secundário explorado na trama.',                1),
(2,  11, 0, 0.74, '2024-02-23', 'Classificação definida pela curadoria do catálogo.', 1),
(3,  16, 1, 0.81, '2024-03-05', 'Gênero associado ao público adulto.',                1),
(4,  21, 0, 0.88, '2024-03-16', 'Gênero complementar para recomendações.',            1),
(5,  26, 0, 0.95, '2024-03-27', 'Componente central da sinopse.',                     1),
(6,  1,  1, 0.62, '2024-04-07', 'Gênero principal da obra.',                          1),
(7,  6,  0, 0.69, '2024-04-18', 'Tema secundário explorado na trama.',                1),
(8,  11, 0, 0.76, '2024-04-29', 'Classificação definida pela curadoria do catálogo.', 1),
(9,  16, 1, 0.83, '2024-05-10', 'Gênero associado ao público adulto.',                1),
(10, 21, 0, 0.90, '2024-05-21', 'Gênero complementar para recomendações.',            1),
(11, 26, 0, 0.97, '2024-06-01', 'Componente central da sinopse.',                     1),
(12, 1,  1, 0.64, '2024-06-12', 'Gênero principal da obra.',                          1),
(13, 6,  0, 0.71, '2024-06-23', 'Tema secundário explorado na trama.',                1),
(14, 11, 0, 0.78, '2024-07-04', 'Classificação definida pela curadoria do catálogo.', 1),
(15, 16, 1, 0.85, '2024-07-15', 'Gênero associado ao público adulto.',                1),
(16, 21, 0, 0.92, '2024-07-26', 'Gênero complementar para recomendações.',            1),
(17, 26, 0, 0.99, '2024-08-06', 'Componente central da sinopse.',                     1),
(18, 1,  1, 0.66, '2024-08-17', 'Gênero principal da obra.',                          1),
(19, 6,  0, 0.73, '2024-08-28', 'Tema secundário explorado na trama.',                1),
(20, 11, 0, 0.80, '2024-09-08', 'Classificação definida pela curadoria do catálogo.', 1),
(51, 16, 1, 0.87, '2024-09-19', 'Gênero associado ao público adulto.',                1),
(52, 21, 0, 0.94, '2024-09-30', 'Gênero complementar para recomendações.',            1),
(53, 26, 0, 0.61, '2024-10-11', 'Componente central da sinopse.',                     1),
(54, 1,  1, 0.68, '2024-10-22', 'Gênero principal da obra.',                          1),
(55, 6,  0, 0.75, '2024-11-02', 'Tema secundário explorado na trama.',                1),
(56, 11, 0, 0.82, '2024-11-13', 'Classificação definida pela curadoria do catálogo.', 1),
(57, 16, 1, 0.89, '2024-11-24', 'Gênero associado ao público adulto.',                1),
(58, 21, 0, 0.96, '2024-02-09', 'Gênero complementar para recomendações.',            1),
(59, 26, 0, 0.63, '2024-02-20', 'Componente central da sinopse.',                     1),
(60, 1,  1, 0.70, '2024-03-02', 'Gênero principal da obra.',                          1);

-- ---------------------------------------------------------------------
-- 2.10 PERFIL — 30 perfis de usuário
-- ---------------------------------------------------------------------
INSERT INTO PERFIL (CODIGO, CODIGO_USUARIO, NOME_PERFIL, TIPO_PERFIL, CLASSIFICACAO_ETARIA_MAX, IDIOMA_PREFERIDO, DATA_CRIACAO, ATIVO) VALUES
(1,  1,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-01-01 08:30:00', 1),
(2,  2,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-01-08 08:30:00', 1),
(3,  3,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-01-15 08:30:00', 1),
(4,  4,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-01-22 08:30:00', 1),
(5,  5,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-01-29 08:30:00', 1),
(6,  6,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-02-05 08:30:00', 1),
(7,  7,  'Principal', 'ADULTO',   '18', 'en-US', '2025-02-12 08:30:00', 1),
(8,  8,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-02-19 08:30:00', 1),
(9,  9,  'Principal', 'ADULTO',   '18', 'pt-BR', '2025-02-26 08:30:00', 1),
(10, 10, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-03-05 08:30:00', 1),
(11, 11, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-03-12 08:30:00', 1),
(12, 12, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-03-19 08:30:00', 1),
(13, 13, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-03-26 08:30:00', 1),
(14, 14, 'Principal', 'ADULTO',   '18', 'en-US', '2025-04-02 08:30:00', 1),
(15, 15, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-04-09 08:30:00', 1),
(16, 16, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-04-16 08:30:00', 1),
(17, 17, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-04-23 08:30:00', 1),
(18, 18, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-04-30 08:30:00', 1),
(19, 19, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-05-07 08:30:00', 1),
(20, 20, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-05-14 08:30:00', 1),
(21, 21, 'Principal', 'ADULTO',   '18', 'en-US', '2025-05-21 08:30:00', 1),
(22, 22, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-05-28 08:30:00', 1),
(23, 23, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-06-04 08:30:00', 1),
(24, 24, 'Principal', 'ADULTO',   '18', 'pt-BR', '2025-06-11 08:30:00', 1),
(25, 1,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-01-01 08:30:00', 1),
(26, 2,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-01-08 08:30:00', 1),
(27, 3,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-01-15 08:30:00', 1),
(28, 4,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-01-22 08:30:00', 1),
(29, 5,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-01-29 08:30:00', 1),
(30, 6,  'Infantil',  'INFANTIL', '10', 'pt-BR', '2025-02-05 08:30:00', 1);

-- ---------------------------------------------------------------------
-- 2.11 DISPOSITIVO — 30 dispositivos cadastrados
-- ---------------------------------------------------------------------
INSERT INTO DISPOSITIVO (CODIGO, CODIGO_USUARIO, TIPO_DISPOSITIVO, MODELO, SISTEMA_OPERACIONAL, DATA_ULTIMO_ACESSO, ATIVO) VALUES
(1,  1,  'SMART_TV',      'Dell Inspiron 15', 'Android',        '2025-08-06 21:00:00', 1),
(2,  2,  'CELULAR',       'LG OLED C2',       'PlayStation OS', '2025-08-11 22:00:00', 1),
(3,  3,  'TABLET',        'Lenovo IdeaPad 3', 'webOS',          '2025-08-16 23:00:00', 1),
(4,  4,  'NOTEBOOK',      'Samsung Q60',      'iOS',            '2025-08-22 00:00:00', 1),
(5,  5,  'CONSOLE',       'Dell Inspiron 15', 'Windows 11',     '2025-08-27 01:00:00', 1),
(6,  6,  'STREAMING_BOX', 'LG OLED C2',       'Android TV',     '2025-09-01 02:00:00', 1),
(7,  7,  'SMART_TV',      'Lenovo IdeaPad 3', 'Tizen',          '2025-09-06 03:00:00', 1),
(8,  8,  'CELULAR',       'Samsung Q60',      'Android',        '2025-09-11 04:00:00', 1),
(9,  9,  'TABLET',        'Dell Inspiron 15', 'PlayStation OS', '2025-09-16 05:00:00', 1),
(10, 10, 'NOTEBOOK',      'LG OLED C2',       'webOS',          '2025-09-21 06:00:00', 1),
(11, 11, 'CONSOLE',       'Lenovo IdeaPad 3', 'iOS',            '2025-09-26 07:00:00', 1),
(12, 12, 'STREAMING_BOX', 'Samsung Q60',      'Windows 11',     '2025-09-30 20:00:00', 1),
(13, 13, 'SMART_TV',      'Dell Inspiron 15', 'Android TV',     '2025-10-05 21:00:00', 0),
(14, 14, 'CELULAR',       'LG OLED C2',       'Tizen',          '2025-10-10 22:00:00', 1),
(15, 15, 'TABLET',        'Lenovo IdeaPad 3', 'Android',        '2025-10-15 23:00:00', 1),
(16, 16, 'NOTEBOOK',      'Samsung Q60',      'PlayStation OS', '2025-10-21 00:00:00', 1),
(17, 17, 'CONSOLE',       'Dell Inspiron 15', 'webOS',          '2025-10-26 01:00:00', 1),
(18, 18, 'STREAMING_BOX', 'LG OLED C2',       'iOS',            '2025-08-02 02:00:00', 1),
(19, 19, 'SMART_TV',      'Lenovo IdeaPad 3', 'Windows 11',     '2025-08-07 03:00:00', 1),
(20, 20, 'CELULAR',       'Samsung Q60',      'Android TV',     '2025-08-12 04:00:00', 1),
(21, 21, 'TABLET',        'Dell Inspiron 15', 'Tizen',          '2025-08-17 05:00:00', 1),
(22, 22, 'NOTEBOOK',      'LG OLED C2',       'Android',        '2025-08-22 06:00:00', 1),
(23, 23, 'CONSOLE',       'Lenovo IdeaPad 3', 'PlayStation OS', '2025-08-27 07:00:00', 1),
(24, 24, 'STREAMING_BOX', 'Samsung Q60',      'webOS',          '2025-08-31 20:00:00', 1),
(25, 25, 'SMART_TV',      'Dell Inspiron 15', 'iOS',            '2025-09-05 21:00:00', 1),
(26, 26, 'CELULAR',       'LG OLED C2',       'Windows 11',     '2025-09-10 22:00:00', 0),
(27, 27, 'TABLET',        'Lenovo IdeaPad 3', 'Android TV',     '2025-09-15 23:00:00', 1),
(28, 28, 'NOTEBOOK',      'Samsung Q60',      'Tizen',          '2025-09-21 00:00:00', 1),
(29, 29, 'CONSOLE',       'Dell Inspiron 15', 'Android',        '2025-09-26 01:00:00', 1),
(30, 30, 'STREAMING_BOX', 'LG OLED C2',       'PlayStation OS', '2025-10-01 02:00:00', 1);

-- ---------------------------------------------------------------------
-- 2.12 FORMA_PAGAMENTO — 30 formas de pagamento
-- ---------------------------------------------------------------------
INSERT INTO FORMA_PAGAMENTO (CODIGO, CODIGO_USUARIO, TIPO_PAGAMENTO, NOME_TITULAR, ULTIMOS_DIGITOS, BANDEIRA, DATA_VALIDADE, STATUS, DATA_CADASTRO) VALUES
(1,  1,  'CARTAO_CREDITO', 'Ana Beatriz Ferreira',   '1137', 'Visa',             '2028-02-01', 1, '2025-01-01 10:03:00'),
(2,  2,  'PIX',            'Bruno Carvalho Lima',    NULL,   NULL,               NULL,         1, '2025-01-08 10:06:00'),
(3,  3,  'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-01-15 10:09:00'),
(4,  4,  'CARTAO_CREDITO', 'Daniel Oliveira Ramos',  '1548', 'American Express', '2028-05-01', 1, '2025-01-22 10:12:00'),
(5,  5,  'PIX',            'Eduarda Santos Prado',   NULL,   NULL,               NULL,         1, '2025-01-29 10:15:00'),
(6,  6,  'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-02-05 10:18:00'),
(7,  7,  'CARTAO_CREDITO', 'Gabriela Almeida Reis',  '1959', 'Elo',              '2028-08-01', 1, '2025-02-12 10:21:00'),
(8,  8,  'PIX',            'Henrique Barbosa Pinto', NULL,   NULL,               NULL,         1, '2025-02-19 10:24:00'),
(9,  9,  'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-02-26 10:27:00'),
(10, 10, 'CARTAO_CREDITO', 'João Pedro Martins',     '2370', 'Mastercard',       '2028-11-01', 1, '2025-03-05 10:30:00'),
(11, 11, 'PIX',            'Karina Duarte Freitas',  NULL,   NULL,               NULL,         0, '2025-03-12 10:33:00'),
(12, 12, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-03-19 10:36:00'),
(13, 13, 'CARTAO_CREDITO', 'Mariana Teixeira Lopes', '2781', 'Visa',             '2028-02-01', 1, '2025-03-26 10:39:00'),
(14, 14, 'PIX',            'Nathan Ribeiro Alves',   NULL,   NULL,               NULL,         1, '2025-04-02 10:42:00'),
(15, 15, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-04-09 10:45:00'),
(16, 16, 'CARTAO_CREDITO', 'Paulo Sérgio Andrade',   '3192', 'American Express', '2028-05-01', 1, '2025-04-16 10:48:00'),
(17, 17, 'PIX',            'Queila Monteiro Dias',   NULL,   NULL,               NULL,         1, '2025-04-23 10:51:00'),
(18, 18, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-04-30 10:54:00'),
(19, 19, 'CARTAO_CREDITO', 'Sabrina Fonseca Melo',   '3603', 'Elo',              '2028-08-01', 1, '2025-05-07 10:57:00'),
(20, 20, 'PIX',            'Thiago Araújo Bezerra',  NULL,   NULL,               NULL,         1, '2025-05-14 10:00:00'),
(21, 21, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-05-21 10:03:00'),
(22, 22, 'CARTAO_CREDITO', 'Vinícius Braga Farias',  '4014', 'Mastercard',       '2028-11-01', 0, '2025-05-28 10:06:00'),
(23, 23, 'PIX',            'Wesley Tavares Cunha',   NULL,   NULL,               NULL,         1, '2025-06-04 10:09:00'),
(24, 24, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-06-11 10:12:00'),
(25, 25, 'CARTAO_CREDITO', 'Yasmin Fontes Barros',   '4425', 'Visa',             '2028-02-01', 1, '2025-06-18 10:15:00'),
(26, 26, 'PIX',            'Zélia Queiroz Sampaio',  NULL,   NULL,               NULL,         1, '2025-06-25 10:18:00'),
(27, 27, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-07-02 10:21:00'),
(28, 28, 'CARTAO_CREDITO', 'Bianca Salgado Torres',  '4836', 'American Express', '2028-05-01', 1, '2025-07-09 10:24:00'),
(29, 29, 'PIX',            'Caio Emanuel Furtado',   NULL,   NULL,               NULL,         1, '2025-07-16 10:27:00'),
(30, 30, 'BOLETO',         NULL,                     NULL,   NULL,               NULL,         1, '2025-07-23 10:30:00');

-- ---------------------------------------------------------------------
-- 2.13 PAGAMENTO — 30 cobranças
-- ---------------------------------------------------------------------
INSERT INTO PAGAMENTO (CODIGO, CODIGO_FORMA_PAGAMENTO, DATA_PAGAMENTO, DATA_VENCIMENTO, VALOR, STATUS_PAGAMENTO, CODIGO_TRANSACAO) VALUES
(1,  1,  '2025-02-04 00:00:00', '2025-02-05', 19.90,  'APROVADO',  'TX-2025-00001-709B55'),
(2,  2,  '2025-02-15 00:00:00', '2025-02-16', 199.90, 'APROVADO',  'TX-2025-00002-27CA64'),
(3,  3,  '2025-02-26 00:00:00', '2025-02-27', 29.90,  'APROVADO',  'TX-2025-00003-1F3CB1'),
(4,  4,  NULL,                  '2025-03-10', 299.90, 'PENDENTE',  'TX-2025-00004-41B637'),
(5,  5,  '2025-03-20 00:00:00', '2025-03-21', 39.90,  'APROVADO',  'TX-2025-00005-A8C0CC'),
(6,  6,  '2025-03-31 00:00:00', '2025-04-01', 399.90, 'APROVADO',  'TX-2025-00006-D20A62'),
(7,  7,  '2025-04-12 00:00:00', '2025-04-12', 54.90,  'RECUSADO',  'TX-2025-00007-281B9D'),
(8,  8,  NULL,                  '2025-04-23', 549.90, 'PENDENTE',  'TX-2025-00008-DF743D'),
(9,  9,  '2025-05-03 00:00:00', '2025-05-04', 64.90,  'APROVADO',  'TX-2025-00009-3E812F'),
(10, 10, '2025-05-14 00:00:00', '2025-05-15', 649.90, 'APROVADO',  'TX-2025-00010-3EBC2B'),
(11, 11, '2025-05-25 00:00:00', '2025-05-26', 14.90,  'APROVADO',  'TX-2025-00011-9789F4'),
(12, 12, NULL,                  '2025-06-06', 149.90, 'PENDENTE',  'TX-2025-00012-AEFE99'),
(13, 13, '2025-06-16 00:00:00', '2025-06-17', 79.90,  'ESTORNADO', 'TX-2025-00013-64F662'),
(14, 14, '2025-06-28 00:00:00', '2025-06-28', 149.90, 'RECUSADO',  'TX-2025-00014-95A738'),
(15, 15, '2025-07-08 00:00:00', '2025-07-09', 149.90, 'APROVADO',  'TX-2025-00015-315987'),
(16, 16, NULL,                  '2025-07-20', 289.90, 'PENDENTE',  'TX-2025-00016-09CAA1'),
(17, 17, '2025-07-30 00:00:00', '2025-07-31', 12.90,  'APROVADO',  'TX-2025-00017-9D04D5'),
(18, 18, '2025-08-10 00:00:00', '2025-08-11', 129.90, 'APROVADO',  'TX-2025-00018-AB8A58'),
(19, 19, '2025-08-21 00:00:00', '2025-08-22', 34.90,  'APROVADO',  'TX-2025-00019-C7C3F1'),
(20, 20, NULL,                  '2025-09-02', 349.90, 'PENDENTE',  'TX-2025-00020-27EF2E'),
(21, 21, '2025-09-13 00:00:00', '2025-09-13', 0.00,   'RECUSADO',  'TX-2025-00021-8A0DBD'),
(22, 22, '2025-09-23 00:00:00', '2025-09-24', 0.00,   'APROVADO',  'TX-2025-00022-C68A30'),
(23, 23, '2025-10-04 00:00:00', '2025-10-05', 9.90,   'APROVADO',  'TX-2025-00023-2FAA40'),
(24, 24, NULL,                  '2025-10-16', 24.90,  'PENDENTE',  'TX-2025-00024-AE4BFA'),
(25, 25, '2025-10-26 00:00:00', '2025-10-27', 249.90, 'APROVADO',  'TX-2025-00025-15B032'),
(26, 26, '2025-11-06 00:00:00', '2025-11-07', 44.90,  'ESTORNADO', 'TX-2025-00026-79CE34'),
(27, 27, '2025-11-17 00:00:00', '2025-11-18', 449.90, 'APROVADO',  'TX-2025-00027-291790'),
(28, 28, NULL,                  '2025-11-29', 17.90,  'PENDENTE',  'TX-2025-00028-3AE666'),
(29, 29, '2025-12-09 00:00:00', '2025-12-10', 179.90, 'APROVADO',  'TX-2025-00029-20B635'),
(30, 30, '2025-12-20 00:00:00', '2025-12-21', 89.90,  'APROVADO',  'TX-2025-00030-AB199C');

-- ---------------------------------------------------------------------
-- 2.14 HISTORICO_VISUALIZACAO — 30 exibições registradas
-- ---------------------------------------------------------------------
INSERT INTO HISTORICO_VISUALIZACAO (CODIGO, CODIGO_PERFIL, CODIGO_CONTEUDO, DATA_HORA_INICIO, DATA_HORA_FIM, TEMPO_ASSISTIDO_SEG, PERCENTUAL_PROGRESSO, CONCLUIDO, ORIGEM_ACESSO) VALUES
(1,  1,  1,  '2025-03-02 20:00:00', '2025-03-02 20:11:15', 675,  12.50,  0, 'SMART_TV'),
(2,  2,  2,  '2025-03-03 21:00:00', '2025-03-03 21:43:11', 2591, 48.00,  0, 'CELULAR'),
(3,  3,  3,  '2025-03-04 22:00:00', '2025-03-04 23:30:00', 5400, 100.00, 1, 'TABLET'),
(4,  4,  4,  '2025-03-05 23:00:00', '2025-03-06 00:08:51', 4131, 76.50,  0, 'NOTEBOOK'),
(5,  5,  5,  '2025-03-06 19:00:00', '2025-03-06 19:29:42', 1782, 33.00,  0, 'WEB'),
(6,  6,  6,  '2025-03-07 20:00:00', '2025-03-07 21:22:48', 4968, 92.00,  0, 'SMART_TV'),
(7,  7,  7,  '2025-03-08 21:00:00', NULL,                  270,  5.00,   0, 'CELULAR'),
(8,  8,  8,  '2025-03-09 22:00:00', '2025-03-09 22:54:54', 3294, 61.00,  0, 'TABLET'),
(9,  9,  9,  '2025-03-10 23:00:00', '2025-03-11 00:30:00', 5400, 100.00, 1, 'NOTEBOOK'),
(10, 10, 10, '2025-03-11 19:00:00', '2025-03-11 19:21:35', 1295, 24.00,  0, 'WEB'),
(11, 11, 11, '2025-03-12 20:00:00', '2025-03-12 20:11:15', 675,  12.50,  0, 'SMART_TV'),
(12, 12, 12, '2025-03-13 21:00:00', '2025-03-13 21:43:11', 2591, 48.00,  0, 'CELULAR'),
(13, 13, 13, '2025-03-14 22:00:00', '2025-03-14 23:30:00', 5400, 100.00, 1, 'TABLET'),
(14, 14, 14, '2025-03-15 23:00:00', '2025-03-16 00:08:51', 4131, 76.50,  0, 'NOTEBOOK'),
(15, 15, 15, '2025-03-16 19:00:00', '2025-03-16 19:29:42', 1782, 33.00,  0, 'WEB'),
(16, 16, 16, '2025-03-17 20:00:00', '2025-03-17 21:22:48', 4968, 92.00,  0, 'SMART_TV'),
(17, 17, 17, '2025-03-18 21:00:00', NULL,                  270,  5.00,   0, 'CELULAR'),
(18, 18, 18, '2025-03-19 22:00:00', '2025-03-19 22:54:54', 3294, 61.00,  0, 'TABLET'),
(19, 19, 19, '2025-03-20 23:00:00', '2025-03-21 00:30:00', 5400, 100.00, 1, 'NOTEBOOK'),
(20, 20, 20, '2025-03-21 19:00:00', '2025-03-21 19:21:35', 1295, 24.00,  0, 'WEB'),
(21, 21, 21, '2025-03-22 20:00:00', '2025-03-22 20:11:15', 675,  12.50,  0, 'SMART_TV'),
(22, 22, 22, '2025-03-23 21:00:00', '2025-03-23 21:43:11', 2591, 48.00,  0, 'CELULAR'),
(23, 23, 23, '2025-03-24 22:00:00', '2025-03-24 23:30:00', 5400, 100.00, 1, 'TABLET'),
(24, 24, 24, '2025-03-25 23:00:00', '2025-03-26 00:08:51', 4131, 76.50,  0, 'NOTEBOOK'),
(25, 25, 25, '2025-03-26 19:00:00', '2025-03-26 19:29:42', 1782, 33.00,  0, 'WEB'),
(26, 26, 26, '2025-03-27 20:00:00', '2025-03-27 21:22:48', 4968, 92.00,  0, 'SMART_TV'),
(27, 27, 27, '2025-03-28 21:00:00', NULL,                  270,  5.00,   0, 'CELULAR'),
(28, 28, 28, '2025-03-29 22:00:00', '2025-03-29 22:54:54', 3294, 61.00,  0, 'TABLET'),
(29, 29, 29, '2025-03-30 23:00:00', '2025-03-31 00:30:00', 5400, 100.00, 1, 'NOTEBOOK'),
(30, 30, 30, '2025-03-31 19:00:00', '2025-03-31 19:21:35', 1295, 24.00,  0, 'WEB');

-- ---------------------------------------------------------------------
-- 2.15 AVALIACAO — 30 avaliações
-- ---------------------------------------------------------------------
INSERT INTO AVALIACAO (CODIGO, CODIGO_PERFIL, CODIGO_CONTEUDO, NOTA, COMENTARIO, DATA_AVALIACAO, RECOMENDA) VALUES
(1,  1,  31, 5.00, 'Fotografia impecável, vale a pena assistir em 4K.',          '2025-04-03 21:07:00', 1),
(2,  2,  32, 4.50, 'Um dos melhores títulos do catálogo nacional.',              '2025-04-05 21:14:00', 1),
(3,  3,  33, 3.00, 'A trama demora a engrenar, mas compensa no final.',          '2025-04-07 21:21:00', 0),
(4,  4,  34, 4.00, 'Assisti com a família e todos gostaram.',                    '2025-04-09 21:28:00', 1),
(5,  5,  35, 2.00, 'Personagens sem profundidade e desfecho decepcionante.',     '2025-04-11 21:35:00', 0),
(6,  6,  36, 5.00, 'Fotografia impecável, vale a pena assistir em 4K.',          '2025-04-13 21:42:00', 1),
(7,  7,  37, 3.50, 'Final apressado, porém funciona.',                           '2025-04-15 21:49:00', 1),
(8,  8,  38, 4.50, 'Trilha sonora muito bem escolhida.',                         '2025-04-17 21:56:00', 1),
(9,  9,  39, 1.00, 'Personagens sem profundidade e desfecho decepcionante.',     '2025-04-19 22:03:00', 0),
(10, 10, 40, 4.00, 'Ótima história, prende do começo ao fim.',                   '2025-04-21 22:10:00', 1),
(11, 11, 41, 3.00, 'Esperava mais pelo trailer, mas é divertido.',               '2025-04-23 22:17:00', 0),
(12, 12, 42, 5.00, 'Um dos melhores títulos do catálogo nacional.',              '2025-04-25 22:24:00', 1),
(13, 13, 43, 2.50, 'Personagens sem profundidade e desfecho decepcionante.',     '2025-04-27 22:31:00', 0),
(14, 14, 44, 4.50, 'Assisti com a família e todos gostaram.',                    '2025-04-29 22:38:00', 1),
(15, 15, 45, 3.50, 'Elenco competente, mas o roteiro perde ritmo.',              '2025-05-01 22:45:00', 1),
(16, 16, 46, 5.00, 'Fotografia impecável, vale a pena assistir em 4K.',          '2025-05-03 22:52:00', 1),
(17, 17, 47, 4.50, 'Um dos melhores títulos do catálogo nacional.',              '2025-05-05 22:59:00', 1),
(18, 18, 48, 3.00, 'A trama demora a engrenar, mas compensa no final.',          '2025-05-07 23:06:00', 0),
(19, 19, 49, 4.00, 'Assisti com a família e todos gostaram.',                    '2025-05-09 23:13:00', 1),
(20, 20, 50, 2.00, 'Roteiro confuso e ritmo arrastado, não funcionou para mim.', '2025-05-11 23:20:00', 0),
(21, 21, 51, 5.00, 'Fotografia impecável, vale a pena assistir em 4K.',          '2025-05-13 23:27:00', 1),
(22, 22, 52, 3.50, 'Final apressado, porém funciona.',                           '2025-05-15 23:34:00', 1),
(23, 23, 53, 4.50, 'Trilha sonora muito bem escolhida.',                         '2025-05-17 23:41:00', 1),
(24, 24, 54, 1.00, 'Roteiro confuso e ritmo arrastado, não funcionou para mim.', '2025-05-19 23:48:00', 0),
(25, 25, 55, 4.00, 'Ótima história, prende do começo ao fim.',                   '2025-05-21 23:55:00', 1),
(26, 26, 56, 3.00, 'Esperava mais pelo trailer, mas é divertido.',               '2025-05-24 00:02:00', 0),
(27, 27, 57, 5.00, 'Um dos melhores títulos do catálogo nacional.',              '2025-05-26 00:09:00', 1),
(28, 28, 58, 2.50, 'Roteiro confuso e ritmo arrastado, não funcionou para mim.', '2025-05-28 00:16:00', 0),
(29, 29, 59, 4.50, 'Assisti com a família e todos gostaram.',                    '2025-05-30 00:23:00', 1),
(30, 30, 60, 3.50, 'Elenco competente, mas o roteiro perde ritmo.',              '2025-06-01 00:30:00', 1);

-- ---------------------------------------------------------------------
-- 2.16 MINHA_LISTA — 30 itens salvos
-- ---------------------------------------------------------------------
INSERT INTO MINHA_LISTA (CODIGO, CODIGO_PERFIL, CODIGO_CONTEUDO, DATA_ADICAO, PRIORIDADE, NOTIFICAR_LANCAMENTO) VALUES
(1,  1,  8,  '2025-05-02 13:00:00', 2, 0),
(2,  2,  15, '2025-05-03 14:00:00', 3, 0),
(3,  3,  22, '2025-05-04 15:00:00', 4, 0),
(4,  4,  29, '2025-05-05 16:00:00', 5, 1),
(5,  5,  36, '2025-05-06 17:00:00', 1, 0),
(6,  6,  43, '2025-05-07 18:00:00', 2, 0),
(7,  7,  50, '2025-05-08 19:00:00', 3, 0),
(8,  8,  57, '2025-05-09 12:00:00', 4, 1),
(9,  9,  4,  '2025-05-10 13:00:00', 5, 0),
(10, 10, 11, '2025-05-11 14:00:00', 1, 0),
(11, 11, 18, '2025-05-12 15:00:00', 2, 0),
(12, 12, 25, '2025-05-13 16:00:00', 3, 1),
(13, 13, 32, '2025-05-14 17:00:00', 4, 0),
(14, 14, 39, '2025-05-15 18:00:00', 5, 0),
(15, 15, 46, '2025-05-16 19:00:00', 1, 0),
(16, 16, 53, '2025-05-17 12:00:00', 2, 1),
(17, 17, 60, '2025-05-18 13:00:00', 3, 0),
(18, 18, 7,  '2025-05-19 14:00:00', 4, 0),
(19, 19, 14, '2025-05-20 15:00:00', 5, 0),
(20, 20, 21, '2025-05-21 16:00:00', 1, 1),
(21, 21, 28, '2025-05-22 17:00:00', 2, 0),
(22, 22, 35, '2025-05-23 18:00:00', 3, 0),
(23, 23, 42, '2025-05-24 19:00:00', 4, 0),
(24, 24, 49, '2025-05-25 12:00:00', 5, 1),
(25, 25, 56, '2025-05-26 13:00:00', 1, 0),
(26, 26, 3,  '2025-05-27 14:00:00', 2, 0),
(27, 27, 10, '2025-05-28 15:00:00', 3, 0),
(28, 28, 17, '2025-05-29 16:00:00', 4, 1),
(29, 29, 24, '2025-05-30 17:00:00', 5, 0),
(30, 30, 31, '2025-05-31 18:00:00', 1, 0);

COMMIT;

-- Conferência da carga: todas as tabelas devem ter 30 registros,
-- exceto CONTEUDO, que tem 60 (30 filmes + 30 séries).
SELECT 'PLANO' AS TABELA, COUNT(*) AS REGISTROS FROM PLANO
UNION ALL SELECT 'ASSINATURA', COUNT(*) FROM ASSINATURA
UNION ALL SELECT 'USUARIO', COUNT(*) FROM USUARIO
UNION ALL SELECT 'GENERO', COUNT(*) FROM GENERO
UNION ALL SELECT 'CONTEUDO', COUNT(*) FROM CONTEUDO
UNION ALL SELECT 'FILME', COUNT(*) FROM FILME
UNION ALL SELECT 'SERIE', COUNT(*) FROM SERIE
UNION ALL SELECT 'EPISODIO', COUNT(*) FROM EPISODIO
UNION ALL SELECT 'CONTEUDO_GENERO', COUNT(*) FROM CONTEUDO_GENERO
UNION ALL SELECT 'PERFIL', COUNT(*) FROM PERFIL
UNION ALL SELECT 'DISPOSITIVO', COUNT(*) FROM DISPOSITIVO
UNION ALL SELECT 'FORMA_PAGAMENTO', COUNT(*) FROM FORMA_PAGAMENTO
UNION ALL SELECT 'PAGAMENTO', COUNT(*) FROM PAGAMENTO
UNION ALL SELECT 'HISTORICO_VISUALIZACAO', COUNT(*) FROM HISTORICO_VISUALIZACAO
UNION ALL SELECT 'AVALIACAO', COUNT(*) FROM AVALIACAO
UNION ALL SELECT 'MINHA_LISTA', COUNT(*) FROM MINHA_LISTA
ORDER BY TABELA;

-- 3. Índices
-- Criação de pelo menos um índice (INDEX) em um atributo.

-- Incluir justificativa para a escolha do campo indexado, explicando o benefício em termos de desempenho.

--
-- Os índices são criados DEPOIS da carga inicial: assim o banco não
-- gasta tempo atualizando cada índice a cada INSERT em massa. Em um
-- ambiente de produção, o mesmo raciocínio vale para cargas grandes.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 3.1 ÍNDICE OBRIGATÓRIO — HISTÓRICO DE EXIBIÇÃO POR PERFIL E DATA
-- ---------------------------------------------------------------------
-- Campo indexado: HISTORICO_VISUALIZACAO (CODIGO_PERFIL, DATA_HORA_INICIO)
--
-- Justificativa da escolha:
--   A consulta mais executada de uma plataforma de streaming é
--   "continuar assistindo", que filtra por perfil e ordena pelas
--   exibições mais recentes:
--       SELECT ... FROM HISTORICO_VISUALIZACAO
--        WHERE CODIGO_PERFIL = ?
--        ORDER BY DATA_HORA_INICIO DESC LIMIT 10;
--   Sem índice, o SGBD percorre a tabela inteira (full table scan) e
--   ainda cria uma tabela temporária para ordenar o resultado. Esse
--   histórico cresce muito rápido (uma linha por sessão assistida) e é
--   a tabela com maior tendência de volume do modelo, por isso é a
--   candidata natural a indexação.
--
-- Benefício esperado:
--   - Acesso por busca em árvore B+ em O(log n) em vez de O(n), com
--     leitura apenas das linhas do perfil consultado (seletividade alta).
--   - A ordem física do índice já é (perfil, data decrescente), o que
--     elimina a ordenação e o uso de tabela temporária no ORDER BY.
--   - O índice composto também atende consultas que usam apenas
--     CODIGO_PERFIL (prefixo mais à esquerda), como a contagem de
--     exibições de um perfil.
--   - Custo: ocupa espaço em disco e torna INSERT/UPDATE/DELETE um
--     pouco mais lentos nessa tabela, custo aceitável diante do ganho
--     nas leituras.
-- ---------------------------------------------------------------------
CREATE INDEX IDX_HISTORICO_PERFIL_DATA
    ON HISTORICO_VISUALIZACAO (CODIGO_PERFIL, DATA_HORA_INICIO);

-- ---------------------------------------------------------------------
-- 3.2 ÍNDICE DE APOIO — BUSCA POR TÍTULO NO CATÁLOGO
-- ---------------------------------------------------------------------
-- Campo indexado: CONTEUDO (TITULO)
--
-- Justificativa: a busca do catálogo faz filtro por título e ordenação
-- alfabética (WHERE TITULO LIKE 'A%' ORDER BY TITULO). Com o índice, o
-- SGBD resolve tanto o filtro por prefixo quanto o ORDER BY sem varrer
-- a tabela nem criar ordenação temporária.
--
-- Benefício esperado: redução de full scan em CONTEUDO e resposta mais
-- rápida para a busca do catálogo, que é uma das telas mais acessadas.
-- Observação: o índice cobre buscas por prefixo; buscas por qualquer
-- trecho (LIKE '%termo%') não se beneficiam dele e exigiriam um índice
-- de texto completo (FULLTEXT), que é outra estratégia.
-- ---------------------------------------------------------------------
CREATE INDEX IDX_CONTEUDO_TITULO ON CONTEUDO (TITULO);

-- ---------------------------------------------------------------------
-- 3.3 ÍNDICE DE APOIO — COBRANÇA POR STATUS E VENCIMENTO
-- ---------------------------------------------------------------------
-- Campos indexados: PAGAMENTO (STATUS_PAGAMENTO, DATA_VENCIMENTO)
--
-- Justificativa: a rotina de cobrança consulta diariamente as faturas
-- pendentes/recusadas que vencem em determinado período
-- (WHERE STATUS_PAGAMENTO = 'PENDENTE' AND DATA_VENCIMENTO <= ?). O
-- índice composto reduz drasticamente o conjunto lido e mantém as
-- faturas já ordenadas por vencimento.
--
-- Benefício esperado: consulta de inadimplência e conciliação mais
-- rápida, com menos leitura de páginas de dados, exatamente a consulta
-- que mais se repete no fechamento financeiro.
-- ---------------------------------------------------------------------
CREATE INDEX IDX_PAGAMENTO_STATUS_VENC
    ON PAGAMENTO (STATUS_PAGAMENTO, DATA_VENCIMENTO);

-- ---------------------------------------------------------------------
-- 3.4 ÍNDICE DE APOIO — MÉDIA DE NOTAS POR CONTEÚDO
-- ---------------------------------------------------------------------
-- Campos indexados: AVALIACAO (CODIGO_CONTEUDO, NOTA)
--
-- Justificativa: a nota média exibida na página de cada título é
-- calculada com AVG(NOTA) agrupada por CODIGO_CONTEUDO. O índice cobre
-- a consulta (covering index): as duas colunas necessárias estão no
-- próprio índice, sem precisar acessar a tabela de dados.
--
-- Benefício esperado: cálculo da média por título sem full scan e sem
-- leitura da tabela base, o que é relevante porque a página de detalhe
-- do conteúdo é acessada com alta frequência.
-- ---------------------------------------------------------------------
CREATE INDEX IDX_AVALIACAO_CONTEUDO_NOTA
    ON AVALIACAO (CODIGO_CONTEUDO, NOTA);

-- Observação: chaves estrangeiras já recebem índice automático do
-- InnoDB quando não existe um índice que as cubra; por isso não é
-- necessário criar índices extras apenas para as FKs.

-- Verificação dos índices criados:
-- SHOW INDEX FROM HISTORICO_VISUALIZACAO;
-- EXPLAIN SELECT CODIGO FROM HISTORICO_VISUALIZACAO
--          WHERE CODIGO_PERFIL = 5 ORDER BY DATA_HORA_INICIO DESC LIMIT 10;

-- 4. Scripts Adicionais (Inserir como Comentários no Arquivo)
-- Inclua os seguintes exemplos no arquivo .sql, comentados, como demonstração de domínio técnico:

-- Exclusão do banco de dados.

-- DROP DATABASE IF EXISTS STREAMING;

-- Exclusão de uma tabela.

-- DROP TABLE IF EXISTS MINHA_LISTA;

-- Exclusão de uma coluna de uma tabela.

-- ALTER TABLE CONTEUDO DROP COLUMN TRAILER_URL;

-- Adição de uma nova coluna (não prevista na modelagem inicial).

-- ALTER TABLE USUARIO
--     ADD COLUMN ACEITA_MARKETING TINYINT(1) NOT NULL DEFAULT 0 AFTER ATIVO;

-- Edição de um registro específico.

-- UPDATE PLANO
--    SET PRECO = 279.90,
--        DESCRICAO = 'Versão anual do plano Padrão com desconto de 22%.'
--  WHERE CODIGO = 4;

-- Exclusão de um registro específico.

-- DELETE FROM AVALIACAO WHERE CODIGO = 30;

-- 5. Consultas SQL (Queries)
-- Caso sua modelagem não permita algum dos JOINs solicitados, incluir uma justificativa técnica.
-- As consultas devem utilizar, sempre que possível, os seguintes comandos SQL: WHERE e diferentes tipos de operadores; GROUP BY; HAVING e ORDER BY

-- Duas consultas simples, utilizando apenas uma tabela.

-- =====================================================================
-- 5.1 CONSULTA SIMPLES 1 — PLANOS COM PREÇO INTERMEDIÁRIO
-- =====================================================================
-- Uma única tabela (PLANO).
-- Filtra planos ativos na faixa de R$ 20 a R$ 50, mantendo apenas os que
-- permitem download OU que atendem 4 ou mais telas (note os parênteses:
-- sem eles o OR anularia o filtro de preço). Ordena do mais caro para o
-- mais barato.
-- =====================================================================
SELECT CODIGO,
       NOME_PLANO,
       PRECO,
       QUALIDADE_VIDEO,
       LIMITE_TELAS
  FROM PLANO
 WHERE ATIVO = 1
   AND PRECO BETWEEN 20.00 AND 50.00
   AND (PERMITE_DOWNLOAD = 1 OR LIMITE_TELAS >= 4)
 ORDER BY PRECO DESC, NOME_PLANO ASC;


-- =====================================================================
-- 5.2 CONSULTA SIMPLES 2 — CATÁLOGO ADULTO RECENTE
-- =====================================================================
-- Uma única tabela (CONTEUDO).
-- Lista conteúdos ativos classificados como 16 ou 18 anos, lançados entre
-- 2022 e 2025, do mais recente para o mais antigo.
-- =====================================================================
SELECT CODIGO,
       TITULO,
       ANO_LANCAMENTO,
       TIPO_CONTEUDO,
       CLASSIFICACAO_ETARIA
  FROM CONTEUDO
 WHERE ATIVO = 1
   AND CLASSIFICACAO_ETARIA IN ('16', '18')
   AND ANO_LANCAMENTO BETWEEN 2022 AND 2025
 ORDER BY ANO_LANCAMENTO DESC, TITULO ASC;

-- Quatro consultas com duas tabelas, utilizando INNER JOIN.

-- =====================================================================
-- 5.3 INNER JOIN 1 — FILMES LONGOS COM LUCRO
-- =====================================================================
-- Duas tabelas: CONTEUDO (dados comuns) e FILME (dados específicos).
-- A ligação é 1:1 pela chave primária/estrangeira CODIGO.
-- Mostra apenas filmes com 120 minutos ou mais cuja bilheteria superou o
-- orçamento, calculando o lucro estimado e ordenando por ele.
-- =====================================================================
SELECT c.TITULO,
       f.DIRETOR,
       f.DURACAO_MINUTOS,
       f.ORCAMENTO,
       f.BILHETERIA,
       (f.BILHETERIA - f.ORCAMENTO) AS LUCRO_ESTIMADO
  FROM CONTEUDO c
 INNER JOIN FILME f ON f.CODIGO = c.CODIGO
 WHERE f.DURACAO_MINUTOS >= 120
   AND f.BILHETERIA > f.ORCAMENTO
 ORDER BY LUCRO_ESTIMADO DESC, c.TITULO ASC;


-- =====================================================================
-- 5.4 INNER JOIN 2 — CLIENTES COM ASSINATURA ATIVA E RECENTE
-- =====================================================================
-- Duas tabelas: USUARIO e ASSINATURA (1:1 garantido pelo UNIQUE em
-- USUARIO.CODIGO_ASSINATURA).
-- Filtra assinaturas ativas iniciadas a partir de março de 2025 ou sem
-- renovação automática, mostrando o código da assinatura e a data.
-- =====================================================================
SELECT u.NOME,
       u.EMAIL,
       a.CODIGO_ASSINATURA,
       a.DATA_INICIO,
       a.RENOVACAO_AUTOMATICA
  FROM USUARIO u
 INNER JOIN ASSINATURA a ON a.CODIGO = u.CODIGO_ASSINATURA
 WHERE u.ATIVO = 1
   AND a.STATUS_ASSINATURA = 'ATIVA'
   AND (a.DATA_INICIO >= '2025-03-01' OR a.RENOVACAO_AUTOMATICA = 0)
 ORDER BY a.DATA_INICIO DESC, u.NOME ASC;


-- =====================================================================
-- 5.5 INNER JOIN 3 — NOTA MÉDIA POR CONTEÚDO
-- =====================================================================
-- Duas tabelas: CONTEUDO e AVALIACAO (1:N, uma linha de avaliação por
-- perfil e conteúdo).
-- Agrupa por conteúdo, calcula a média e usa HAVING para manter apenas os
-- conteúdos com média igual ou superior a 4,00 (filtro aplicado depois da
-- agregação, por isso não pode ficar no WHERE).
-- =====================================================================
SELECT c.CODIGO,
       c.TITULO,
       COUNT(a.CODIGO)        AS QTD_AVALIACOES,
       ROUND(AVG(a.NOTA), 2)  AS NOTA_MEDIA
  FROM CONTEUDO c
 INNER JOIN AVALIACAO a ON a.CODIGO_CONTEUDO = c.CODIGO
 WHERE c.ATIVO = 1
 GROUP BY c.CODIGO, c.TITULO
HAVING AVG(a.NOTA) >= 4.00
 ORDER BY NOTA_MEDIA DESC, QTD_AVALIACOES DESC, c.TITULO ASC;


-- =====================================================================
-- 5.6 INNER JOIN 4 — PAGAMENTOS APROVADOS POR FORMA DE PAGAMENTO
-- =====================================================================
-- Duas tabelas: FORMA_PAGAMENTO e PAGAMENTO (1:N).
-- Soma os pagamentos aprovados de 2025 por tipo (cartão, PIX, boleto) e
-- usa HAVING para descartar tipos com valor total baixo.
-- =====================================================================
SELECT f.TIPO_PAGAMENTO,
       COUNT(p.CODIGO)         AS QTD_PAGAMENTOS,
       SUM(p.VALOR)            AS VALOR_TOTAL,
       ROUND(AVG(p.VALOR), 2)  AS TICKET_MEDIO
  FROM FORMA_PAGAMENTO f
 INNER JOIN PAGAMENTO p ON p.CODIGO_FORMA_PAGAMENTO = f.CODIGO
 WHERE p.STATUS_PAGAMENTO = 'APROVADO'
   AND p.DATA_VENCIMENTO BETWEEN '2025-01-01' AND '2025-12-31'
 GROUP BY f.TIPO_PAGAMENTO
HAVING SUM(p.VALOR) > 100.00
 ORDER BY VALOR_TOTAL DESC;

-- Uma consulta com LEFT JOIN.

-- =====================================================================
-- 5.7 LEFT JOIN — CONTEÚDOS AINDA SEM AVALIAÇÃO
-- =====================================================================
-- A tabela da esquerda (CONTEUDO) é preservada por completo; o LEFT JOIN
-- traz as avaliações quando existem e NULL quando não existem. O filtro
-- a.CODIGO IS NULL seleciona exatamente os conteúdos sem avaliação — um
-- anti-join, útil para a fila de curadoria pedir avaliações.
-- =====================================================================
SELECT c.CODIGO,
       c.TITULO,
       c.ANO_LANCAMENTO,
       a.CODIGO AS CODIGO_AVALIACAO
  FROM CONTEUDO c
  LEFT JOIN AVALIACAO a ON a.CODIGO_CONTEUDO = c.CODIGO
 WHERE a.CODIGO IS NULL
 ORDER BY c.TITULO ASC;

-- Uma consulta com RIGHT JOIN.

-- =====================================================================
-- 5.8 RIGHT JOIN — GÊNEROS SEM NENHUM CONTEÚDO VINCULADO
-- =====================================================================
-- Aqui a tabela preservada é GENERO, que está à direita do RIGHT JOIN:
-- todas as linhas do gênero aparecem, mesmo as que não têm vínculo em
-- CONTEUDO_GENERO. O filtro cg.CODIGO_CONTEUDO IS NULL devolve os gêneros
-- órfãos, que a curadoria pode usar para revisar o catálogo.
-- =====================================================================
SELECT g.CODIGO,
       g.NOME_GENERO,
       g.CATEGORIA,
       cg.CODIGO_CONTEUDO
  FROM CONTEUDO_GENERO cg
 RIGHT JOIN GENERO g ON g.CODIGO = cg.CODIGO_GENERO
 WHERE cg.CODIGO_CONTEUDO IS NULL
 ORDER BY g.NOME_GENERO ASC;

-- Uma consulta com três tabelas, utilizando qualquer tipo de JOIN.

-- =====================================================================
-- 5.9 TRÊS TABELAS — AVALIAÇÕES POR TIPO DE PERFIL
-- =====================================================================
-- Três tabelas: AVALIACAO -> PERFIL -> (CONTEUDO).
-- Cruza a nota com o tipo de perfil (adulto/infantil), mostrando quantas
-- avaliações cada conteúdo recebeu por tipo e a média. O HAVING mantém
-- apenas os grupos com média alta.
-- =====================================================================
SELECT c.TITULO,
       p.TIPO_PERFIL,
       COUNT(a.CODIGO)        AS QTD_AVALIACOES,
       ROUND(AVG(a.NOTA), 2)  AS NOTA_MEDIA
  FROM AVALIACAO a
 INNER JOIN PERFIL p   ON p.CODIGO = a.CODIGO_PERFIL
 INNER JOIN CONTEUDO c ON c.CODIGO = a.CODIGO_CONTEUDO
 WHERE a.NOTA >= 3.00
 GROUP BY c.TITULO, p.TIPO_PERFIL
HAVING AVG(a.NOTA) >= 4.00
 ORDER BY NOTA_MEDIA DESC, c.TITULO ASC;

-- Uma consulta com quatro tabelas, utilizando qualquer tipo de JOIN.

-- =====================================================================
-- 5.10 QUATRO TABELAS — TEMPO ASSISTIDO POR CLIENTE
-- =====================================================================
-- Quatro tabelas: HISTORICO_VISUALIZACAO -> PERFIL -> USUARIO e
-- HISTORICO_VISUALIZACAO -> CONTEUDO.
-- Soma o tempo assistido por cliente em filmes, considerando apenas
-- clientes ativos e exibições com mais de 10% de progresso, e mantém no
-- resultado somente quem passou de 30 minutos.
-- =====================================================================
SELECT u.NOME,
       COUNT(h.CODIGO)                              AS EXIBICOES,
       SUM(h.TEMPO_ASSISTIDO_SEG)                   AS TEMPO_TOTAL_SEG,
       ROUND(SUM(h.TEMPO_ASSISTIDO_SEG) / 60, 1)    AS TEMPO_TOTAL_MIN
  FROM HISTORICO_VISUALIZACAO h
 INNER JOIN PERFIL p   ON p.CODIGO = h.CODIGO_PERFIL
 INNER JOIN USUARIO u  ON u.CODIGO = p.CODIGO_USUARIO
 INNER JOIN CONTEUDO c ON c.CODIGO = h.CODIGO_CONTEUDO
 WHERE c.TIPO_CONTEUDO = 'FILME'
   AND u.ATIVO = 1
   AND h.PERCENTUAL_PROGRESSO > 10
 GROUP BY u.CODIGO, u.NOME
HAVING SUM(h.TEMPO_ASSISTIDO_SEG) >= 1800
 ORDER BY TEMPO_TOTAL_SEG DESC;


-- =====================================================================
-- 5.11 NOTA TÉCNICA SOBRE OS JOINs
-- =====================================================================
-- A modelagem permite todos os JOINs solicitados: existem chaves
-- estrangeiras ligando CONTEUDO-FILME, USUARIO-ASSINATURA,
-- CONTEUDO-AVALIACAO, FORMA_PAGAMENTO-PAGAMENTO, PERFIL-USUARIO,
-- HISTORICO_PERFIL-CONTEUDO etc. Por isso nenhuma consulta precisou ser
-- substituída por falta de relacionamento.
--
-- O RIGHT JOIN do item 5.8 poderia ser escrito como LEFT JOIN invertendo
-- a ordem das tabelas (GENERO LEFT JOIN CONTEUDO_GENERO); a forma com
-- RIGHT foi mantida apenas para atender explicitamente ao requisito.
--
-- Resumo da cobertura:
--   [x] 2 consultas simples (1 tabela) ................ 5.1 e 5.2
--   [x] 4 consultas INNER JOIN (2 tabelas) ............ 5.3, 5.4, 5.5 e 5.6
--   [x] 1 consulta LEFT JOIN .......................... 5.7
--   [x] 1 consulta RIGHT JOIN ......................... 5.8
--   [x] 1 consulta com 3 tabelas ...................... 5.9
--   [x] 1 consulta com 4 tabelas ...................... 5.10
--   [x] WHERE, operadores lógicos, GROUP BY, HAVING e ORDER BY
-- =====================================================================

-- 6. Recursos Adicionais
-- Criação de três VIEWs.

-- =====================================================================
-- 6.1.1 VW_CATALOGO_DETALHADO
-- =====================================================================
-- Finalidade: entregar o catálogo já "pronto para exibição", reunindo em
-- uma única linha os dados que a tela do catálogo precisa: título, tipo,
-- ano, classificação etária, gênero principal, duração (filme) e
-- quantidade de episódios (série).
--
-- Por que uma view: a tela do catálogo não deve repetir três JOINs e uma
-- subconsulta em cada consulta da aplicação. A view encapsula essa lógica
-- e, se a modelagem mudar, só a view precisa ser ajustada.
--
-- Sobre o gênero: a primeira opção é o gênero marcado como PRINCIPAL; se
-- o conteúdo ainda não tiver um gênero principal definido, a view usa o
-- vínculo de maior peso de relevância como alternativa. Assim a coluna
-- não fica vazia quando existe classificação secundária.
-- =====================================================================
CREATE OR REPLACE VIEW VW_CATALOGO_DETALHADO AS
SELECT c.CODIGO                                   AS CODIGO_CONTEUDO,
       c.TITULO,
       c.TIPO_CONTEUDO,
       c.ANO_LANCAMENTO,
       c.CLASSIFICACAO_ETARIA,
       c.DATA_INCLUSAO_CATALOGO,
       COALESCE((SELECT g.NOME_GENERO
                   FROM CONTEUDO_GENERO cg
                   JOIN GENERO g ON g.CODIGO = cg.CODIGO_GENERO
                  WHERE cg.CODIGO_CONTEUDO = c.CODIGO
                  ORDER BY cg.PRINCIPAL DESC, cg.PESO_RELEVANCIA DESC
                  LIMIT 1), 'Não classificado')       AS GENERO_PRINCIPAL,
       f.DURACAO_MINUTOS,
       f.RESOLUCAO_MAXIMA,
       (SELECT COUNT(*)
          FROM EPISODIO e
         WHERE e.CODIGO_SERIE = c.CODIGO)            AS QTD_EPISODIOS
  FROM CONTEUDO c
  LEFT JOIN FILME f ON f.CODIGO = c.CODIGO
 WHERE c.ATIVO = 1;


-- =====================================================================
-- 6.1.2 VW_ASSINATURA_USUARIO
-- =====================================================================
-- Finalidade: visão consolidada do cliente, com dados cadastrais, dados
-- do plano contratado e situação da assinatura. É a consulta usada pelo
-- atendimento e pela tela "Minha conta".
--
-- A view esconde a cadeia USUARIO -> ASSINATURA -> PLANO e já calcula a
-- quantidade de perfis de cada usuário, evitando que a aplicação monte
-- esse JOIN manualmente.
-- =====================================================================
CREATE OR REPLACE VIEW VW_ASSINATURA_USUARIO AS
SELECT u.CODIGO                     AS CODIGO_USUARIO,
       u.NOME,
       u.EMAIL,
       u.ATIVO                      AS USUARIO_ATIVO,
       a.CODIGO_ASSINATURA,
       a.STATUS_ASSINATURA,
       p.NOME_PLANO,
       p.PRECO,
       p.QUALIDADE_VIDEO,
       p.LIMITE_TELAS,
       a.DATA_INICIO,
       a.DATA_FIM,
       (SELECT COUNT(*)
          FROM PERFIL pf
         WHERE pf.CODIGO_USUARIO = u.CODIGO) AS QTD_PERFIS
  FROM USUARIO u
  JOIN ASSINATURA a ON a.CODIGO = u.CODIGO_ASSINATURA
  JOIN PLANO p      ON p.CODIGO = a.CODIGO_PLANO;


-- =====================================================================
-- 6.1.3 VW_DESEMPENHO_CONTEUDO
-- =====================================================================
-- Finalidade: apoiar a curadoria do catálogo, mostrando por conteúdo a
-- quantidade de avaliações, a nota média, quantas pessoas recomendam e
-- quantas exibições foram registradas.
--
-- A agregação (AVG/COUNT) fica dentro da view: a aplicação apenas filtra
-- ou ordena, sem repetir GROUP BY e sem risco de esquecer o LEFT JOIN
-- (que mantém no resultado os conteúdos ainda sem avaliação).
-- =====================================================================
CREATE OR REPLACE VIEW VW_DESEMPENHO_CONTEUDO AS
SELECT c.CODIGO                     AS CODIGO_CONTEUDO,
       c.TITULO,
       c.TIPO_CONTEUDO,
       COUNT(a.CODIGO)              AS QTD_AVALIACOES,
       ROUND(AVG(a.NOTA), 2)        AS NOTA_MEDIA,
       SUM(CASE WHEN a.RECOMENDA = 1 THEN 1 ELSE 0 END) AS QTD_RECOMENDACOES,
       (SELECT COUNT(*)
          FROM HISTORICO_VISUALIZACAO h
         WHERE h.CODIGO_CONTEUDO = c.CODIGO) AS QTD_EXIBICOES
  FROM CONTEUDO c
  LEFT JOIN AVALIACAO a ON a.CODIGO_CONTEUDO = c.CODIGO
 GROUP BY c.CODIGO, c.TITULO, c.TIPO_CONTEUDO;


-- =====================================================================
-- 6.1.4 CONFERÊNCIA E EXEMPLOS DE USO
-- =====================================================================

-- As três views existem e quantas linhas cada uma devolve:
SELECT 'VW_CATALOGO_DETALHADO' AS VIEW_NAME, COUNT(*) AS LINHAS FROM VW_CATALOGO_DETALHADO
UNION ALL
SELECT 'VW_ASSINATURA_USUARIO', COUNT(*) FROM VW_ASSINATURA_USUARIO
UNION ALL
SELECT 'VW_DESEMPENHO_CONTEUDO', COUNT(*) FROM VW_DESEMPENHO_CONTEUDO;

-- Exemplo 1: catálogo de filmes que já possuem gênero classificado, do
-- mais recente para o mais antigo (a view já traz duração e resolução).
SELECT TITULO, ANO_LANCAMENTO, GENERO_PRINCIPAL, DURACAO_MINUTOS
  FROM VW_CATALOGO_DETALHADO
 WHERE TIPO_CONTEUDO = 'FILME'
   AND GENERO_PRINCIPAL <> 'Não classificado'
 ORDER BY ANO_LANCAMENTO DESC, TITULO
 LIMIT 10;

-- Exemplo 2: clientes com assinatura suspensa ou cancelada, com o plano
-- e o valor contratado.
SELECT NOME, EMAIL, NOME_PLANO, PRECO, STATUS_ASSINATURA
  FROM VW_ASSINATURA_USUARIO
 WHERE STATUS_ASSINATURA <> 'ATIVA'
 ORDER BY NOME;

-- Exemplo 3: top 10 conteúdos por nota média, exigindo pelo menos uma
-- avaliação (a view conta as avaliações, então o filtro é simples).
SELECT TITULO, NOTA_MEDIA, QTD_AVALIACOES, QTD_EXIBICOES
  FROM VW_DESEMPENHO_CONTEUDO
 WHERE QTD_AVALIACOES > 0
 ORDER BY NOTA_MEDIA DESC, QTD_AVALIACOES DESC
 LIMIT 10;

-- Estrutura de uma view (útil para conferir a definição armazenada):
SHOW CREATE VIEW VW_CATALOGO_DETALHADO;

-- Criação de dois TRIGGERs, sendo:
-- Um BEFORE

-- Um AFTER

DROP TRIGGER IF EXISTS TRG_PAGAMENTO_BEFORE_INSERT;
DROP TRIGGER IF EXISTS TRG_PAGAMENTO_AFTER_INSERT;


-- =====================================================================
-- 6.2.1 TRIGGER BEFORE — TRG_PAGAMENTO_BEFORE_INSERT
-- =====================================================================
-- Regras aplicadas antes de cada pagamento ser gravado:
--
--   1) VALOR não pode ser negativo. Como a coluna é DECIMAL(10,2), o
--      banco aceitaria -10.00; a validação de negócio precisa do trigger.
--      A falha é sinalizada com SIGNAL, que aborta o INSERT.
--   2) Pagamento APROVADO sem data de pagamento recebe a data/hora atual
--      (NEW.DATA_PAGAMENTO = NOW()), evitando registros aprovados sem a
--      data em que o dinheiro entrou.
--   3) Pagamento PENDENTE não pode ter data de pagamento: se a aplicação
--      enviar uma, o trigger zera o campo.
-- =====================================================================
DELIMITER $$

CREATE TRIGGER TRG_PAGAMENTO_BEFORE_INSERT
BEFORE INSERT ON PAGAMENTO
FOR EACH ROW
BEGIN
    IF NEW.VALOR < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'PAGAMENTO.VALOR nao pode ser negativo.';
    END IF;

    IF NEW.STATUS_PAGAMENTO = 'APROVADO' AND NEW.DATA_PAGAMENTO IS NULL THEN
        SET NEW.DATA_PAGAMENTO = NOW();
    END IF;

    IF NEW.STATUS_PAGAMENTO = 'PENDENTE' THEN
        SET NEW.DATA_PAGAMENTO = NULL;
    END IF;
END$$

DELIMITER ;


-- =====================================================================
-- 6.2.2 TRIGGER AFTER — TRG_PAGAMENTO_AFTER_INSERT
-- =====================================================================
-- Regra aplicada depois que o pagamento é gravado:
--
--   Quando um pagamento é APROVADO, o usuário dono daquela forma de
--   pagamento volta a ser considerado ativo (USUARIO.ATIVO = 1). É o
--   fluxo de reativação automática: cliente com assinatura cancelada ou
--   suspensa paga a fatura e recupera o acesso sem intervenção manual.
--
--   O trigger usa a chave estrangeira CODIGO_FORMA_PAGAMENTO para chegar
--   ao usuário, sem repetir o código do usuário na tabela PAGAMENTO
--   (o que duplicaria o dado e violaria a 3FN).
-- =====================================================================
DELIMITER $$

CREATE TRIGGER TRG_PAGAMENTO_AFTER_INSERT
AFTER INSERT ON PAGAMENTO
FOR EACH ROW
BEGIN
    IF NEW.STATUS_PAGAMENTO = 'APROVADO' THEN
        UPDATE USUARIO u
          JOIN FORMA_PAGAMENTO f ON f.CODIGO_USUARIO = u.CODIGO
           SET u.ATIVO = 1
         WHERE f.CODIGO = NEW.CODIGO_FORMA_PAGAMENTO;
    END IF;
END$$

DELIMITER ;


-- =====================================================================
-- 6.2.3 CONFERÊNCIA DOS TRIGGERS CRIADOS
-- =====================================================================
SELECT TRIGGER_NAME, EVENT_MANIPULATION, ACTION_TIMING, EVENT_OBJECT_TABLE
  FROM information_schema.triggers
 WHERE trigger_schema = 'STREAMING'
 ORDER BY ACTION_TIMING, TRIGGER_NAME;


-- =====================================================================
-- 6.2.4 TESTE DO TRIGGER BEFORE (data preenchida automaticamente)
-- =====================================================================
-- Inserção de um pagamento APROVADO sem DATA_PAGAMENTO: o BEFORE deve
-- preencher a data com o instante atual.
--
-- A transação é desfeita no final com ROLLBACK, para que o banco volte
-- exatamente ao estado anterior ao teste (nenhum pagamento a mais).
START TRANSACTION;

INSERT INTO PAGAMENTO
       (CODIGO_FORMA_PAGAMENTO, DATA_PAGAMENTO, DATA_VENCIMENTO,
        VALOR, STATUS_PAGAMENTO, CODIGO_TRANSACAO)
VALUES (9, NULL, '2026-01-10', 64.90, 'APROVADO', 'TX-TESTE-TRIGGER-07');

SELECT 'TESTE BEFORE' AS MOMENTO, CODIGO, DATA_PAGAMENTO, STATUS_PAGAMENTO
  FROM PAGAMENTO
 WHERE CODIGO_TRANSACAO = 'TX-TESTE-TRIGGER-07';

ROLLBACK;


-- =====================================================================
-- 6.2.5 TESTE DO TRIGGER AFTER (reativação do usuário)
-- =====================================================================
-- O usuário 9 está com ATIVO = 0 (assinatura cancelada) e a forma de
-- pagamento 9 pertence a ele. Ao inserir um pagamento APROVADO, o AFTER
-- deve devolver ATIVO = 1. O ROLLBACK final desfaz as duas alterações.
START TRANSACTION;

SELECT 'ANTES DO PAGAMENTO' AS MOMENTO, CODIGO, NOME, ATIVO
  FROM USUARIO WHERE CODIGO = 9;

INSERT INTO PAGAMENTO
       (CODIGO_FORMA_PAGAMENTO, DATA_PAGAMENTO, DATA_VENCIMENTO,
        VALOR, STATUS_PAGAMENTO, CODIGO_TRANSACAO)
VALUES (9, NULL, '2026-02-10', 64.90, 'APROVADO', 'TX-TESTE-TRIGGER-07B');

SELECT 'DEPOIS DO PAGAMENTO' AS MOMENTO, CODIGO, NOME, ATIVO
  FROM USUARIO WHERE CODIGO = 9;

ROLLBACK;

SELECT 'DEPOIS DO ROLLBACK' AS MOMENTO, CODIGO, NOME, ATIVO
  FROM USUARIO WHERE CODIGO = 9;


-- =====================================================================
-- 6.2.6 TESTE DE VALIDAÇÃO (deve falhar de propósito)
-- =====================================================================
-- O comando abaixo é bloqueado pelo trigger BEFORE com
-- "ERROR 1644 (45000): PAGAMENTO.VALOR nao pode ser negativo.".
-- Ele está comentado porque um erro interrompe a execução do script;
-- descomente e execute sozinho para ver a mensagem.
-- INSERT INTO PAGAMENTO
--        (CODIGO_FORMA_PAGAMENTO, DATA_PAGAMENTO, DATA_VENCIMENTO,
--         VALOR, STATUS_PAGAMENTO, CODIGO_TRANSACAO)
-- VALUES (9, NULL, '2026-03-10', -10.00, 'PENDENTE', 'TX-TESTE-VALOR-NEGATIVO');

-- Criação de três usuários com permissões distintas.

-- Limpeza para permitir reexecução (o DROP USER já remove os privilégios):
DROP USER IF EXISTS 'streaming_consulta'@'localhost';
DROP USER IF EXISTS 'streaming_operador'@'localhost';
DROP USER IF EXISTS 'streaming_admin'@'localhost';


-- =====================================================================
-- 6.3.1 CRIAÇÃO DOS TRÊS USUÁRIOS
-- =====================================================================
-- Cada usuário representa um perfil de acesso diferente do sistema:
--
--   streaming_consulta -> atendimento/relatórios: só LÊ as views.
--   streaming_operador -> back office: lê e mantém os dados das tabelas,
--                         mas não altera a estrutura e não gerencia usuários.
--   streaming_admin    -> administrador do banco: todos os privilégios
--                         dentro do schema STREAMING.
--
-- O princípio seguido é o do menor privilégio: cada conta recebe apenas
-- o necessário para a sua função.
CREATE USER 'streaming_consulta'@'localhost' IDENTIFIED BY 'Consulta@2025';
CREATE USER 'streaming_operador'@'localhost' IDENTIFIED BY 'Operador@2025';
CREATE USER 'streaming_admin'@'localhost'    IDENTIFIED BY 'Admin@2025';


-- =====================================================================
-- 6.3.2 CONCESSÃO DE PRIVILÉGIOS
-- =====================================================================

-- (a) Consulta: SELECT apenas nas três views, nenhum acesso direto às
--     tabelas. Como as views usam SQL SECURITY DEFINER, a leitura das
--     tabelas de base é feita com os privilégios de quem as criou.
GRANT SELECT ON STREAMING.VW_CATALOGO_DETALHADO  TO 'streaming_consulta'@'localhost';
GRANT SELECT ON STREAMING.VW_ASSINATURA_USUARIO  TO 'streaming_consulta'@'localhost';
GRANT SELECT ON STREAMING.VW_DESEMPENHO_CONTEUDO TO 'streaming_consulta'@'localhost';

-- (b) Operador: leitura e manutenção dos dados (DML), sem DDL.
--     Não há CREATE, DROP, ALTER nem GRANT: o operador não mexe na
--     estrutura do banco nem concede acesso a ninguém.
GRANT SELECT, INSERT, UPDATE, DELETE ON STREAMING.* TO 'streaming_operador'@'localhost';

-- (c) Admin: todos os privilégios no schema STREAMING (inclusive CREATE,
--     DROP, ALTER, INDEX, TRIGGER e VIEW). Sem WITH GRANT OPTION, para
--     que este usuário não repasse privilégios a terceiros.
GRANT ALL PRIVILEGES ON STREAMING.* TO 'streaming_admin'@'localhost';

FLUSH PRIVILEGES;


-- =====================================================================
-- 6.3.3 CONFERÊNCIA DOS PRIVILÉGIOS CONCEDIDOS
-- =====================================================================
SHOW GRANTS FOR 'streaming_consulta'@'localhost';
SHOW GRANTS FOR 'streaming_operador'@'localhost';
SHOW GRANTS FOR 'streaming_admin'@'localhost';

SELECT user, host, account_locked, password_expired
  FROM mysql.user
 WHERE user LIKE 'streaming_%'
 ORDER BY user;

-- Exclusão de um dos usuários criados.

-- =====================================================================
-- 6.3.4 EXCLUSÃO DE UM DOS USUÁRIOS CRIADOS
-- =====================================================================
-- Remove 'streaming_admin'. A escolha é proposital: é a conta com mais
-- privilégios e a que menos precisa existir no dia a dia. O DROP USER
-- apaga a conta e, junto com ela, todos os privilégios que possuía.
DROP USER 'streaming_admin'@'localhost';

-- Conferência: a conta não deve mais aparecer na lista.
SELECT user, host
  FROM mysql.user
 WHERE user LIKE 'streaming_%'
 ORDER BY user;

-- Revogação de privilégios de dois usuários

-- =====================================================================
-- 6.3.5 REVOGAÇÃO DE PRIVILÉGIOS DE DOIS USUÁRIOS
-- =====================================================================
-- (a) O perfil de consulta perde o acesso ao relatório de desempenho
--     (notas e audiência), que passa a ser restrito à curadoria.
REVOKE SELECT ON STREAMING.VW_DESEMPENHO_CONTEUDO FROM 'streaming_consulta'@'localhost';

-- (b) O operador perde o direito de excluir registros. Ele continua
--     podendo incluir e alterar dados, mas não apagar histórico,
--     avaliações ou pagamentos.
REVOKE DELETE ON STREAMING.* FROM 'streaming_operador'@'localhost';

FLUSH PRIVILEGES;

-- Conferência final: repare que as permissões revogadas desapareceram.
SHOW GRANTS FOR 'streaming_consulta'@'localhost';
SHOW GRANTS FOR 'streaming_operador'@'localhost';


-- =====================================================================
-- 6.3.6 COMO TESTAR OS ACESSOS (executar no terminal, não neste script)
-- =====================================================================
-- Como o script roda sempre como root, os testes abaixo devem ser
-- executados em um terminal à parte, um comando por vez:
--
--   mysql -u streaming_consulta -p'Consulta@2025' --protocol=tcp -e "USE STREAMING; SELECT COUNT(*) FROM VW_CATALOGO_DETALHADO;"
--   mysql -u streaming_consulta -p'Consulta@2025' --protocol=tcp -e "USE STREAMING; SELECT COUNT(*) FROM VW_DESEMPENHO_CONTEUDO;"   -- deve falhar: SELECT revogado
--   mysql -u streaming_consulta -p'Consulta@2025' --protocol=tcp -e "USE STREAMING; SELECT COUNT(*) FROM USUARIO;"                 -- deve falhar: sem acesso à tabela
--   mysql -u streaming_operador -p'Operador@2025' --protocol=tcp -e "USE STREAMING; UPDATE PLANO SET DESCRICAO = DESCRICAO WHERE CODIGO = 1;"
--   mysql -u streaming_operador -p'Operador@2025' --protocol=tcp -e "USE STREAMING; DELETE FROM AVALIACAO WHERE CODIGO = 1;"         -- deve falhar: DELETE revogado
--   mysql -u streaming_admin   -p'Admin@2025'    -- deve falhar: usuário excluído
--
-- Em clientes MySQL 8 que não usam SSL, pode ser necessário acrescentar
-- --get-server-public-key nos comandos acima.

-- Exemplo de uso dos comandos:
-- COMMIT

-- 1 = ligado: cada comando fora de transação explícita é confirmado.
SELECT @@autocommit AS AUTOCOMMIT;


-- =====================================================================
-- 6.4.1 EXEMPLO 1 — COMMIT (a alteração passa a valer de forma definitiva)
-- =====================================================================
-- Objetivo: inserir um registro de exibição e confirmar com COMMIT. O
-- registro continua existindo depois do fim da transação.
-- O valor 'TESTE_COMMIT' em ORIGEM_ACESSO identifica a linha de teste
-- para que o Exemplo 4 possa removê-la no final.
START TRANSACTION;

INSERT INTO HISTORICO_VISUALIZACAO
       (CODIGO_PERFIL, CODIGO_CONTEUDO, DATA_HORA_INICIO, DATA_HORA_FIM,
        TEMPO_ASSISTIDO_SEG, PERCENTUAL_PROGRESSO, CONCLUIDO, ORIGEM_ACESSO)
VALUES (1, 30, NOW(), DATE_ADD(NOW(), INTERVAL 45 MINUTE),
        2700, 50.00, 0, 'TESTE_COMMIT');

-- Ainda dentro da transação: a linha já é visível para esta sessão.
SELECT 'DENTRO DA TRANSAÇÃO' AS MOMENTO, CODIGO, CODIGO_PERFIL, CODIGO_CONTEUDO
  FROM HISTORICO_VISUALIZACAO
 WHERE ORIGEM_ACESSO = 'TESTE_COMMIT';

-- Confirma a transação.
COMMIT;

-- Depois do COMMIT: a linha continua lá (foi gravada em definitivo).
SELECT 'APÓS O COMMIT' AS MOMENTO, CODIGO, CODIGO_PERFIL, CODIGO_CONTEUDO
  FROM HISTORICO_VISUALIZACAO
 WHERE ORIGEM_ACESSO = 'TESTE_COMMIT';

-- ROLLBACK

-- =====================================================================
-- 6.4.2 EXEMPLO 2 — ROLLBACK (a alteração é descartada)
-- =====================================================================
-- Objetivo: simular um reajuste de preço e uma exclusão indevida e
-- desfazer tudo com ROLLBACK. O banco volta ao estado anterior.
SELECT 'ANTES' AS MOMENTO, CODIGO, PRECO FROM PLANO WHERE CODIGO = 7;
SELECT 'ANTES' AS MOMENTO, COUNT(*) AS ITENS_MINHA_LISTA FROM MINHA_LISTA;

START TRANSACTION;

UPDATE PLANO SET PRECO = 99.90 WHERE CODIGO = 7;
DELETE FROM MINHA_LISTA WHERE CODIGO = 30;

-- Dentro da transação as alterações são visíveis...
SELECT 'DENTRO DA TRANSAÇÃO' AS MOMENTO, CODIGO, PRECO FROM PLANO WHERE CODIGO = 7;
SELECT 'DENTRO DA TRANSAÇÃO' AS MOMENTO, COUNT(*) AS ITENS_MINHA_LISTA FROM MINHA_LISTA;

-- ...e o ROLLBACK desfaz o UPDATE e o DELETE.
ROLLBACK;

SELECT 'APÓS O ROLLBACK' AS MOMENTO, CODIGO, PRECO FROM PLANO WHERE CODIGO = 7;
SELECT 'APÓS O ROLLBACK' AS MOMENTO, COUNT(*) AS ITENS_MINHA_LISTA FROM MINHA_LISTA;


-- =====================================================================
-- 6.4.3 EXEMPLO 3 — SAVEPOINT (rollback parcial)
-- =====================================================================
-- O SAVEPOINT marca um ponto intermediário: é possível desfazer só o que
-- veio depois dele, mantendo o que foi feito antes.
-- Aqui o reajuste do plano 7 é mantido e o do plano 8 é desfeito; no
-- final, um ROLLBACK geral descarta a transação inteira, inclusive o 7.
START TRANSACTION;

UPDATE PLANO SET PRECO = 59.90 WHERE CODIGO = 7;
SAVEPOINT APOS_REAJUSTE_7;

UPDATE PLANO SET PRECO = 149.90 WHERE CODIGO = 8;

SELECT 'APÓS OS DOIS AJUSTES' AS MOMENTO, CODIGO, PRECO
  FROM PLANO WHERE CODIGO IN (7, 8) ORDER BY CODIGO;

ROLLBACK TO SAVEPOINT APOS_REAJUSTE_7;

SELECT 'APÓS ROLLBACK PARCIAL' AS MOMENTO, CODIGO, PRECO
  FROM PLANO WHERE CODIGO IN (7, 8) ORDER BY CODIGO;

ROLLBACK;

SELECT 'APÓS ROLLBACK TOTAL' AS MOMENTO, CODIGO, PRECO
  FROM PLANO WHERE CODIGO IN (7, 8) ORDER BY CODIGO;


-- =====================================================================
-- 6.4.4 EXEMPLO 4 — LIMPEZA DO TESTE (outro COMMIT)
-- =====================================================================
-- Remove a linha inserida no Exemplo 1 e confirma a limpeza, devolvendo
-- o banco ao estado em que estava antes deste arquivo.
START TRANSACTION;

DELETE FROM HISTORICO_VISUALIZACAO WHERE ORIGEM_ACESSO = 'TESTE_COMMIT';

COMMIT;

SELECT 'APÓS A LIMPEZA' AS MOMENTO, COUNT(*) AS REGISTROS
  FROM HISTORICO_VISUALIZACAO
 WHERE ORIGEM_ACESSO = 'TESTE_COMMIT';
