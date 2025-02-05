Estrutura para o funcionamento do banco de dados.


create database meu_banco;
use meu_banco;

CREATE TABLE administrador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL
);
INSERT INTO administrador (email, senha) VALUES ('exemplo@dominio.com', 'senha123');

CREATE TABLE pessoafisica (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    cep VARCHAR(9) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    datanasc DATE NOT NULL,
    estado VARCHAR(2) NOT NULL,
    genero VARCHAR(20) NOT NULL
);
CREATE TABLE pessoajuridica (
    cnpj VARCHAR(18) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    cep VARCHAR(9) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    estado VARCHAR(2) NOT NULL
);

select * from pessoafisica;
