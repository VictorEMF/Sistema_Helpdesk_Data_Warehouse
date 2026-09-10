begin;
merge into core.ft_chamado fc
using(
	select sc.cod_chamado, 
	func_soli.sk_cod_funcionario as sk_cod_funcionario_sol, 
	set_soli.sk_cod_setor as sk_cod_setor_sol, 
	func_resp.sk_cod_funcionario as sk_cod_funcrionario_resp, 
	set_resp.sk_cod_setor as sk_cod_setor_resp, 
	dcc.sk_cod_categoria,
	dd.sk_cod_data,
	sc.status, 
	sc.descricao, 
	sc.atestado, 
	sc.datacadastro, 
	sc.dataatualiza  
		from stage.stg_chamado sc 
		left join core.dm_funcionario func_soli on sc.email_solicitante = func_soli.email
		left join core.dm_funcionario func_resp on sc.email_responsavel = func_resp.email
		left join core.dm_setor set_soli on sc.setor_solicitante = set_soli.setor
		left join core.dm_setor set_resp on sc.setor_responsavel = set_resp.setor
		join core.dm_categoria_chamado dcc on sc.categoria = dcc.categoria
		join core.dm_data dd on sc.datacadastro::date = dd.nk_cod_data
	
)MERGE_SUBQUERY 

on(fc.nk_cod_chamado = MERGE_SUBQUERY.cod_chamado)

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
	MERGE_SUBQUERY.cod_chamado,
	MERGE_SUBQUERY.sk_cod_funcionario_sol,
	MERGE_SUBQUERY.sk_cod_funcrionario_resp,
	MERGE_SUBQUERY.sk_cod_setor_sol,
	MERGE_SUBQUERY.sk_cod_setor_resp,
	MERGE_SUBQUERY.sk_cod_categoria,
	MERGE_SUBQUERY.sk_cod_data,
	MERGE_SUBQUERY.status,
	MERGE_SUBQUERY.descricao,
	MERGE_SUBQUERY.atestado,
	MERGE_SUBQUERY.datacadastro,
	MERGE_SUBQUERY.dataatualiza
)

when matched and(
	fc.nk_cod_chamado is distinct from MERGE_SUBQUERY.cod_chamado
	or fc.sk_cod_funcionario_solicitante is distinct from MERGE_SUBQUERY.sk_cod_funcionario_sol
	or fc.sk_cod_funcionario_responsavel is distinct from MERGE_SUBQUERY.sk_cod_funcrionario_resp
	or fc.sk_cod_setor_solicitante is distinct from MERGE_SUBQUERY.sk_cod_setor_sol
	or fc.sk_cod_setor_responsavel is distinct from MERGE_SUBQUERY.sk_cod_setor_resp
	or fc.sk_cod_categoria is distinct from MERGE_SUBQUERY.sk_cod_categoria
	or fc.sk_cod_data is distinct from MERGE_SUBQUERY.sk_cod_data
	or fc.status is distinct from MERGE_SUBQUERY.status
	or fc.descricao is distinct from MERGE_SUBQUERY.descricao
	or fc.atestado is distinct from MERGE_SUBQUERY.atestado
	or fc.dataCadastro is distinct from MERGE_SUBQUERY.datacadastro
	or fc.dataAtualiza is distinct from MERGE_SUBQUERY.dataatualiza
)
then update set
	nk_cod_chamado = MERGE_SUBQUERY.cod_chamado,
	sk_cod_funcionario_solicitante = MERGE_SUBQUERY.sk_cod_funcionario_sol,
	sk_cod_funcionario_responsavel = MERGE_SUBQUERY.sk_cod_funcrionario_resp,
	sk_cod_setor_solicitante = MERGE_SUBQUERY.sk_cod_setor_sol,
	sk_cod_setor_responsavel = MERGE_SUBQUERY.sk_cod_setor_resp,
	sk_cod_categoria = MERGE_SUBQUERY.sk_cod_categoria,
	sk_cod_data = MERGE_SUBQUERY.sk_cod_data,
	status = MERGE_SUBQUERY.status,
	descricao = MERGE_SUBQUERY.descricao,
	atestado = MERGE_SUBQUERY.atestado,
	dataCadastro = MERGE_SUBQUERY.datacadastro,
	dataAtualiza = MERGE_SUBQUERY.dataatualiza,
	etl_ultimo_dado = current_timestamp,
	etl_versao = fc.etl_versao + 1;
commit;