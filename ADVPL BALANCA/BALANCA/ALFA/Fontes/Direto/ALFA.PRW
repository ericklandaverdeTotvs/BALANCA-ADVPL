#INCLUDE "PROTHEUS.CH"

#DEFINE STX				2
#DEFINE ETX				3

#DEFINE OneStopBit   '0'
#DEFINE One5StopBits '1'
#DEFINE TwoStopBits  '2'

#DEFINE NoParity 		'0'
#DEFINE OddParity    '1'
#DEFINE EvenParity   '2'
#DEFINE MarkParity   '3'
#DEFINE SpaceParity  '4'

USER FUNCTION BALTeste()  
Local oDlg,oFont   

Private oBruto,oLiq,oTara, oStr, oTimer
Private nBruto
Private nTara 
Private nLiq
Private cSTR	:= Space(85)  
Private lContinua := .t.

DEFINE FONT oFont	NAME "Terminal" Size 8,10
DEFINE MSDIALOG oDlg FROM 5, 5 TO 17, 65 TITLE OemToAnsi("Teste Balanca") 
   @ 0.5,40 BUTTON "Carrega" SIZE 60,15  ACTION Leitura()//CarregaPeso() 
   @ 2.0,40 BUTTON "Fechar"  SIZE 60,15  ACTION (lContinua:= .f.,oDlg:End())
   
   @ 0.7,01.3 SAY "Bruto        "  
   @ 2.2,01.3 SAY "Liquido      "
   @ 3.7,01.3 SAY "Tara         "
   @ 5.2,01.3 SAY "Resultado	   "

	@ 0.5,08.0 MSGET oBruto   VAR nBruto     PICTURE "@E 99999999.999"          SIZE 085,13 
	@ 2.0,08.0 MSGET oLiq     VAR nLiq       PICTURE "@E 99999999.999"          SIZE 085,13 
	@ 3.5,08.0 MSGET oTara    VAR nTara      PICTURE "@E 99999999.999"          SIZE 085,13 
	@ 5.0,08.0 MSGET oStr     VAR cSTR       SIZE 160,13 
//	oTimer := TTimer():New(3000,{||CarregaPeso()},oDlg)
//	oTimer:lActive := .T.
ACTIVATE MSDIALOG oDlg CENTERED

Return .T.


Static Function CarregaPeso()
Local cPorta   := "COM1"
Local cBaudRate:= "19200"
Local cParity  := NoParity
Local cData    := "8"
Local cStop    := TwoStopBits
Local cTimeOut := "00500"
Local cSettings:= cBaudRate+','+cParity+','+cData+','+cStop+','+cTimeOut
Local nH       := CBOpenPort('COM1:19200,N,8,2')//fopenPort(cPorta,cSettings,2)
Local cTexto	:=""
Local cBytelido:=' '         
Local cComando1 := '1002011000081003A6'//"<DLE><STX>010008<DLE><ETX>A6"//"10H02H01H00H08H10H03HA6H"   // '1002011000081003A6'
Local cComando2 := "100501"
lContinua:= .T.
//19200 bps, 8 data bits, SEM Paridade, 2 stop bits
If nH == -1      
	return "ERRO- NAO ABRIU A PORTA"
EndIf	
cTexto:=Time()+" " 
//oTimer:lActive := .F.
FWrite(nH,cComando1)
While .t.       
   ProcessMessage()
	cBytelido:=Space(2)
	while Empty(cBytelido) 
	   If ! lContinua
	      exit
	   EndIf   
		nbytes:=fread(nH,@cBytelido,2)	// Neste caso estou fazendo leitura byte a byte, mas nada impede que eu lei com mais bytes
		If nBytes==0 
			//FWrite(nH,cComando1)
		   sleep(50)
		EndIf              
      ProcessMessage()
	end	       
   If ! lContinua
      exit
   EndIf   
	
	cTexto+=cByteLido
	If cByteLido == "06"
		cSTR := cTexto
		oStr:Refresh()
		oBruto:Refresh()
		oTara:Refresh() 
		oLiq:Refresh()
  		cTexto:=Time()+" " 
	EndIf   
	Conout("Conteudo: "+ cTexto)	
End         
fclose(nH)
Return





Function Leitura()
Local nH 	:= CBOpenPort('COM1:19200,N,8,2')
Local nByte := 0
Local cByteLido := Space(2)
Local cconteudo:= chr(16)+chr(2)+chr(1)+chr(0)+chr(8)+chr(16)+chr(3)+chr(166)

FWrite(nH,cconteudo)
Sleep(20)          
n:=0
cRetorno:=''
while .t.
	nbyte:=fread(nH,@cBytelido,2)	
	If cByteLido == chr(6)
	   FWrite(nH,chr(16)+chr(5)+chr(1))
	   while .t.
			nbyte:=fread(nH,@cBytelido,2)	
	      cRetorno+=cBytelido
	      conout(cRetorno)
      	If len(cRetorno) == 20
            return
         EndIf         	
	   end
	EndIF
	Conout(cByteLido)
End	
Return