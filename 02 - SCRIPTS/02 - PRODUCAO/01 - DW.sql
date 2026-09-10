create table dw.dm_setor(
	sk_cod_setor int generated always as identity,
	nk_cod_setor int,
	setor varchar(150),
	etl_dt_primeiro_dado timestamp default current_timestamp,
	etl_dt_ultimo_dado timestamp default current_timestamp,
	etl_versao int default 1,
	constraint dm_setor_pk primary key(sk_cod_setor)
);

create table dw.dm_funcionario(
	sk_cod_funcionario int generated always as identity,
	nk_cod_funcionario int,
	sk_cod_setor int,
	funcionario varchar(100),
	email varchar(200),
	cpf varchar(15),
	telefone varchar(15),
	etl_dt_primeiro_dado timestamp default current_timestamp,
	etl_dt_ultimo_dado timestamp default current_timestamp,
	etl_versao int default 1,
	constraint dm_funcionario_pk primary key(sk_cod_funcionario)
);

alter table dw.dm_funcionario add CONSTRAINT dm_funcionario_sk_cod_setor foreign key(sk_cod_setor) references dw.dm_setor(sk_cod_setor);

create table dw.dm_categoria_chamado(
	sk_cod_categoria int generated always as identity,
	nk_cod_categoria int,
	sk_cod_setor int,
	categoria varchar(100),
	etl_dt_primeiro_dado timestamp default current_timestamp,
	etl_dt_ultimo_dado timestamp default current_timestamp,
    etl_versao int default 1,
	constraint dm_categoria_chamado_pk primary key(sk_cod_categoria)
);

alter table dw.dm_categoria_chamado add constraint dm_categoria_chamado_sk_cod_setor foreign key(sk_cod_setor) references dw.dm_setor(sk_cod_setor);


create table dw.ft_chamado(
	sk_cod_chamado int generated always as identity,
	nk_cod_chamado varchar,
	sk_cod_funcionario_solicitante int,
	sk_cod_funcionario_responsavel int,
	sk_cod_setor_solicitante int,
	sk_cod_setor_responsavel int,
	sk_cod_categoria int,
	sk_cod_data int,
	status varchar,
	descricao varchar,
	atestado boolean,
	dataCadastro timestamp,
	dataAtualiza timestamp,
	etl_primeiro_dado timestamp default current_timestamp,
	etl_ultimo_dado timestamp default current_timestamp,
    etl_versao int default 1,
	constraint ft_chamado_pk primary key(sk_cod_chamado)
);

alter table dw.ft_chamado add constraint ft_chamado_sk_cod_funcionario_solicitante foreign key(sk_cod_funcionario_solicitante) references dw.dm_funcionario(sk_cod_funcionario);
alter table dw.ft_chamado add constraint ft_chamado_sk_cod_funcionario_responsavel foreign key(sk_cod_funcionario_responsavel) references dw.dm_funcionario(sk_cod_funcionario);
alter table dw.ft_chamado add constraint ft_chamado_sk_cod_setor_solicitante foreign key(sk_cod_setor_solicitante) references dw.dm_setor(sk_cod_setor);
alter table dw.ft_chamado add constraint ft_chamado_sk_cod_setor_responsavel foreign key(sk_cod_setor_responsavel) references dw.dm_setor(sk_cod_setor);
alter table dw.ft_chamado add constraint ft_chamado_sk_cod_categoria foreign key(sk_cod_categoria) references dw.dm_categoria_chamado(sk_cod_categoria);
alter table dw.ft_chamado add constraint ft_chamado_sk_cod_data foreign key(sk_cod_data) references dw.dm_data(sk_cod_data);

insert into dw.dm_setor overriding system value values(-1, -1, 'N/A', '1900-01-01', '1900-01-01', -1);
insert into dw.dm_funcionario overriding system value values(-1, -1, -1, 'N/A', 'N/A', 'N/A', 'N/A', '1900-01-01', '1900-01-01', -1);
insert into dw.dm_categoria_chamado overriding system value values(-1, -1, -1, 'N/A', '19010-01-01', '1900-01-01', -1);
