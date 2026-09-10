begin;
merge into dw.dm_setor ds
using(
	select nk_cod_setor, setor
	from link.dm_setor order by 1
) MERGE_SUBQUERY

on(ds.nk_cod_setor = MERGE_SUBQUERY.nk_cod_setor)

when not matched then
insert(
	nk_cod_setor,
	setor
)
values(
	MERGE_SUBQUERY.nk_cod_setor,
	MERGE_SUBQUERY.setor
)
when matched and(
	ds.setor is distinct from MERGE_SUBQUERY.setor
)
then update set
	setor = MERGE_SUBQUERY.setor,
	etl_dt_ultimo_dado = current_timestamp,
	etl_versao = ds.etl_versao + 1;
commit;