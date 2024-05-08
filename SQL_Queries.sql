-- Desempenhos dos funcionarios 
SELECT
    f.nome,
    f.cargo,
    COUNT(p.pedido_id) AS TotalPedidos
FROM
    [OUTBETH].[dbo].[Dimfuncionario] f
JOIN
    [OUTBETH].[dbo].[FatPedidos] p ON f.funcionario_id = p.funcionario_id
GROUP BY
    f.nome, f.cargo


--Tipo reclamação -> Quantide e qual funcionario está atrelado
SELECT 
    r.tipo_reclamacao,
    COUNT(*) AS quantidade_reclamacoes,
    f.nome AS NomeFuncionario
FROM 
    [OUTBETH].[dbo].[FatPedidos] p
JOIN 
    [OUTBETH].[dbo].[Dimreclamacoes] r ON p.pedido_id= r.pedido_id
JOIN 
    [OUTBETH].[dbo].[Dimfuncionario] f ON p.funcionario_id = f.funcionario_id
GROUP BY 
    r.tipo_reclamacao,
    f.nome;

-- Analise da Queda nos pedidos
SELECT 
    FORMAT(TRY_CONVERT(datetime, p.data_pedido, 101), 'yyyy-MM') AS mes,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(i.quantidade * i.preco_unitario) AS valor_total_vendido,
    AVG(i.quantidade * i.preco_unitario) AS valor_medio_por_pedido
FROM [OUTBETH].[dbo].[FatPedidos] p
JOIN [OUTBETH].[dbo].[DimItens_pedidos] i ON p.pedido_id = i.pedido_id
GROUP BY FORMAT(TRY_CONVERT(datetime, p.data_pedido, 101), 'yyyy-MM')

--Analise das reclamações por funcionario
SELECT 
    r.tipo_reclamacao,
    COUNT(*) AS quantidade_reclamacoes,
    FORMAT(TRY_CONVERT(datetime, p.data_pedido, 101), 'yyyy-MM') AS mes,
    f.nome AS nome_funcionario,
    c.nome AS nome_cliente
FROM [OUTBETH].[dbo].[Dimreclamacoes] r
JOIN [OUTBETH].[dbo].[FatPedidos] p ON r.pedido_id = p.pedido_id
JOIN [OUTBETH].[dbo].[Dimfuncionario] f ON p.funcionario_id = f.funcionario_id
JOIN [OUTBETH].[dbo].[Dimcliente] c ON p.cliente_id = c.cliente_id
WHERE TRY_CONVERT(datetime, p.data_pedido, 101) IS NOT NULL
GROUP BY r.tipo_reclamacao, FORMAT(TRY_CONVERT(datetime, p.data_pedido, 101), 'yyyy-MM'), f.nome, c.nome

--Analise das reclamações por data e tipo
SELECT
    p.data_pedido,
    r.tipo_reclamacao,
    COUNT(*) AS TotalReclamacoes
FROM
    [OUTBETH].[dbo].[Dimreclamacoes] r
JOIN
    [OUTBETH].[dbo].[FatPedidos] p ON TRY_CONVERT(datetime, p.data_pedido, 101) = r.data_reclamacao
GROUP BY
    p.data_pedido,r.tipo_reclamacao

--Analise desempenho detalhado dos funcionarios
SELECT
    f.nome AS NomeFuncionario,
    f.nivel_experiencia AS NivelExperiencia,
    f.data_contratacao AS DataEntrada,
    r.tipo_reclamacao AS TipoReclamacao,
    COUNT(r.reclamacao_id) AS TotalReclamacoes
FROM
    [OUTBETH].[dbo].[Dimfuncionario] f
LEFT JOIN
    [OUTBETH].[dbo].[FatPedidos] p ON f.funcionario_id = p.funcionario_id
LEFT JOIN
    [OUTBETH].[dbo].[Dimreclamacoes] r ON p.pedido_id = r.pedido_id
GROUP BY
    f.nome,
    f.nivel_experiencia,
    f.data_contratacao,
    r.tipo_reclamacao
ORDER BY
    f.nome, 
    TotalReclamacoes DESC;

--Analise receita dos produtos 
SELECT
    f.nome AS NomeFuncionario,
    f.nivel_experiencia AS NivelExperiencia,
    f.data_contratacao AS DataEntrada,
    r.tipo_reclamacao AS TipoReclamacao,
    COUNT(r.reclamacao_id) AS TotalReclamacoes
FROM
    [OUTBETH].[dbo].[Dimfuncionario] f
LEFT JOIN
    [OUTBETH].[dbo].[FatPedidos] p ON f.funcionario_id = p.funcionario_id
LEFT JOIN
    [OUTBETH].[dbo].[Dimreclamacoes] r ON p.pedido_id = r.pedido_id
GROUP BY
    f.nome,
    f.nivel_experiencia,
    f.data_contratacao,
    r.tipo_reclamacao
ORDER BY
    f.nome, 
    TotalReclamacoes DESC;

