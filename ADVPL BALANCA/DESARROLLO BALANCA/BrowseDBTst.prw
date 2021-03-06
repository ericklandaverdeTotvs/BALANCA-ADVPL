#include "TOTVS.CH"
//---------------------------------------------------------
// Exemplo de Browse com uso de Tabela
//---------------------------------------------------------
User Function BrowseDBTst()

  DEFINE DIALOG oDlg TITLE "Componentes de la Orden de Produccion" FROM 180,180 TO 550,700 PIXEL
    
    cQuery  := " SELECT *"
    cQuery  += " FROM "+RetSQLName("SC2")
    cQuery  += " WHERE  C2_FILIAL = '"+xFILIAL("SC2")+"' AND C2_OK != '' AND D_E_L_E_T_ <> '*' " 
    cQuery  += " ORDER BY C2_NUM"
    cQuery  := changequery(cQuery)

    cDatos := GetNextAlias()
    dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cDatos,.T.,.T.) 

    DbSelectArea('SD4')
    DBSETORDER(2)
    //D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
    DBSEEK(xfilial("SD4") + (cDatos)->C2_NUM + (cDatos)->C2_PRODUTO + (cDatos)->C2_LOCAL)

    oBrowse := BrGetDDB():New( 1,1,260,156,,,,oDlg,,,,,,,,,,,,.F.,'SD4',.T.,,.F.,,, )
    oBrowse:AddColumn(TCColumn():New('Codigo'               ,{||SD4->D4_COD },,,,'LEFT',,.F.,.F.,,,,.F.,))
    oBrowse:AddColumn(TCColumn():New('Orden de produccion'  ,{||SD4->D4_OP},,,,'LEFT',,.F.,.F.,,,,.F.,))
    oBrowse:AddColumn(TCColumn():New('Fecha'                ,{||SD4->D4_DATA},,,,'LEFT',,.F.,.F.,,,,.F.,))

    // Evento de clique no cabeçalho do browse
    oBrowse:bHeaderClick := {|o,x| Alert('bHeaderClick'+Chr(13)+;
                                   'Coluna:'+StrZero(x,3)) } 
                               
    // Evento de clicar duas vezes na célula
    //oBrowse:bLDblClick   := {|z,x| Alert('bLDblClick'+Chr(13)+;
                                         //'Linha:'+StrZero(oBrowse:nAt,3)+Chr(13)+;
                                         //'Coluna:'+StrZero(x,3) ) }
    oBrowse:bLDblClick   := {|z,x| U_zLogin() } 
    
    // Cria botões com métodos básicos do Browse
    TButton():New( 160, 002, "GoUp()", oDlg,{|| oBrowse:GoUp(),;
     oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 052, "GoDown()"	, oDlg,{|| oBrowse:GoDown(),;
     oBrowse:setFocus()	},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 102, "GoTop()"	, oDlg,{|| oBrowse:GoTop(),;
     oBrowse:setFocus() 	},40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 160, 152, "GoBottom()", oDlg,{|| oBrowse:GoBottom(),;
     oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 002, "Linha atual", oDlg,{|| alert(oBrowse:nAt) },;
     40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 052, "Nr Linhas", oDlg,{|| alert(oBrowse:nLen)	},;
     40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 102, "Linhas visiveis", oDlg,{|| alert(oBrowse:nRowCount()) },;
     40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    TButton():New( 172, 152, "Alias", oDlg,{|| alert(oBrowse:cAlias) },;
     40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
    
  ACTIVATE DIALOG oDlg CENTERED 
Return