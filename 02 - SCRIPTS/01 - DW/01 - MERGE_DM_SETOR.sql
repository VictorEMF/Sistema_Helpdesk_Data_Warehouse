begin;
merge into core.dm_setor ds
using(
	select * from stage.stg_setor ss
) MERGE_SUBQUERY

on(ds.nk_cod_setor = MERGE_SUBQUERY.cod_setor)

when no matched then
insert(
	nk_cod_setor,
	setor
)
values(
	MERGE_SUBQUERY.cod_setor,
	MERGE_SUBQUERY.setor
)
when matched and(
	ds.nk_cod_setor is distinct from MERGE_SUBQUERY.cod_setor
	or ds.setor is distinct from MERGE_SUBQUERY.setor
)
then update set
	nk_cod_setor = MERGE_SUBQUERY.cod_setor,
	setor = MERGE_SUBQUERY.setor,
	etl_ultimo_dado = current_timestamp,
	etl_versao = fc.etl_versao + 1;
commit;