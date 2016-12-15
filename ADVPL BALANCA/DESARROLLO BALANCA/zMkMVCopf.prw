
//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'
 
/*/{Protheus.doc} zMkMVC
MarkBrow em MVC da tabela de Artistas
@author Atilio
@since 03/09/2016
@version 1.0
@obs Criar a coluna ZZ1_OK com o tamanho 2 no Configurador e deixar como não usado
/*/

User Function zMkMVCopf()

	Private oMark
	Private cAliasAux

	//Criando o MarkBrow
	oMark := FWMarkBrowse():New()
	oMark:SetAlias("SC2")

	//Setando semáforo, descrição e campo de mark
	oMark:SetSemaphore(.T.)
	oMark:SetFilterDefault( "C2_DATRF==''" )

/*
	cAliasAux := 'ZZ1' //Seu Alias aqui
	lInvert   := .F.
	cMarca    := GetMark()
	oMark:AddMarkColumns({|| If((cAliasAux)->OK == cMarca, "LBTIK", "LBNO")}, {|| fMarcar(cMarca, lInvert, ,cAliasAux, @oMark), oMark:Refresh()}, {|| fMarcar(cMarca, lInvert, .T., cAliasAux, @oMark), oMark:Refresh(.T.)}) //Coluna de marcacao
	//FWMarkBrowse():AddMarkColumns(< bMark >, < bLDblClick >, < bHeaderClick >)-> NIL
	//bMark	Code-Block	Code-Block com a regra e deverá retornar a imagem referente a marcado/desmarcado
	//bLDblClick	Code-Block	Code-Block com a execução do duplo clique na coluna
	//bHeaderClick	Code-Block	Code-Block com a execução do clique no header da coluna */

	oMark:SetDescription('MI PAPA ERS HIJO DEL SANTO')
	//oMark:SetDescription('ORDENES DE PRODUCCION FIRMES |PROCESO DE PESADO |')
	oMark:SetFieldMark( 'C2_OK' )

    //Setando LegendaS
	//oMark:AddLegend( "SC2->C2_NUM == ''", "BROWN", "Ordenes de Produccion Firme Pendiente" )
    //oMark:AddLegend( Iif(Empty("SC2->C2_DATRF"), "BROWN", "Orden de Produccion Atendida" )
    oMark:AddLegend( "C2_TPOP=='F'", "BROWN", "Orden de Produccion Atendida" )

    //Ativando a janela
	oMark:Activate()
	MenuDef()
	ModelDef()
	ViewDef()
	MCFG6Invert(cMarca,lMarcar)
Return NIL

/*
Static Function fMarcar(cMarca, lInvert, lAll, cAliTRB, oMark)
*/

Return

Static Function MCFG6Invert(cMarca,lMarcar)
	Local cAliasSD1 := 'TRB'
	Local aAreaSD1  := (cAliasSD1)-&gt;( GetArea() )

    dbSelectArea(cAliasSD1)
    (cAliasSD1)-&gt;( dbGoTop() )
    While !(cAliasSD1)-&gt;( Eof() )
        RecLock( (cAliasSD1), .F. )
        (cAliasSD1)-&gt;TR_OK := IIf( lMarcar, cMarca, '  ' )
        MsUnlock()
        (cAliasSD1)-&gt;( dbSkip() )
    EndDo

	RestArea( aAreaSD1 )
Return .T.

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRotina := {}

//Criação das opções
	ADD OPTION aRotina TITLE 'Visualizar'			ACTION 'VIEWDEF.zModel1' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Modificar'			ACTION 'VIEWDEF.zModel1' OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'Processar'  ACTION 'u_zMarkProc'     OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Processar'			ACTION 'u_BrowseDBTst'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Enviar |Bascula 1|'	ACTION 'u_unoBalRodov'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Enviar |Bascula 2|'	ACTION 'u_dosBalRodov'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Enviar |Bascula 3|'	ACTION 'u_treBalRodov'   OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda' 				ACTION 'u_zMod1OpLeg'    OPERATION 2 ACCESS 0
Return aRotina
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
  
Static Function ModelDef()
Return FWLoadModel('zModel1')
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
  
Static Function ViewDef()
Return FWLoadView('zModel1')
 
/*/{Protheus.doc} zMarkProc
Rotina para processamento e verificação de quantos registros estão marcados
@author Atilio
@since 03/09/2016
@version 1.0
/*/
 
User Function zMarkProc()
    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()
    Local nCt      := 0
     
    //Percorrendo os registros da ZZ1

	cQuery  := " SELECT C2_FILIAL,C2_NUM"
	cQuery  += " FROM "+RetSQLName("SC2")
	cQuery  += " WHERE  C2_FILIAL = '"+xFILIAL("SC2")+"' AND C2_OK != '' AND D_E_L_E_T_ <> '*' " 
	cQuery  += " ORDER BY C6_NUM"
	cQuery  := changequery(cQuery)

    //SELECT C2_FILIAL,C2_NUM FROM SC2990 WHERE C2_FILIAL = 01 AND C2_OK != '' AND D_E_L_E_T_ <> '*' ORDER BY C2_NUM
    //MSGALERT(CQUERY)

	cDatos := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cDatos,.T.,.T.) 


	SC2->(DbGoTop())
	While !SC2->(EoF())
		//Caso esteja marcado, aumenta o contador
		If oMark:IsMark(cMarca)

            nCt++
            
            //Limpando a marca
            RecLock('SC2', .F.)
                C2_OK := ''
            SC2->(MsUnlock())
		EndIf

		//Pulando registro
		SC2->(DbSkip())
	EndDo

	//Mostrando a mensagem de registros marcados
	MsgInfo('Foram marcados <b>' + cValToChar( nCt ) + ' artistas</b>.', "Scane su gafete con el codigo de barras")

	//Restaurando área armazenada
	RestArea(aArea)
Return NIL