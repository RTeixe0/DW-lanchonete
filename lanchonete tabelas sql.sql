-- Criação da Tabela: Clientes 
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(100),
    sexo_cliente VARCHAR(10),
    frequencia_visitas INT,
    endereco_rua VARCHAR(200),
    endereco_numero VARCHAR(20),
    endereco_complemento VARCHAR(100),
    endereco_bairro VARCHAR(100),
    endereco_cidade VARCHAR(100),
    endereco_estado VARCHAR(50),
    endereco_cep VARCHAR(20)
    data_nascimento DATE,
);

-- Criação da Tabela: Produtos
CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria_produto VARCHAR(50),
    preco_produto DECIMAL(7, 2)
);

-- Criação da Tabela: Funcionários
CREATE TABLE Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome_funcionario VARCHAR(100),
    cargo_funcionario VARCHAR(50)
);

-- Criação da Tabela: Lojas
CREATE TABLE Lojas (
    id_loja INT AUTO_INCREMENT PRIMARY KEY,
    endereco_loja VARCHAR(200),
    cidade_loja VARCHAR(100)
);

-- Criação da Tabela: Vendas
CREATE TABLE Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_produto INT,
    id_funcionario INT,
    id_loja INT,
    data_hora DATETIME,
    canal_venda VARCHAR(50),
    metodo_pagamento VARCHAR(30),
    promo_ativa BOOLEAN,
    valor_total DECIMAL(10, 2),
    reclamacao BOOLEAN,
    tipo_reclamacao VARCHAR(100),
    feedback TEXT,
    evento_externo VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario),
    FOREIGN KEY (id_loja) REFERENCES Lojas(id_loja)
);
