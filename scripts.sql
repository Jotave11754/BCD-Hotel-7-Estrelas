-- ==========================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ==========================================
CREATE DATABASE hotel_7estrelas;
USE hotel_7estrelas;

-- ==========================================
-- 2. CRIAÇÃO DAS TABELAS (Modelagem Lógica)
-- ==========================================

CREATE TABLE Hospedes (
    id_hospede INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Quartos (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numero_quarto INT UNIQUE NOT NULL,
    tipo_quarto VARCHAR(50) NOT NULL, -- Ex: Standard, Luxo, Suite
    preco_diaria DECIMAL(10, 2) NOT NULL,
    status_quarto VARCHAR(20) DEFAULT 'Disponível' -- Disponível, Ocupado, Manutenção
);

CREATE TABLE Reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_hospede INT NOT NULL,
    id_quarto INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    status_reserva VARCHAR(20) DEFAULT 'Ativa', -- Ativa, Concluída, Cancelada
    FOREIGN KEY (id_hospede) REFERENCES Hospedes(id_hospede),
    FOREIGN KEY (id_quarto) REFERENCES Quartos(id_quarto)
);

CREATE TABLE Pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    data_pagamento DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    metodo_pagamento VARCHAR(50) NOT NULL, -- PIX, Cartão de Crédito, Dinheiro
    FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
);

-- ==========================================
-- 3. POPULANDO AS TABELAS (Min. 5 registros)
-- ==========================================

INSERT INTO Hospedes (nome, cpf, telefone, email) VALUES
('Ana Silva', '111.111.111-11', '11999999999', 'ana.silva@email.com'),
('Carlos Souza', '222.222.222-22', '21988888888', 'carlos.souza@email.com'),
('Mariana Costa', '333.333.333-33', '31977777777', 'mariana.costa@email.com'),
('João Pereira', '444.444.444-44', '41966666666', 'joao.pereira@email.com'),
('Beatriz Lima', '555.555.555-55', '51955555555', 'beatriz.lima@email.com');

INSERT INTO Quartos (numero_quarto, tipo_quarto, preco_diaria, status_quarto) VALUES
(101, 'Standard', 150.00, 'Disponível'),
(102, 'Standard', 150.00, 'Ocupado'),
(201, 'Luxo', 300.00, 'Ocupado'),
(202, 'Luxo', 300.00, 'Manutenção'),
(301, 'Suite Presidencial', 800.00, 'Disponível');

INSERT INTO Reservas (id_hospede, id_quarto, data_checkin, data_checkout, status_reserva) VALUES
(1, 102, '2023-10-01', '2023-10-05', 'Concluída'),
(2, 201, '2023-10-10', '2023-10-15', 'Ativa'),
(3, 301, '2023-11-01', '2023-11-10', 'Ativa'),
(4, 101, '2023-09-15', '2023-09-20', 'Concluída'),
(5, 202, '2023-12-20', '2023-12-25', 'Cancelada');

INSERT INTO Pagamentos (id_reserva, data_pagamento, valor_total, metodo_pagamento) VALUES
(1, '2023-10-05', 600.00, 'Cartão de Crédito'),
(2, '2023-10-10', 1500.00, 'PIX'),
(3, '2023-11-01', 7200.00, 'Cartão de Crédito'),
(4, '2023-09-20', 750.00, 'Dinheiro'),
(5, '2023-12-15', 0.00, 'Estorno');

-- ==========================================
-- 4. CONSULTAS (10 Exemplos Contextualizados)
-- ==========================================

-- 1. (WHERE) Quais são os quartos atualmente disponíveis para reserva?
SELECT numero_quarto, tipo_quarto, preco_diaria 
FROM Quartos 
WHERE status_quarto = 'Disponível';

-- 2. (LIKE) Buscar um hóspede específico cujo nome começa com 'Maria'.
SELECT nome, telefone, email 
FROM Hospedes 
WHERE nome LIKE 'Maria%';

-- 3. (ORDER BY) Qual a lista de quartos ordenados do mais barato para o mais caro?
SELECT numero_quarto, tipo_quarto, preco_diaria 
FROM Quartos 
ORDER BY preco_diaria ASC;

-- 4. (BETWEEN) Quais reservas foram feitas para o mês de outubro de 2023?
SELECT id_reserva, data_checkin, data_checkout 
FROM Reservas 
WHERE data_checkin BETWEEN '2023-10-01' AND '2023-10-31';

-- 5. (INNER JOIN) Relatório de hóspedes e os quartos que eles reservaram.
SELECT Hospedes.nome, Quartos.numero_quarto, Reservas.data_checkin, Reservas.data_checkout
FROM Reservas
INNER JOIN Hospedes ON Reservas.id_hospede = Hospedes.id_hospede
INNER JOIN Quartos ON Reservas.id_quarto = Quartos.id_quarto;

-- 6. (GROUP BY + COUNT) Quantas reservas cada hóspede já fez em nosso hotel?
SELECT Hospedes.nome, COUNT(Reservas.id_reserva) AS total_reservas
FROM Hospedes
INNER JOIN Reservas ON Hospedes.id_hospede = Reservas.id_hospede
GROUP BY Hospedes.nome;

-- 7. (SUM + GROUP BY) Qual o faturamento total do hotel separado por método de pagamento?
SELECT metodo_pagamento, SUM(valor_total) AS total_arrecadado
FROM Pagamentos
GROUP BY metodo_pagamento;

-- 8. (INNER JOIN + WHERE) Quais foram os pagamentos realizados via PIX e quem foi o hóspede?
SELECT Hospedes.nome, Pagamentos.valor_total, Pagamentos.data_pagamento
FROM Pagamentos
INNER JOIN Reservas ON Pagamentos.id_reserva = Reservas.id_reserva
INNER JOIN Hospedes ON Reservas.id_hospede = Hospedes.id_hospede
WHERE Pagamentos.metodo_pagamento = 'PIX';

-- 9. (MAX / MIN) Qual é a diária mais cara e a mais barata do hotel?
SELECT MAX(preco_diaria) AS quarto_mais_caro, MIN(preco_diaria) AS quarto_mais_barato 
FROM Quartos;

-- 10. (Complexa) Relatório financeiro: Valor total pago por reservas concluídas no ano de 2023.
SELECT SUM(Pagamentos.valor_total) AS receita_realizada_2023
FROM Pagamentos
INNER JOIN Reservas ON Pagamentos.id_reserva = Reservas.id_reserva
WHERE Reservas.status_reserva = 'Concluída' 
AND Pagamentos.data_pagamento BETWEEN '2023-01-01' AND '2023-12-31';
