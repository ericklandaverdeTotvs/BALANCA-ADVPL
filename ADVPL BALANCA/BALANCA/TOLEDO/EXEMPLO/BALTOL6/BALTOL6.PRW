#INCLUDE "PROTHEUS.CH"

STATIC __CANAL := 0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DEMOTOL6 ³ Autor ³  ACD                  ³ Data ³ 30/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para teste do uso de balanca Toledo PCLINK ver. 6 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



////////////////////////////////////////////////////////////////////////////////
// Funçao auxiliar:							    											  //	
// CBGetCanal() - Retorna o valor do canal corrente, se gerar erro de conexão //
//		ou se a balança não foi encontrada o valor retornado será zero /
////////////////////////////////////////////////////////////////////////////////	
User Function DEMOTOL6
Local oDlg,oFont,oCom,oCanal             
Local cBalanca := "" ,cTipoCOM := "", cCom := Space(15), cCanal := "A"
Local aBalanca := {"1 - 9091","2 - Ohaus"}  
Local aTipoCOM := {"IP","COM"}
Private aPesos := {0,0,0}
Private oBruto,oLiq,oTara                           


DEFINE FONT oFont	NAME "Arial" Size 11,15 BOLD  	
DEFINE MSDIALOG oDlg FROM 5, 5 TO 25, 65 TITLE OemToAnsi("Teste DLL Toledo") FONT oFont
   @ 0.2,40 BUTTON "Iniciar Conexao" SIZE 60,15  ACTION CarregaPeso(2,"",cTipoCOM,cCom,cCanal,CBGetCanal(),Val(Left(cBalanca,1))) 
   @ 1.7,40 BUTTON "Fim Conexao" SIZE 60,15  ACTION CarregaPeso(1,@aPesos,cTipoCOM,cCom,cCanal,CBGetCanal(),Val(Left(cBalanca,1))) 
   @ 3.2,40 BUTTON "Carregar" SIZE 60,15  ACTION CarregaPeso(3,@aPesos,cTipoCOM,cCom,cCanal,CBGetCanal(),Val(Left(cBalanca,1)))    
   @ 5.5,40 BUTTON "Fechar"  SIZE 60,15  ACTION (oDlg:End())
      
   @ 0.5,01.3 SAY "Balanca:" 
   @ 2.2,01.3 SAY "Conexao:"                                                 
	@ 3.7,01.3 SAY "IP/Porta:"       
	@ 5.2,01.3 SAY "Canal:"
   
   @ 0.2,08.0 COMBOBOX cBalanca ITEMS aBalanca SIZE 85,12 
   @ 2.0,08.0 COMBOBOX cTipoCOM  ITEMS aTipoCOM  SIZE 85,12 
   @ 3.5,08.0 MSGET oCom		VAR cCom        SIZE 85,13   
   @ 5.0,08.0 MSGET oCanal		VAR cCanal        SIZE 85,13      
   
   @ 7.7,01.3 SAY "Bruto:     "  
   @ 9.2,01.3 SAY "Tara:      "
   @ 10.7,01.3 SAY "Liquido:   "

	@ 7.5,08.0 MSGET oBruto   VAR aPesos[1]       PICTURE "@E 9999.999"        SIZE 085,13 
	@ 9.0,08.0 MSGET oTara    VAR aPesos[2]      PICTURE "@E 9999.999"          SIZE 085,13 
	@ 10.5,08.0 MSGET oLiq     VAR aPesos[3]      PICTURE "@E 9999.999"          SIZE 085,13 

ACTIVATE MSDIALOG oDlg CENTERED  VALID (CarregaPeso(0,"",cTipoCOM,cCom,cCanal,Val(Left(cBalanca,1))))
Return .T.


Static Function CarregaPeso(nAcao,aPesos,cTipCON,cCom,cCanal,nCanal,nBal)
	aPesos	:= AClone(CBBalTol6(cTipCON, cCom, cCanal,nCanal,nBal,0,nAcao))    
	If nAcao = 2 .AND. CBGetCanal() < 0
		Alert("Erro de comunicacao com a balanca!")	
	EndIf                                         
	
	oBruto:Refresh()   
	oTara:Refresh()
	oLiq:Refresh()
Return .t.



////////////////////////////////////////////////////////////////////////////////
// cTIPOCON:   Informa o tipo de comunicacao                                  //
// cCom:       Porta/IP                                                       //
// cCanal:     Canal de comunicacao da placa FIREX(A,B,C ou D).               //
// nCanalAt:   Numero do canal ativo                                          //
// nBalanca:    Tipo da balança:                                              //
//                1 - 9091                                                    //
//                2 - Ohaus                                                   //
// nSMov:      Indica será controlado movimento ou nao                        //
// nAcao:      Acao a ser executada:                                          //
//                0 - Fecha licensa de uso em relacao ao hardkey server       //
//                1 - Encerra comunicao                                       //
//                2 - Inicializa comunicação                                  //
//                3 - Ler Balanca                                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//	Retorno: 	Array[1] - Peso Bruto														//
//					Array[2] - Tara        														//
//					Array[3] - Peso Liquido                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////					
Static Function CBBalTol6(cTIPCON, cCom, cCanal,nCanalAt,nBalanca,nSMov,nAcao)
Local cPeso			:= Space(40)
Local cAux			:= ""
Local cSep			:= '|'   
Local nRetDll		:=ExecInDLLOpen("TOLEDO6.DLL") 
Local nPos			:= 0  
Local aRet 			:= {0,0,0}
DEFAULT cCom		:= '1'
DEFAULT cCanal	   := 'A'
DEFAULT nBalanca	:= 1
DEFAULT nSMov		:= 0 
cPeso 	:= AllTrim(cTIPCON) +cSep+ AllTrim(cCom)+cSep+ AllTrim(cCanal) +cSep+ ;
				AllTrim(Str(__CANAL)) +cSep+ AllTrim(Str(nBalanca)) +cSep+ ;
				AllTrim(Str(nSMov)) +cSep+ AllTrim(Str(nAcao))

If nRetDll== -1
	Final("TOLEDO.DLL Nao Localizada. Ela deve estar no diretorio REMOTE.")
Else	                          
   __CANAL 		:= ExeDLLRun2(nRetDll, 0, @cPeso )  
	
  ExecInDLLClose(nRetDll)   

  If nAcao = 3 
	  For nI := 1 To 3
	   nPos := At("|",cPeso)  
	 	cAux := Substr(cPeso,1,nPos-1)
	   aRet[nI] := Val(cAux)
	   cPeso 	:= Substr(cPeso,nPos+1,Len(cPeso))
	  Next
	EndIf  
EndIf	  

Return aRet 


Static Function CBGetCanal()
Return __CANAL       

Static Function CBSetCanal(nCANAL)
	__CANAL := nCANAL
Return
