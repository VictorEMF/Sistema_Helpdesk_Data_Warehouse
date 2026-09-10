begin;
merge into dw.ft_chamado fc
using(
	select 
		lfc.nk_cod_chamado,
		df_sol.sk_cod_funcionario as sk_cod_funcionario_sol,
		ds_sol.sk_cod_setor as sk_cod_setor_sol,
		df_resp.sk_cod_funcionario as sk_cod_funcionario_resp,
		ds_resp.sk_cod_setor as sk_cod_setor_resp,
		dcc.sk_cod_categoria,
		dd.sk_cod_data,
		lfc.status,
		lfc.descricao,
		lfc.atestado,
		lfc.dataCadastro,
		lfc.dataAtualiza
	from link.ft_chamado lfc
	left join link.dm_funcionario lf_sol on lfc.sk_cod_funcionario_solicitante = lf_sol.sk_cod_funcionario
	left join dw.dm_funcionario df_sol on df_sol.nk_cod_funcionario = lf_sol.nk_cod_funcionario
	-- funcionário responsável
	left join link.dm_funcionario lf_resp on lfc.sk_cod_funcionario_responsavel = lf_resp.sk_cod_funcionario
	left join dw.dm_funcionario df_resp on df_resp.nk_cod_funcionario = lf_resp.nk_cod_funcionario
	-- setor solicitante
	left join link.dm_setor ls_sol on lfc.sk_cod_setor_solicitante = ls_sol.sk_cod_setor
	left join dw.dm_setor ds_sol on ds_sol.nk_cod_setor = ls_sol.nk_cod_setor
	-- setor responsável
	left join link.dm_setor ls_resp on lfc.sk_cod_setor_responsavel = ls_resp.sk_cod_setor
	left join dw.dm_setor ds_resp on ds_resp.nk_cod_setor = ls_resp.nk_cod_setor
	-- categoria
	join link.dm_categoria_chamado lcc on lfc.sk_cod_categoria = lcc.sk_cod_categoria
	join dw.dm_categoria_chamado dcc on dcc.nk_cod_categoria = lcc.nk_cod_categoria
	-- data
	join link.dm_data ldd on lfc.sk_cod_data = ldd.sk_cod_data
	join dw.dm_data dd on dd.nk_cod_data = ldd.nk_cod_data
    order by 1
) MERGE_SUBQUERY

on(fc.nk_cod_chamado = MERGE_SUBQUERY.nk_cod_chamado)

when not matched then
insert(
	nk_cod_chamado,
	sk_cod_funcionario_solicitante,
	sk_cod_funcionario_responsavel,
	sk_cod_setor_solicitante,
	sk_cod_setor_responsavel,
	sk_cod_categoria,
	sk_cod_data,
	status,
	descricao,
	atestado,
	dataCadastro,
	dataAtualiza
)
values(
	MERGE_SUBQUERY.nk_cod_chamado,
	MERGE_SUBQUERY.sk_cod_funcionario_sol,
	MERGE_SUBQUERY.sk_cod_funcionario_resp,
	MERGE_SUBQUERY.sk_cod_setor_sol,
	MERGE_SUBQUERY.sk_cod_setor_resp,
	MERGE_SUBQUERY.sk_cod_categoria,
	MERGE_SUBQUERY.sk_cod_data,
	MERGE_SUBQUERY.status,
	MERGE_SUBQUERY.descricao,
	MERGE_SUBQUERY.atestado,
	MERGE_SUBQUERY.dataCadastro,
	MERGE_SUBQUERY.dataAtualiza
)

when matched and(
	fc.sk_cod_funcionario_solicitante is distinct from MERGE_SUBQUERY.sk_cod_funcionario_sol
	or fc.sk_cod_funcionario_responsavel is distinct from MERGE_SUBQUERY.sk_cod_funcionario_resp
	or fc.sk_cod_setor_solicitante is distinct from MERGE_SUBQUERY.sk_cod_setor_sol
	or fc.sk_cod_setor_responsavel is distinct from MERGE_SUBQUERY.sk_cod_setor_resp
	or fc.sk_cod_categoria is distinct from MERGE_SUBQUERY.sk_cod_categoria
	or fc.sk_cod_data is distinct from MERGE_SUBQUERY.sk_cod_data
	or fc.status is distinct from MERGE_SUBQUERY.status
	or fc.descricao is distinct from MERGE_SUBQUERY.descricao
	or fc.atestado is distinct from MERGE_SUBQUERY.atestado
	or fc.dataCadastro is distinct from MERGE_SUBQUERY.dataCadastro
	or fc.dataAtualiza is distinct from MERGE_SUBQUERY.dataAtualiza
)
then update set
	sk_cod_funcionario_solicitante = MERGE_SUBQUERY.sk_cod_funcionario_sol,
	sk_cod_funcionario_responsavel = MERGE_SUBQUERY.sk_cod_funcionario_resp,
	sk_cod_setor_solicitante = MERGE_SUBQUERY.sk_cod_setor_sol,
	sk_cod_setor_responsavel = MERGE_SUBQUERY.sk_cod_setor_resp,
	sk_cod_categoria = MERGE_SUBQUERY.sk_cod_categoria,
	sk_cod_data = MERGE_SUBQUERY.sk_cod_data,
	status = MERGE_SUBQUERY.status,
	descricao = MERGE_SUBQUERY.descricao,
	atestado = MERGE_SUBQUERY.atestado,
	dataCadastro = MERGE_SUBQUERY.dataCadastro,
	dataAtualiza = MERGE_SUBQUERY.dataAtualiza,
	etl_ultimo_dado = current_timestamp,
	etl_versao = fc.etl_versao + 1;
commit;