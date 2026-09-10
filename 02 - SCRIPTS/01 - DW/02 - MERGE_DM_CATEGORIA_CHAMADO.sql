begin;
merge into core.dm_categoria_chamado dcc
using(
	select sc.cod_categoria, ds.nk_cod_setor as cod_setor, sc.categoria
		from stage.stg_categoria_chamado sc 
		join core.dm_setor ds
	on sc.cod_setor = ds.nk_cod_setor
) MERGE_SUBQUERY

on(dcc.nk_cod_categoria = MERGE_SUBQUERY.cod_categoria)

when no matched then
insert(
	nk_cod_categoria,
	sk_cod_setor,
	categoria
)
values(
	MERGE_SUBQUERY.cod_categoria,
	MERGE_SUBQUERY.cod_setor,
	MERGE_SUBQUERY.categoria
)
when matched and(
	dcc.nk_cod_categoria is distinct from MERGE_SUBQUERY.cod_categoria
	or dcc.sk_cod_setor is distinct from MERGE_SUBQUERY.cod_setor
	or dcc.categoria is distinct from MERGE_SUBQUERY.categoria
)
then update set
	nk_cod_categoria = MERGE_SUBQUERY.cod_categoria,
	sk_cod_setor = MERGE_SUBQUERY.cod_setor,
	categoria = MERGE_SUBQUERY.categoria,
	etl_ultimo_dado = current_timestamp,
	etl_versao = fc.etl_versao + 1;
commit;
