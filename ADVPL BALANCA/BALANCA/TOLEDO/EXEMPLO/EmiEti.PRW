#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EMIETI   ³ Autor ³  Eduardo Motta        ³ Data ³ 03/01/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa para emissao de etiquetas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LEPESO()
LOCAL cFilPro     := Space(02)
LOCAL cProduto    := Space(15)
LOCAL cDesPro     := Space(30)
LOCAL cLote       := Space(10)
LOCAL dData       := CtoD("  /  /  ")
LOCAL nPeso       := 0.00
LOCAL oBmp
LOCAL oFilPro
LOCAL oProduto
LOCAL oDesPro
LOCAL oLote
LOCAL oData
LOCAL oPeso
LOCAL oFont

DEFINE FONT oFont	NAME "Arial" Size 11,15 BOLD  	



DEFINE MSDIALOG oDlg FROM 5, 5 TO 35, 80 TITLE OemToAnsi("Emissao de Etiquetas") FONT oFont
DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg

DEFINE BUTTON RESOURCE "S4WB005N" OF oBar ACTION NaoDisp() TOOLTIP "Recortar"
DEFINE BUTTON RESOURCE "S4WB006N" OF oBar ACTION NaoDisp() TOOLTIP "Copiar"
DEFINE BUTTON RESOURCE "S4WB007N" OF oBar ACTION NaoDisp() TOOLTIP "Colar"
DEFINE BUTTON RESOURCE "S4WB008N" OF oBar GROUP ACTION Calculadora() TOOLTIP "Calculadora..."
DEFINE BUTTON RESOURCE "S4WB009N" OF oBar ACTION Agenda() TOOLTIP "Agenda..."
DEFINE BUTTON RESOURCE "S4WB010N" OF oBar ACTION OurSpool() TOOLTIP OemToAnsi("Gerenciador de ImpressÆo...")

oBar:nGroups += 6

//DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION (ImpEti(oProduto,@cProduto,@cLote,@dData,@nPeso)) TOOLTIP "OK"

//SetKEY(15,oBtOk:bAction)
DEFINE BUTTON oBtCan RESOURCE "CANCEL" OF oBar ACTION oDlg:End() TOOLTIP "Cancel"
SetKEY(24,oBtCan:bAction)

   @ 07.2,01.3 SAY "Filial       "
   @ 08.7,01.3 SAY "Produto      "
   @ 10.2,01.3 SAY "Descricao    "
   @ 11.7,01.3 SAY "Lote         "
   @ 13.2,01.3 SAY "Data         "
   @ 14.7,01.3 SAY "Peso         "

	@ 07.0,08.0 MSGET oFilPro  VAR cFilPro     PICTURE "@!"                   SIZE 008,13
	@ 08.5,08.0 MSGET oProduto VAR cProduto    PICTURE "@!" Valid ChkPro(cFilPro+cProduto,oDesPro) SIZE 110,13
	@ 10.0,08.0 MSGET oDesPro  VAR cDesPro     WHEN .F.                      SIZE 210,13
	@ 11.5,08.0 MSGET oLote    VAR cLote       PICTURE "@!"                   SIZE 045,13
	@ 13.0,08.0 MSGET oData    VAR dData                                      SIZE 060,13
	@ 14.5,08.0 MSGET oPeso    VAR nPeso       PICTURE "@E 9999.999"          SIZE 085,13 when CarregaPeso(@nPeso)

//   @ 01,10 BITMAP oBmp FILE "\MARBA.BMP" ADJUST SIZE 140,65 NOBORDER

ACTIVATE MSDIALOG oDlg CENTERED

Return .T.


STATIC Function CarregaPeso(nPeso)
Local nRet
Local cPeso
Local nRet32 :=ExecInDLLOpen("TOLEDO.DLL")    
Local cBruto := '1'+spac(12)
Local cLiq   := '1'+spac(12)
Local cTara  := '1'+spac(12)


If nRet32 == -1
	Final("TOLEDO.DLL Nao Localizada. Ela deve estar no diretorio BIN.")
Else	                  
   nRet := ExeDLLRun2(nRet32, 0, @cBruto )
   nRet := ExeDLLRun2(nRet32, 1, @cLiq )   
   nRet := ExeDLLRun2(nRet32, 2, @cTara )   
   ExecInDLLClose(nRet32)   
   nPeso := Val(cLiq)
EndIf	
Return .t.