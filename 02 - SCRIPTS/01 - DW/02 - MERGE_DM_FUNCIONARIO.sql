begin;
merge into core.dm_funcionario df
using(
select sf.cod_funcionario,
		ds.sk_cod_setor as cod_setor,
		sf.funcionario,
		sf.email,
		sf.cpf,
		sf.telefone
	from stage.stg_funcionario sf 
	join core.dm_setor ds
	on ds.nk_cod_setor = sf.cod_setor
) MERGE_SUBQUERY

on(df.nk_cod_funcionario = MERGE_SUBQUERY.cod_funcionario)

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
	MERGE_SUBQUERY.cod_funcionario,
	MERGE_SUBQUERY.cod_setor,
	MERGE_SUBQUERY.funcionario,
	MERGE_SUBQUERY.email,
	MERGE_SUBQUERY.cpf,
	MERGE_SUBQUERY.telefone
)
when matched and(
	df.sk_cod_setor is distinct from MERGE_SUBQUERY.cod_setor
	or df.funcionario is distinct from MERGE_SUBQUERY.funcionario
	or df.email is distinct from MERGE_SUBQUERY.email
	or df.cpf is distinct from MERGE_SUBQUERY.cpf
	or df.telefone is distinct from MERGE_SUBQUERY.telefone
)
then update set
	sk_cod_setor = MERGE_SUBQUERY.cod_setor,
	funcionario = MERGE_SUBQUERY.funcionario,
	email = MERGE_SUBQUERY.email,
	cpf = MERGE_SUBQUERY.cpf,
	telefone = MERGE_SUBQUERY.telefone,
	etl_dt_ultimo_dado = current_timestamp,
	etl_versao = df.etl_versao + 1;
commit;