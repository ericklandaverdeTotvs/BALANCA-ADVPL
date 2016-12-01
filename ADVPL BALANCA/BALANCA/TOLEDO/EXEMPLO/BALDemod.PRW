#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ BalDemo  ³ Autor ³  ACD                  ³ Data ³ 30/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para teste do uso de balanca Toledo               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ CBBalToledo³ Autor ³ Desenv.    ACD      ³ Data ³ 30/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Seta as configuracoes para Balanca Toledo                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³PARAMETROS ³ cCOM 		= Define a porta Serial                         ³±±
±±³           ³ cConector 	= Define o conector a sr utilizado              ³±±
±±³           ³ cCanal 		= Define qual canal do conector                 ³±±
±±³           ³ cBalanca 	= Define a balanca ligada no canal do coletor.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno	  ³ Array      = {nBruto,nLiquido,nTara}                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
#DEFINE OneStopBit   '0'
#DEFINE One5StopBits '1'
#DEFINE TwoStopBits  '2'

#DEFINE NoParity 		'0'
#DEFINE OddParity    '1'
#DEFINE EvenParity   '2'
#DEFINE MarkParity   '3'
#DEFINE SpaceParity  '4'

USER FUNCTION BALDEMO1  
Local oDlg,oFont   
Private oBruto,oLiq,oTara
Private nBruto
Private nTara 
Private nLiq  

DEFINE FONT oFont	NAME "Arial" Size 11,15 BOLD  	
DEFINE MSDIALOG oDlg FROM 5, 5 TO 15, 65 TITLE OemToAnsi("Teste balanca direto") FONT oFont
   @ 0.5,40 BUTTON "Carrega" SIZE 60,15  ACTION CarregaPeso() 
   @ 2.0,40 BUTTON "Fechar"  SIZE 60,15  ACTION oDlg:End()
   
   @ 0.7,01.3 SAY "Bruto        "  
   @ 2.2,01.3 SAY "Liquido      "
   @ 3.7,01.3 SAY "Tara         "

	@ 0.5,08.0 MSGET oBruto   VAR nBruto     PICTURE "@E 99999999.999"          SIZE 085,13 
	@ 2.0,08.0 MSGET oLiq     VAR nLiq       PICTURE "@E 99999999.999"          SIZE 085,13 
	@ 3.5,08.0 MSGET oTara    VAR nTara      PICTURE "@E 99999999.999"          SIZE 085,13 


ACTIVATE MSDIALOG oDlg CENTERED

Return .T.


Static Function CarregaPeso()
Local cPorta   := "COM1"
Local cBaudRate:= "4800"
Local cParity  := EvenParity
Local cData    := "7"
Local cStop    := OneStopBit
Local cTimeOut := "00500"
Local cSettings:= cBaudRate+','+cParity+','+cData+','+cStop+','+cTimeOut
Local nH       := fopenPort(cPorta,cSettings,2)

If nH == -1      
	return "ERRO- NAO ABRIU A PORTA"
EndIf	

While .t.    
	cConteudo := Space(17)
	while Empty(cConteudo)
		nbytes:=fread(nH,@cConteudo,17)
		sleep(100)
	end	       
	If Empty(Subs(cConteudo,4))
	   Loop
	EndIf                       
	nLiq  := Val(subs(cConteudo,4,6))
	nTara := Val(subs(cConteudo,10,6))
	nBruto := nLiq+nTara 
   exit
End         
fclose(nH)

oBruto:Refresh()
oTara:Refresh() 
oLiq:Refresh()

Return




