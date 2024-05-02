
-- Consulta 1: Total de Vendas por Mês
SELECT 
    d.NomeMes,
    d.Ano,
    COUNT(p.pedido_id) AS TotalPedidos,
    SUM(i.quantidade * i.preco_unitario) AS TotalVendas
FROM
    Pedidos p
JOIN
    Itens_do_Pedido i ON p.pedido_id = i.pedido_id
JOIN
    DimensaoData d ON d.DataCompleta = p.data_pedido
GROUP BY
    d.NomeMes, d.Ano
ORDER BY
    d.Ano, d.Mes;

-- Consulta 2: Reclamações por Categoria por Mês
SELECT
    d.NomeMes,
    d.Ano,
    r.tipo_reclamacao,
    COUNT(*) AS TotalReclamacoes
FROM
    Reclamacoes r
JOIN
    DimensaoData d ON d.DataCompleta = r.data_reclamacao
GROUP BY
    d.NomeMes, d.Ano, r.tipo_reclamacao
ORDER BY
    d.Ano, d.Mes, r.tipo_reclamacao;

-- Consulta 3: Média de Pedidos por Dia da Semana
SELECT
    d.DiaSemana,
    AVG(count) AS MediaPedidos
FROM
    (SELECT
        data_pedido,
        COUNT(*) AS count
    FROM
        Pedidos
    GROUP BY
        data_pedido) AS DailyOrders
JOIN
    DimensaoData d ON d.DataCompleta = DailyOrders.data_pedido
GROUP BY
    d.DiaSemana
ORDER BY
    CASE
        WHEN d.DiaSemana = 'Segunda-feira' THEN 1
        WHEN d.DiaSemana = 'Terça-feira' THEN 2
        WHEN d.DiaSemana = 'Quarta-feira' THEN 3
        WHEN d.DiaSemana = 'Quinta-feira' THEN 4
        WHEN d.DiaSemana = 'Sexta-feira' THEN 5
        WHEN d.DiaSemana = 'Sábado' THEN 6
        WHEN d.DiaSemana = 'Domingo' THEN 7
    END;

-- Consulta 4: Desempenho dos Funcionários por Número de Pedidos
SELECT
    f.nome,
    f.cargo,
    COUNT(p.pedido_id) AS TotalPedidos
FROM
    Funcionarios f
JOIN
    Pedidos p ON f.funcionario_id = p.funcionario_id
GROUP BY
    f.nome, f.cargo
ORDER BY
    TotalPedidos DESC;

-- Consulta 5: Total de Vendas por Categoria de Produto
SELECT
    pr.categoria,
    SUM(i.quantidade * i.preco_unitario) AS TotalVendas
FROM
    Itens_do_Pedido i
JOIN
    Produto pr ON i.produto_id = pr.produto_id
GROUP BY
    pr.categoria;

-- Consulta 6: Detalhamento das Vendas por Produto no Último Ano
SELECT
    pr.nome,
    SUM(i.quantidade) AS QuantidadeVendida,
    SUM(i.quantidade * i.preco_unitario) AS Receita
FROM
    Itens_do_Pedido i
JOIN
    Produto pr ON i.produto_id = pr.produto_id
JOIN
    Pedidos p ON i.pedido_id = p.pedido_id
JOIN
    DimensaoData d ON d.DataCompleta = p.data_pedido
WHERE
    d.Ano = YEAR(CURRENT_DATE) - 1
GROUP BY
    pr.nome
ORDER BY
    Receita DESC;
