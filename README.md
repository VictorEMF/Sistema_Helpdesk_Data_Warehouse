# 🎫 Sistema Helpdesk & Data Warehouse

Solução de **Helpdesk, integração de dados, Data Warehouse e Business Intelligence**, desenvolvida para uma empresa com o objetivo de estruturar o processo de abertura e acompanhamento de chamados e transformar os dados operacionais em informações para análise.

O projeto integra **NocoDB, n8n, PostgreSQL e Power BI**, abrangendo desde o registro dos chamados pelos usuários até a disponibilização de indicadores para acompanhamento da operação.

---

## 📌 Sobre o projeto

O projeto surgiu da necessidade de organizar o processo de atendimento de solicitações internas e, ao mesmo tempo, criar uma estrutura que permitisse analisar os dados gerados pelos chamados.

A solução foi dividida em duas frentes:

### 🖥️ Sistema de Helpdesk

O sistema operacional foi desenvolvido utilizando o **NocoDB**, aproveitando recursos nativos como:

* Formulários para abertura de chamados;
* Tabelas para armazenamento dos registros;
* Visualizações para acompanhamento;
* Kanban para gerenciamento dos chamados;
* Filtros e organização das solicitações.

Dessa forma, os usuários passaram a contar com uma estrutura centralizada para registrar e acompanhar suas solicitações.

### 📊 Data Warehouse & BI

Os dados gerados pelo Helpdesk são integrados através do **n8n** e posteriormente tratados e armazenados em um **Data Warehouse desenvolvido em PostgreSQL**.

A estrutura permite disponibilizar os dados para o **Power BI**, possibilitando o acompanhamento de indicadores operacionais e análises históricas.

---

# 🏗️ Arquitetura da solução

```text
                         USUÁRIO
                            │
                            ▼
                 ┌─────────────────────┐
                 │        NocoDB       │
                 │                     │
                 │ • Formulários       │
                 │ • Tabelas           │
                 │ • Visualizações     │
                 │ • Kanban            │
                 └──────────┬──────────┘
                            │
                            │ Dados dos chamados
                            ▼
                 ┌─────────────────────┐
                 │         n8n         │
                 │                     │
                 │   Automação / ETL   │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │      PostgreSQL     │
                 │                     │
                 │       STAGE         │
                 │          ↓          │
                 │        CORE         │
                 │          ↓          │
                 │  Data Warehouse     │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │       Power BI      │
                 │                     │
                 │ Dashboards e KPIs   │
                 └─────────────────────┘
```

---

# 🖥️ Sistema de Helpdesk

O Helpdesk foi desenvolvido utilizando o **NocoDB**, permitindo estruturar o processo de atendimento sem a necessidade de desenvolver uma aplicação web tradicional.

## 📝 Abertura de chamados

Os usuários realizam a abertura das solicitações através de **Formulários do NocoDB**.

As informações fornecidas são registradas na estrutura operacional do Helpdesk e utilizadas durante o acompanhamento e tratamento do chamado.

```text
Usuário
   │
   ▼
Formulário
   │
   ▼
Chamado
   │
   ▼
Atendimento
   │
   ▼
Finalização
```

## 📋 Gerenciamento

Os chamados podem ser acompanhados utilizando diferentes visualizações disponibilizadas pelo NocoDB.

Entre os recursos utilizados estão:

* Formulários;
* Tabelas;
* Visualizações;
* Kanban;
* Filtros;
* Organização por status;
* Controle dos registros.

---

# 🔄 Integração e ETL

O **n8n** foi utilizado para automatizar o fluxo de dados entre o sistema de Helpdesk e o Data Warehouse.

O processo realiza a integração dos dados, tratamento das informações e preparação para carga no PostgreSQL.

```text
NocoDB
   │
   ▼
Extração
   │
   ▼
Tratamento
   │
   ▼
STAGE
   │
   ▼
Dimensões
   │
   ▼
Tabela Fato
   │
   ▼
Power BI
```

Entre os processos realizados estão:

* Extração dos dados;
* Tratamento e padronização;
* Conversão de tipos;
* Tratamento de valores nulos;
* Relacionamento entre entidades;
* Controle de chaves;
* Atualização dos registros;
* Carga das dimensões;
* Carga da tabela fato.

---

# 🗄️ Data Warehouse

O Data Warehouse foi desenvolvido em **PostgreSQL**, utilizando uma arquitetura organizada em camadas.

## STAGE

A camada `stage` funciona como área intermediária para os dados provenientes do sistema operacional.

Nessa etapa os dados são preparados para posterior carregamento no modelo dimensional.

Principais atividades:

* Recepção dos dados;
* Padronização;
* Tratamento;
* Validação;
* Preparação para carga.

## CORE

A camada `core` contém o modelo dimensional utilizado para análise.

A estrutura foi desenvolvida utilizando conceitos de **Data Warehouse e Modelagem Dimensional**, separando os dados em dimensões e tabela fato.

### Dimensões

Entre as dimensões utilizadas estão:

* `dm_data`
* `dm_usuario`
* `dm_setor`
* `dm_categoria`
* `dm_responsavel`

### Fato

A principal tabela fato é:

```text
ft_chamado
```

Ela concentra os eventos relacionados aos chamados e permite realizar análises através das dimensões do Data Warehouse.

---

# 📊 Business Intelligence

O **Power BI** foi utilizado para transformar os dados armazenados no Data Warehouse em informações para acompanhamento da operação.

Os dashboards permitem analisar aspectos como:

* Volume de chamados;
* Chamados por setor;
* Chamados por categoria;
* Chamados por status;
* Chamados por responsável;
* Evolução dos chamados ao longo do tempo;
* Tempo médio de atendimento;
* Distribuição dos chamados por período.

A estrutura permite acompanhar o comportamento dos chamados e gerar informações que auxiliam no acompanhamento operacional e na tomada de decisão.

---

# 🛠️ Tecnologias utilizadas

| Tecnologia       | Utilização                           |
| ---------------- | ------------------------------------ |
| **NocoDB**       | Sistema de Helpdesk                  |
| **NocoDB Forms** | Abertura de chamados                 |
| **n8n**          | Automação e ETL                      |
| **PostgreSQL**   | Data Warehouse                       |
| **SQL**          | Tratamento e transformação dos dados |
| **Power BI**     | Dashboards e indicadores             |
| **Git / GitHub** | Versionamento e documentação         |

---

# 🎯 Objetivos do projeto

* Estruturar o processo de abertura de chamados;
* Centralizar as solicitações internas;
* Facilitar o acompanhamento dos atendimentos;
* Automatizar o fluxo de dados;
* Criar uma estrutura de Data Warehouse;
* Aplicar conceitos de modelagem dimensional;
* Disponibilizar indicadores operacionais;
* Apoiar o acompanhamento e a tomada de decisão através de dados.

---

# 💡 Conceitos aplicados

O desenvolvimento da solução envolveu conceitos de:

* Data Warehouse;
* Modelagem dimensional;
* Star Schema;
* ETL;
* Staging;
* Data Quality;
* SQL;
* Automação de processos;
* Business Intelligence;
* KPIs;
* Visualização de dados.

---

# 📚 Documentação

A documentação técnica completa do projeto está disponível no repositório:

**[📄 Documentação do Helpdesk](./01%20-%20DOCUMENTAÇÃO/Documentação_helpdesk.pdf)**

O documento apresenta detalhes da solução, arquitetura, modelagem, processos e implementação.

---

# 📈 Resultado

A solução estabeleceu um fluxo integrado entre o processo operacional de atendimento e a camada analítica:

```text
                  OPERAÇÃO
                     │
                     ▼
                  NocoDB
                     │
                     ▼
                    n8n
                     │
                     ▼
                PostgreSQL
                     │
                     ▼
              Data Warehouse
                     │
                     ▼
                 Power BI
                     │
                     ▼
                 INDICADORES
```

Com isso, os dados gerados durante a operação do Helpdesk passaram a ser estruturados e disponibilizados para análises e acompanhamento através de indicadores.

---

# 👨‍💻 Desenvolvimento

**Victor Emanuel**

Projeto desenvolvido em ambiente empresarial, envolvendo **desenvolvimento de solução de Helpdesk, integração de dados, ETL, Data Warehouse e Business Intelligence**.

> Por questões de confidencialidade, informações identificáveis da empresa e dados reais dos usuários não são disponibilizados neste repositório.
