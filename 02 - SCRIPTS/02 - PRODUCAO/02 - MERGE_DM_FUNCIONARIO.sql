begin;
merge into dw.dm_funcionario ddf
using(
	select ldf.nk_cod_funcionario,
			ds.sk_cod_setor,
			ldf.funcionario,
			ldf.email,
			ldf.cpf,
			ldf.telefone
		from link.dm_funcionario ldf 
		join link.dm_setor lds
			on ldf.sk_cod_setor = lds.sk_cod_setor
		join dw.dm_setor ds
			on ds.nk_cod_setor = lds.nk_cod_setor
		order by 1
) MERGE_SUBQUERY
	
on(ddf.nk_cod_funcionario = MERGE_SUBQUERY.nk_cod_funcionario)

when not matched then 
insert(
	nk_cod_funcionario,
	sk_cod_setor,
	funcionario,
	email,
	cpf,
	telefone
)
values(
	MERGE_SUBQUERY.nk_cod_funcionario,
	MERGE_SUBQUERY.sk_cod_setor,
	MERGE_SUBQUERY.funcionario,
	MERGE_SUBQUERY.email,
	MERGE_SUBQUERY.cpf,
	MERGE_SUBQUERY.telefone
)

when matched and(
	ddf.sk_cod_setor is distinct from MERGE_SUBQUERY.sk_cod_setor
	or ddf.funcionario is distinct from MERGE_SUBQUERY.funcionario
	or ddf.email is distinct from MERGE_SUBQUERY.email
	or ddf.cpf is distinct from MERGE_SUBQUERY.cpf
	or ddf.telefone is distinct from MERGE_SUBQUERY.telefone
)

then update set
	sk_cod_setor = MERGE_SUBQUERY.sk_cod_setor,
	funcionario = MERGE_SUBQUERY.funcionario,
	email = MERGE_SUBQUERY.email,
	cpf = MERGE_SUBQUERY.cpf,
	telefone = MERGE_SUBQUERY.telefone,
	etl_dt_ultimo_dado = current_timestamp,
	etl_versao = ddf.etl_versao + 1;
commit;
