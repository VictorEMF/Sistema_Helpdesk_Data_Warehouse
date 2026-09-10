begin;
merge into dw.dm_categoria_chamado dcc
using(
	select ldc.nk_cod_categoria,
		ds.sk_cod_setor,
		ldc.categoria
	from link.dm_categoria_chamado ldc
	join link.dm_setor lds 
		on lds.sk_cod_setor = ldc.sk_cod_setor   
	join dw.dm_setor ds 
		on ds.nk_cod_setor = lds.nk_cod_setor 
	order by 1   
) MERGE_SUBQUERY

on(dcc.nk_cod_categoria = MERGE_SUBQUERY.nk_cod_categoria)

when not matched then
insert(
		nk_cod_categoria,
		sk_cod_setor,
		categoria	
)
values(
	MERGE_SUBQUERY.nk_cod_categoria,
	MERGE_SUBQUERY.sk_cod_setor,
	MERGE_SUBQUERY.categoria
)

when matched and(
	dcc.sk_cod_setor is distinct from MERGE_SUBQUERY.sk_cod_setor
	or dcc.categoria is distinct from MERGE_SUBQUERY.categoria
)
then update set
	sk_cod_setor = MERGE_SUBQUERY.sk_cod_setor,
	categoria = MERGE_SUBQUERY.categoria,
	etl_dt_ultimo_dado = current_timestamp,
	etl_versao = dcc.etl_versao + 1;
commit;