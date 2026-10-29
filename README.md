# BCD-Hotel-7-Estrelas

# 🏨 Banco de Dados - Hotel 7 Estrelas (Atividade III - BCD SEDUC)

## 1. Domínio do Banco de Dados
Sistema de Gestão de Hospedagem (Hotelaria).

## 2. Contextualização
**A Empresa:** O Hotel 7 Estrelas é um resort de luxo que estava gerenciando suas reservas, clientes e finanças através de planilhas e cadernos físicos.
**Os Problemas:** Sem um SGBD relacional, o hotel enfrentava problemas graves como: *overbooking* (duas pessoas reservando o mesmo quarto nas mesmas datas), perda de dados de clientes, dificuldade em gerar relatórios financeiros rápidos e inconsistência de dados (nomes digitados errados ou CPFs duplicados).

## 3. Proposta de Melhoria
Implementação de um Banco de Dados Relacional (SGBD) para centralizar as informações. O sistema garante:
- **Integridade:** CPFs não se repetem.
- **Relacionamento:** É impossível deletar um quarto que possui uma reserva ativa (integridade referencial).
- **Agilidade:** Consultas SQL substituem horas de busca em planilhas para descobrir quais quartos estão disponíveis hoje.

## 4. Modelagem Lógica
O banco foi estruturado em 4 tabelas principais:
1. **Hospedes:** `id_hospede (PK)`, `nome`, `cpf`, `telefone`, `email`.
2. **Quartos:** `id_quarto (PK)`, `numero_quarto`, `tipo_quarto`, `preco_diaria`, `status_quarto`.
3. **Reservas:** `id_reserva (PK)`, `id_hospede (FK)`, `id_quarto (FK)`, `data_checkin`, `data_checkout`, `status_reserva`. (Cardinalidade: 1 Hóspede para N Reservas / 1 Quarto para N Reservas).
4. **Pagamentos:** `id_pagamento (PK)`, `id_reserva (FK)`, `data_pagamento`, `valor_total`, `metodo_pagamento`. (Cardinalidade: 1 Reserva para 1 Pagamento).

## 5. Instruções SQL
Todos os scripts DDL (Criação), DML (Inserção) e DQL (10 Consultas complexas usando INNER JOIN, GROUP BY, SUM, etc.) encontram-se no arquivo `scripts.sql` neste repositório.

## 6. Hosting na Cloud AIVEN (Passo a Passo)
1. Crie uma conta gratuita no site [Aiven.io](https://aiven.io/).
2. No painel, clique em **"Create service"** e selecione o banco de dados (ex: MySQL ou PostgreSQL).
3. Selecione o plano gratuito (Free Plan) e a região (ex: AWS ou Google Cloud na América do Sul/EUA).
4. Clique em **"Create Service"**.
5. Aguarde o status ficar verde ("Running"). 
6. Na aba de "Overview", copie a `Service URI` (ou Host, Port, User e Password) para conectar o banco no seu cliente local (como DBeaver ou MySQL Workbench).

## 7. Como fazer o Dump do Banco (Backup de Estrutura e Dados)
Para gerar o arquivo `.sql` de backup usando a linha de comando (mysqldump):
1. Abra o terminal (ou Prompt de Comando).
2. Execute o comando:
   `mysqldump -u [usuario_da_nuvem] -p -h [host_da_aiven] --port [porta] hotel_7estrelas > backup_hotel.sql`
3. Insira a senha quando solicitado.
4. O arquivo `backup_hotel.sql` será criado na pasta atual com toda a estrutura (CREATE TABLES) e dados (INSERTS) prontos para serem restaurados.
