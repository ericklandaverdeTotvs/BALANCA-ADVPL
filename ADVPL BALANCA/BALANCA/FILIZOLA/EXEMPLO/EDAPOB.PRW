#Include "RWMAKE.ch"   


#DEFINE NoParity     '0'
#DEFINE OddParity    '1'
#DEFINE EvenParity   '2'
#DEFINE MarkParity   '3'
#DEFINE SpaceParity  '4'

User Function EDAPOB()          
Local aCores := {	{ "ZZ1->ZZ1_STATUS == '2'", "BR_AMARELO"    },;
				 	   { "ZZ1->ZZ1_STATUS == '1'", "DISABLE"  }   }

Private aRotina := { {"Pequisar"  	,"AxPesqui"	, 0 , 1},;  
                      {"Visualizar"	,"U_EDAPOBM"	, 0 , 2},; 
                      {"Apontar"	,"U_EDAPOBM"	, 0 , 3},; 
                      {"Excluir"	,"U_EDAPOBM"	, 0 , 5},;
                      {"Legenda"    ,"U_EDAPOBL" 	, 0, 3 } }       

Private cCadastro := "Apontamento de Producao com Balanca"
Private nUsado:=0,lTab := .F.

dbSelectArea("ZZ1")
dbSetOrder(1)                   
mBrowse( 6, 1,22,75,"ZZ1",,,,,, aCores)
Return
  
User Function EDAPOBM(cAlias1,nReg,nOpcx)
Local aArea:=GetArea('ZZ1')
Local aFields :=If(nOpcx==3,{"ZZ1_OP"},{})
Local aButtons:=If(nOpcx==3, {{"PMSTASK2"		,{|| Grava(2,3) },"Pausa"}},{})
Private oDlg
Private nOpcao := nOpcx
Private oT
Private lSai := .f.
Private laTivo:= .f.

//enchoice
Private aTela :={}  
Private aGets :={}  
Private oEnc01
//getdados    
Private n	:= 1
Private aHeader		:= {}
Private aCols		:= {}
Private oGet01

	SETAPILHA()
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM  6.5,0 To 26.5,80 OF oMainWnd STYLE 128
	oMainWnd:oFont := AdvFont
	
	If nOpcao == 3 .and. ZZ1->ZZ1_STATUS =="2" 
      nOpcao := 4
	EndIf   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enchoice 01							                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	aTela := {}
	aGets := {}
	dbSelectArea("ZZ1")                 
	RegToMemory('ZZ1',nopcao==3)
	Zero()
	oEnc01:= MsMGet():New("ZZ1" ,nReg ,nOpcao,,,,aFields,{11,0,80,(oDlg:nWidth/2)-2},aFields,,nopcao,,,oDlg,,,.f.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ getDados 01								       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader 	:= aClone(Al_CriaHeader('ZZ2','ZZ2_OP|ZZ2_LOTE'))       
	aCols		:= aClone(Al_CriaCols('ZZ2',nopcao,1,'ZZ2_FILIAL+ZZ2_OP+ZZ2_LOTE',ZZ2->(xFilial('ZZ2'))+M->ZZ1_OP+M->ZZ1_LOTE,'ZZ2_OP|ZZ2_LOTE'))            
	n        := 1

	dbselectarea('ZZ2')
	RegToMemory('ZZ2')
	oGet01 	:= MSGetDados():New(81,0,(oDlg:nBottom/2)-62,(oDlg:nWidth/2)-2,2,,,,.F.,,1,,,,,,,oDlg)		
	oGet01:oBrowse:Default() 
	oGet01:oBrowse:nAt:= 1
	If nOpcx ==3	                                        
   	oDlg:cCaption:= cCadastro  +' [Aguarde... Ativando leitura da balanca]'
		oT := TTimer():New(3000,{|| balanca()}, oDlg )
		oT:Activate()
	EndIf	
	oDlg:lEscClose := .F.
	ACTIVATE DIALOG oDlg ON INIT  EnchoiceBar(oDlg, {|| Grava(1,nOpcx),.F. },{|| Grava(3,nOpcx) },,aButtons) 
	                                  
	SETAPILHA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Arquivos								            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return


Static Function BALANCA()   
Local cPorta   := "COM1"
Local cBaudRate:= "9600"
Local cParity  :='0' //  0=NoParity,1=OddParity,2=EvenParity,3=MarkParity,4=SpaceParity
Local cData    := "8"
Local cStop    :='0' //0=OneStopBit,1=One5StopBits,2=TwoStopBits
Local cTimeOut := "00500"
Local cSettings:= cBaudRate+','+cParity+','+cData+','+cStop+','+cTimeOut
Local nH       := FOpenPort(cPorta,cSettings,2)
                                               
If nH < 0
   oDlg:cCaption:= cCadastro +' [Erro de Leitura!!!] '
   return 
EndIf   
      
laTivo := .t.
oDlg:cCaption:= cCadastro +' [Leitura Ativada] '
oT:Deactivate()
While ! lSai   
   LePorta(nH)
   ProcessMessage() 
   Sleep(50)
End        
fclose(nH)                                      
oDlg:cCaption:= cCadastro +' [Leitura Desativada] '
oDlg:End()
Return .t.

Static Function LePorta(nH)
Local cByteLido    
Local nBytes:=0
Local nItem :=0
Local nPesoB := 0
Local nPesoL := 0
Local nTara  := 0

Static cTexto:=''


while nBytes==0
   If lSai
      exit
	EndIf   
	cBytelido:=Space(40)
	nbytes:=fread(nH,@cBytelido,len(cBytelido))
	If nbytes ==0
		Sleep(50)
	EndIf
	ProcessMessage()
end	       
If lSai
   Return
EndIf   

cTexto+=cByteLido
If Right(Alltrim(cByteLido),1) == chr(3)
   //conout(cTexto) 
   //memowrite('asv',ctexto)     
   If Empty(aCols[1,1])
   	nItem := 1
   Else 
      nItem := len(aCols)+1
      aadd(aCols,{" ",0,0,0,'',.f.})
   EndIf	
	nPesoB  := Val(StrTran(Subs(cTexto,40,7),",","."))
	nTara   := Val(StrTran(Subs(cTexto,51,7),",","."))
	nPesoL  := Val(StrTran(Subs(cTexto,65,7),",","."))
	aCols[len(aCols)]:=aClone({Strzero(nItem,3),nPesoB,nTara,nPesoL,'',.f.})
	
	n:= oGet01:oBrowse:nAt
	oGet01:oBrowse:Refresh()
	M->ZZ1_QTDITE  := Len(aCols)
	M->ZZ1_PB      += nPesoB
	M->ZZ1_PL      += nPesoL
	M->ZZ1_Tara    += nTara
	oEnc01:Refresh()	
   cTexto:=''
EndIf   

Return 


User Function EDAPOBL()
Local aCorDesc 
			 	
aCorDesc := {{ "DISABLE",		"1-Apontado" },;
             { "BR_AMARELO", "2-Pausa" 	}	 }

BrwLegenda( "Legenda - Apontamento com balanca","Status", aCorDesc ) 	    
  
Return( .T. )


Static Function Al_CriaHeader(cAlias,cNaoCampos)
Local aTmpheader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
nUsado := 0
While !EOF() .And. (x3_arquivo == cAlias)
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.( ! Trim(SX3->X3_CAMPO) $ cNaoCampos )
		nUsado++
		AADD(aTmpHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal, x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context } )
	EndIf
	dbSkip()
End    
Return aTmpheader

Static Function Al_CriaCols(cAlias,nOpcao,nOrdem,cKey,cConteudo,cNaoCampos)
Local nUsado:= 0
Local aTmpCols:= {}
Local nCnt:=0, cFiltra:=""
Local cVar,i      
nOrdem 		:= if(nOrdem==NIL,1,nOrdem)         
cKey   		:= if(cKey==NIL,'',cKey) 
cConteudo	:= if(cConteudo=NIL,'',cConteudo)
cNaoCampos  := if(cNaoCampos=NIL,'',cNaoCampos)

If nOpcao # 3	//# inclusao
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	dbSeek(cConteudo)
	While !EOF() .and. if(cKey=='',.t.,(&cKey == cConteudo))
		nCnt++
		dbSkip()
	End	
	nCnt := IIF(nCnt=0,nCnt:=1,nCnt)
	If nOpcao == 2		//visual		
		aTmpCols := Array(nCnt, Len(aHeader))
	Else
		aTmpCols := Array(nCnt, Len(aHeader) + 1)
	EndIf	
	nCnt := 0
	dbSelectArea(cAlias)
	dbSetOrder(nOrdem)
	dbSeek(cConteudo)
	While !EOF() .and. if(cKey=='',.t.,(&cKey == cConteudo))
		nCnt++
		nUsado:=0
		dbSelectArea("SX3")
		dbSeek( cAlias )
		While !EOF() .And. x3_arquivo == cAlias
			If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.( ! Trim(SX3->X3_CAMPO) $ cNaoCampos )
				nUsado++
				If x3_context # "V"
					aTmpCols[nCnt][nUsado] := &(cAlias+"->"+x3_campo)
				ElseIf x3_context == "V"
					aTmpCols[nCnt][nUsado] := CriaVar(AllTrim(x3_campo))
				EndIf
			EndIf
			dbSkip()
		End
		dbSelectArea(cAlias)
		dbSkip()
	End
Else	
	aTmpCols := Array(1, Len(aHeader) + 1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Array de 1 elemento ³
//³ vazio. Se inclus†o.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpcao==3) .Or. Empty(aTmpCols[1][1])		//Inclusao ou arquivo vazio
	dbSelectArea("SX3")
	dbSeek(cAlias)
	nUsado:=0
	While !EOF() .And. (x3_arquivo == cAlias)
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And.	( ! Trim(SX3->X3_CAMPO) $ cNaoCampos )
			nUsado++
			If x3_tipo == "C" 			
			   	aTmpCols[1][nUsado] := SPACE(x3_tamanho)
			ElseIf x3_tipo == "N"		
			   	aTmpCols[1][nUsado] := 0
			ElseIf x3_tipo == "D"		
				aTmpCols[1][nUsado] := CTOD("  /  /  ")
			ElseIf x3_tipo == "M"		
				aTmpCols[1][nUsado] := ""
			Else						
				aTmpCols[1][nUsado] := .F.
			EndIf
			If x3_context == "V"		
				aTmpCols[1][nUsado] := CriaVar(allTrim(x3_campo))
			EndIf
		EndIf
		dbSkip()
	EndDo		
EndIf
If nOpcao # 2	//# visual
	For nI:=1 To Len(aTmpCols)
		aTmpCols[nI][Len(aHeader)+1] := .F.
	Next nI	
EndIf	
Return aTmpCols

User Function EDAPOBV()
Local chora := Left(time(),5)
Local cTurno:=""
Local cLote:=""
If ! lAtivo
   Return .f.
EndIf   
ZZ1->(DbSetOrder(1))
If ! ZZ1->(DbSeek(xFilial()+"2"+M->ZZ1_OP))
   Alert("Nao existe esta OP")
   M->ZZ1_OP:=Space(15)
   Return .t.
EndIf                    


ZZ1->(DbSetOrder(1))
If ZZ1->(DbSeek(xFilial()+"2"+M->ZZ1_OP))
   Alert("Existe Lote em aberto para esta OP")
   M->ZZ1_OP:=Space(15)
   Return .t.
EndIf                    
SC2->(DbSetOrder(1))
SC2->(DbSeek(xFilial()+M->ZZ1_OP))
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial()+SC2->C2_PRODUTO))

If cHora >= "06:00" .and. cHora < "14:00"
   cTurno := '1'
ElseIf cHora >="14:00" .and. cHora < "22:00"
   cTurno := '2'
ElseIf chora >= "22:00" .and. cHora <"06:00"
   cTurno := '3'
EndIf        
cLote := GETMV('MV_EDLOTE') 
cLote := Soma1(cLote,Len(cLote)) 
PutMv('MV_EDLOTE',cLote)               

M->ZZ1_LOTE  := cLote
M->ZZ1_OP    := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+'  ')
M->ZZ1_TURNO := cTurno
M->ZZ1_CODPRO:= SB1->B1_COD
M->ZZ1_DESPRO:= SB1->B1_DESC
SysRefresh()
Return .t.

Static Function Grava(nGrava,nOpcx) 
Local nX     
Local aRot
Private	lMsHelpAuto := .T.
Private	lMSErroAuto := .F.

If nopcx == 3
   If ! lAtivo
      Return 
   EndIf   
   If nGrava < 3
      If Empty(M->ZZ1_PB)
         MSGStop("Nao existem itens lidos")
         Return
      EndIf
	   If !  MSGYesNo("Confirma "+if(nGrava==1," o Apontamento?","a Pausa"),"Atencao")
   	   Return 
	   EndIf    
	   Begin Transaction
		   RecLock('ZZ1',nOpcao == 3)
		   If nOpcao == 3
			   ZZ1->ZZ1_FILIAL:= xFilial('ZZ1')
			   ZZ1->ZZ1_OP    := M->ZZ1_OP
			   ZZ1->ZZ1_LOTE  := M->ZZ1_LOTE
			   ZZ1->ZZ1_TURNO := M->ZZ1_TURNO
			   ZZ1->ZZ1_DATA  := M->ZZ1_DATA		   
			   ZZ1->ZZ1_LOTE  := M->ZZ1_LOTE
			   ZZ1->ZZ1_NOMUSR:= M->ZZ1_NOMUSR
			ENDIF   
	      ZZ1->ZZ1_QTDITE  := M->ZZ1_QTDITE
	      ZZ1->ZZ1_PB      := M->ZZ1_PB
	      ZZ1->ZZ1_PL      := M->ZZ1_PL      
	      ZZ1->ZZ1_TARA      := M->ZZ1_TARA      
			If nGrava == 1   		   
		  	   ZZ1->ZZ1_STATUS:= "1"
		  	Else 
		  	   ZZ1->ZZ1_STATUS:= "2"
		  	EndIf               
		  	ZZ1->(MsUnLock())
		  	While ZZ2->(DbSeek(xFilial('ZZ2')+M->ZZ1_OP+M->ZZ1_LOTE))
		  	   ZZ2->(RecLock('ZZ2',.F.))	  	
		  	   ZZ2->(DbDelete())
			  	ZZ2->(MsUnLock())	  	   
		  	End                 
		  	For nX:= 1 to len(aCols)
		  	   ZZ2->(RecLock('ZZ2',.T.))
		  	   ZZ2->ZZ2_FILIAL:= xFilial('ZZ2')
			   ZZ2->ZZ2_OP    := M->ZZ1_OP
			   ZZ2->ZZ2_LOTE  := M->ZZ1_LOTE
			   ZZ2->ZZ2_ITEM  := aCols[nX,1]
			   ZZ2->ZZ2_PB    := aCols[nX,2]
			   ZZ2->ZZ2_TARA  := aCols[nX,3]
			   ZZ2->ZZ2_PL    := aCols[nX,4]		   		   
			  	ZZ2->(MsUnLock())		   
		  	Next
			If nGrava == 1                       
			   conout('Executa rotina automatica')
			   /*
			   nPesoPallet:= 0
	         aRot:= {	{"H6_OP"		 , M->ZZ1_OP		, NIL},;
				 			{"H6_PRODUTO", M->ZZ1_CODPRO	, NIL},;
							{"H6_OPERAC" , "37"				, NIL},;
							{"H6_RECURSO", "071" 			, NIL},;
							{"H6_DATAINI", dDataBase 		, NIL},; // ?
							{"H6_HORAINI", cHrIni   		, NIL},; // ?
							{"H6_DATAFIN", dDataBase		, NIL},; // ?
							{"H6_HORAFIN", cHrFim   		, NIL},; // ?
							{"H6_OPERADO", ZZ1->ZZ1_NOMUSR, NIL},;
							{"H6_DTAPONT", dDataBase		, NIL},;
							{"H6_QTDPROD", M->ZZ1_PL+nPesoPallet, NIL}}
	
				lMsHelpAuto := .T.
				lMSErroAuto := .F.
				MsExecAuto({|x|MATA681(x)},aRot)
				If lMSErroAuto
					DisarmTransaction()
					Break
				EndIf
				*/
			EndIf	
   	End Transaction	
		If lMSErroAuto
		   MostraErro()
		   Return
		EndIf
	Else
      If ! Empty(M->ZZ1_PB) .and. ! MSGYesNo("Deseja cancelar os itens lidos?","Atencao")
         Return 
      EndIf
	EndIf	
	lSai:= .t.
ElseIf 	nopcx == 4
   If nGrava == 1
      If ZZ1->ZZ1_STATUS == '1'
         MSGStop("Exclusao somente com status de pausa!!!")
      Else
         If MSGYesNo("Confirma a exclusao?","Atencao")
			  	While ZZ2->(DbSeek(xFilial('ZZ2')+ZZ1->ZZ1_OP+ZZ1->ZZ1_LOTE))
			  	   ZZ2->(RecLock('ZZ2',.F.))	  	
		  		   ZZ2->(DbDelete())
			  		ZZ2->(MsUnLock())	  	   
			  	End                 	
		  	   ZZ1->(RecLock('ZZ1',.F.))	  	
	  		   ZZ1->(DbDelete())
		  		ZZ1->(MsUnLock())	  	   
	      EndIf
      EndIf
	EndIf	
	oDlg:End()
Else
	oDlg:End()
EndIf	

Return