-- Criação do banco de dados
CREATE DATABASE lanchonete_beth;
USE lanchonete_beth;

-- Criação da tabela Clientes
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    data_nascimento DATE
);

-- Criação da tabela Endereço
CREATE TABLE Endereco (
    endereco_id INT PRIMARY KEY,
    rua VARCHAR(255),
    numero VARCHAR(255),
    complemento VARCHAR(255),
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(255),
    cep VARCHAR(255)
);

-- Criação da tabela Cliente_Endereco
CREATE TABLE Cliente_Endereco (
    cliente_id INT,
    endereco_id INT,
    PRIMARY KEY (cliente_id, endereco_id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (endereco_id) REFERENCES Endereco(endereco_id)
);

-- Criação da tabela Produto
CREATE TABLE Produto (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(255),
    categoria VARCHAR(255),
    preco DECIMAL(10, 2)
);

-- Criação da tabela Funcionarios
CREATE TABLE Funcionarios (
    funcionario_id INT PRIMARY KEY,
    nome VARCHAR(255),
    cargo VARCHAR(255),
    data_contratacao DATE,
    nivel_experiencia VARCHAR(255),
    status VARCHAR(255),
    qualificacoes VARCHAR(255)
);

-- Criação da tabela Pedidos
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    cliente_id INT,
    funcionario_id INT,
    data_pedido DATE,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(funcionario_id)
);

-- Criação da tabela Itens do Pedido
CREATE TABLE Itens_do_Pedido (
    item_id INT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- Criação da tabela Reclamações
CREATE TABLE Reclamacoes (
    reclamacao_id INT PRIMARY KEY,
    pedido_id INT,
    cliente_id INT,
    funcionario_id INT,
    data_reclamacao DATE,
    tipo_reclamacao VARCHAR(255),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(funcionario_id)
);

-- Criação tabela fato
CREATE TABLE Fato_Vendas_Reclamacoes (
    fato_id INT PRIMARY KEY AUTO_INCREMENT,
    data_id INT,
    cliente_id INT,
    funcionario_id INT,
    produto_id INT,
    quantidade_vendida INT,
    valor_vendas DECIMAL(10, 2),
    quantidade_reclamacoes INT DEFAULT 0,
    tipo_reclamacao VARCHAR(255),
    FOREIGN KEY (data_id) REFERENCES Data(DataCompleta),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(funcionario_id),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- Script preencher tabela fato
INSERT INTO Fato_Vendas_Reclamacoes
(data_id, cliente_id, funcionario_id, produto_id, quantidade_vendida, valor_vendas, quantidade_reclamacoes, tipo_reclamacao)
SELECT
    D.data_id,
    P.cliente_id,
    P.funcionario_id,
    IP.produto_id,
    SUM(IP.quantidade) AS quantidade_vendida,
    SUM(IP.quantidade * IP.preco_unitario) AS valor_vendas,
    COUNT(R.reclamacao_id) AS quantidade_reclamacoes,
    R.tipo_reclamacao
FROM
    Pedidos P
JOIN Itens_Pedidos IP ON P.pedido_id = IP.pedido_id
LEFT JOIN Reclamacoes R ON P.pedido_id = R.pedido_id
JOIN Data D ON D.DataCompleta = P.data_pedido
GROUP BY
    D.data_id,
    P.cliente_id,
    P.funcionario_id,
    IP.produto_id,
    R.tipo_reclamacao;
