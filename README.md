# 🎫 Sistema Helpdesk & Data Warehouse

![status](https://img.shields.io/badge/status-Em_andamento-brightgreen)
<a href=""><img src="https://img.shields.io/badge/Github-repo-blue?logo=github" alt="Github"/></a>
<a href="https://n8n.io/"><img src="https://img.shields.io/badge/N8N-Tech-blue?logo=n8n" alt="N8N"/></a>
<a href="https://www.postgresql.org/"><img src="https://img.shields.io/badge/Postgres-Database-blue?logo=postgresql&logoColor=white" alt="Postgres"/></a>
<a href="https://nocodb.com/"><img src="https://img.shields.io/badge/NocoDB-Database-red" alt="NocoDB"/></a>
<a href="https://www.microsoft.com/pt-br/power-platform/products/power-bi"><img src="https://img.shields.io/badge/Power_BI-Visualization-orange" alt="Power BI"/></a>

# 📋 Sobre o Projeto


Projeto completo de **Sistema de Helpdesk integrado a um Data Warehouse**, desenvolvido para registrar, controlar e analisar chamados internos de uma organização.

A solução foi construída utilizando o **NocoDB** como sistema operacional do Helpdesk, aproveitando seus recursos de **formulários, tabelas e visualizações**, enquanto o **PostgreSQL** é utilizado como base para o Data Warehouse e o **Power BI** como ferramenta de análise e visualização dos indicadores.

---

## 📌 Visão geral

O projeto é dividido em duas partes principais:

### 🖥️ Sistema de Helpdesk

O sistema operacional foi desenvolvido no **NocoDB**, permitindo que os usuários registrem e acompanhem solicitações através de formulários e visualizações.

O sistema permite organizar os chamados de acordo com informações como:

* Código do chamado
* Solicitante
* Setor
* Categoria
* Descrição
* Responsável
* Status
* Datas de cadastro e atualização
* Informações relacionadas ao atendimento

O NocoDB também é utilizado para disponibilizar diferentes visualizações dos chamados, facilitando o acompanhamento das solicitações.

### 📊 Data Warehouse

Os dados gerados pelo Helpdesk são posteriormente utilizados na construção de um **Data Warehouse em PostgreSQL**.

O DW foi desenvolvido para transformar os dados operacionais em uma estrutura adequada para análises históricas e geração de indicadores no Power BI.

---

# 🏗️ Arquitetura

```text
┌───────────────────────────┐
│       USUÁRIO             │
│                           │
│  Abertura de chamados     │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│          NocoDB            │
│                           │
│  • Formulários            │
│  • Tabelas                │
│  • Visualizações          │
│  • Kanban                 │
│  • Controle dos chamados  │
└─────────────┬─────────────┘
              │
              │ Dados operacionais
              ▼
┌───────────────────────────┐
│            n8n             │
│                           │
│  Integração e automação   │
│          do ETL           │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│        PostgreSQL          │
│                           │
│  ┌─────────────────────┐  │
│  │       STAGE         │  │
│  │                     │  │
│  │ Dados intermediários│  │
│  └──────────┬──────────┘  │
│             │             │
│             ▼             │
│  ┌─────────────────────┐  │
│  │        CORE         │  │
│  │                     │  │
│  │   Data Warehouse    │  │
│  └─────────────────────┘  │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│         Power BI           │
│                           │
│  • Indicadores            │
│  • Dashboards             │
│  • Análises               │
└───────────────────────────┘
```

---

# 🖥️ Sistema de Helpdesk

O Helpdesk foi desenvolvido utilizando o **NocoDB**, aproveitando seus recursos para criar uma aplicação de gerenciamento de chamados sem a necessidade de desenvolver uma aplicação web tradicional do zero.

## 📝 Abertura de chamados

Os usuários podem registrar solicitações através dos **formulários do NocoDB**.

O formulário funciona como a porta de entrada do sistema, coletando as informações necessárias para criação do chamado.

Fluxo:

```text
Usuário
   │
   ▼
Formulário NocoDB
   │
   ▼
Registro do chamado
   │
   ▼
Tabela de chamados
```

---

## 📋 Controle dos chamados

Após a criação, os chamados podem ser acompanhados através das visualizações disponibilizadas pelo NocoDB.

Entre os recursos utilizados estão:

* Visualização em tabela
* Formulários
* Kanban
* Filtros
* Organização por status
* Controle dos registros

Essas ferramentas permitem que diferentes setores acompanhem seus chamados de acordo com suas necessidades.

---

# 🔄 Integração e ETL

Para automatizar o fluxo de dados entre o sistema operacional e o Data Warehouse, foi utilizado o **n8n**.

O processo é responsável por buscar os dados do Helpdesk, realizar os tratamentos necessários e disponibilizá-los para carga no PostgreSQL.

Fluxo simplificado:

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

Durante o processo de ETL são realizados procedimentos como:

* Tratamento de dados;
* Padronização de campos;
* Conversão de tipos;
* Tratamento de valores nulos;
* Relacionamento entre entidades;
* Controle de chaves;
* Atualização dos registros;
* Carga das dimensões;
* Carga da tabela fato.

---

# 🗄️ Data Warehouse

O Data Warehouse foi implementado utilizando **PostgreSQL**.

A arquitetura foi organizada em camadas para separar os dados recebidos da estrutura analítica final.

## STAGE

A camada `stage` recebe os dados provenientes do sistema de Helpdesk.

Seu objetivo é funcionar como uma área intermediária para:

* Recepção dos dados;
* Padronização;
* Tratamento;
* Validação;
* Preparação para carga no modelo dimensional.

```text
stage
│
├── Dados de chamados
├── Dados de usuários
├── Dados de setores
└── Outros dados provenientes do Helpdesk
```

---

# ⭐ Modelo dimensional

Após o tratamento na camada de staging, os dados são carregados para a camada `core`.

A estrutura utiliza conceitos de **Modelagem Dimensional**, organizando as informações em dimensões e tabelas fato.

### Dimensões

As dimensões representam os diferentes contextos utilizados para analisar os chamados.

Exemplos:

```text
dm_data
dm_usuario
dm_setor
dm_categoria
dm_responsavel
```

### Tabela fato

A tabela fato concentra os eventos relacionados aos chamados.

```text
ft_chamado
```

Ela permite analisar os chamados utilizando as diferentes dimensões do Data Warehouse.

Uma representação simplificada:

```text
                 ┌──────────────┐
                 │   dm_data    │
                 └──────┬───────┘
                        │
                        │
┌──────────────┐   ┌────▼───────┐   ┌──────────────┐
│  dm_usuario  ├──►│ ft_chamado │◄──┤   dm_setor   │
└──────────────┘   └────┬───────┘   └──────────────┘
                        │
                        │
                 ┌──────▼───────┐
                 │ dm_categoria │
                 └──────────────┘
```

---

# 📊 Power BI

O **Power BI** é utilizado como camada de apresentação e análise dos dados armazenados no Data Warehouse.

Através dos dashboards é possível acompanhar o desempenho do Helpdesk e identificar padrões relacionados aos chamados.

## 📈 Indicadores

Entre as análises realizadas estão:

* Total de chamados;
* Chamados por setor;
* Chamados por categoria;
* Chamados por status;
* Chamados por responsável;
* Evolução dos chamados ao longo do tempo;
* Tempo médio de atendimento;
* Distribuição dos chamados por período.

Esses indicadores permitem transformar os dados operacionais do Helpdesk em informações úteis para acompanhamento e tomada de decisão.

---

# 🛠️ Tecnologias utilizadas

| Tecnologia       | Utilização                           |
| ---------------- | ------------------------------------ |
| **NocoDB**       | Sistema de Helpdesk                  |
| **NocoDB Forms** | Abertura dos chamados                |
| **n8n**          | Automação e integração dos dados     |
| **PostgreSQL**   | Banco de dados e Data Warehouse      |
| **SQL**          | Tratamento e transformação dos dados |
| **Power BI**     | Dashboards e indicadores             |
| **Git / GitHub** | Versionamento e documentação         |

---

# 📂 Estrutura do projeto

```text
Sistema_Helpdesk_Data_Warehouse/
│
├── 01 - DOCUMENTAÇÃO/
│   └── Documentação_helpdesk.pdf
│
├── 02 - MODELAGEM/
│   └── ...
│
├── 03 - ETL/
│   └── ...
│
├── 04 - SQL/
│   └── ...
│
├── 05 - POWER BI/
│   └── ...
│
└── README.md
```

---

# 📚 Documentação

A documentação detalhada do projeto está disponível no arquivo:

**[Documentação do Helpdesk](./01%20-%20DOCUMENTAÇÃO/Documentação_helpdesk.pdf)**

O documento apresenta os detalhes da solução, incluindo sua arquitetura, funcionamento, modelagem e processos envolvidos.

---

# 🎯 Objetivos do projeto

O projeto teve como principais objetivos:

* Criar um sistema funcional de Helpdesk;
* Facilitar a abertura e acompanhamento de chamados;
* Centralizar as informações das solicitações;
* Automatizar a integração dos dados;
* Construir um Data Warehouse;
* Aplicar conceitos de modelagem dimensional;
* Disponibilizar indicadores através do Power BI;
* Transformar dados operacionais em informações para análise.

---

# 💡 Conceitos aplicados

Durante o desenvolvimento foram aplicados conceitos de:

* **Data Warehouse**
* **Modelagem dimensional**
* **Star Schema**
* **ETL**
* **Staging**
* **Data Quality**
* **SQL**
* **Automação de processos**
* **Business Intelligence**
* **KPIs**
* **Visualização de dados**

