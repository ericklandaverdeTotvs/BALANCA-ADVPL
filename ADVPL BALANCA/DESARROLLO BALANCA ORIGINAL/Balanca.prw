#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'   

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矪alanca   � Autor � LUIS LACOMBE       � Data �  01/07/2014 罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escri噭o 矲az a requisicao do peso pela porta serial.                 罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       �                                                            罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
 
User Function Balanca
SetPrvt("oFont1","oDlg1","oGet1")  
Private cCfg :="COM1:9600,n,8,1"   
Private cT := "", nH := 0
Private cTotPes := ""  
Private cPeso   := Space(10) 
Private lPara   := .F.  
Private lRet    := .F. 
Private oLBox1  
Private aDados  := {}  
Private cBuffer := Space(10)     


lRet       := msOpenPort(nH,cCfg)
oFont1     := TFont():New( "MS Sans Serif",0,-64,,.T.,0,,700,.F.,.F.,,,,,, )  
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg1      := MSDialog():New( 091,232,392,965,"Balan鏰",,,.F.,,,,,,.T.,,,.T. )
oGet1      :=  TGet():New( 036,044,{|u| If(PCount()>0,cPeso:=u,cPeso)},oDlg1,200,039,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPeso",,)   
oSBtn1     := SButton():New( 068,260,1,{|| LerPeso()},oDlg1,,"", )
oLBox1     := TListBox():New( 100,020,,aDados,164,048,,oDlg1,,CLR_BLACK,CLR_WHITE,.T.,,,oFont2,"",,,,,,, )
//oSBtn3     := SButton():New( 068,304,2,{||  msClosePort(nH) ,cPeso := "_,__",oGet1 :Refresh()  },oDlg1,,"", )   

cPeso := "_,__"
oGet1 :Refresh() 





oDlg1:Activate(,,,.T.)  


msClosePort(nH)  

Return 


Static Function LerPeso



if(!lRet)  
  Alert("Falha ao conectar com a porta serial")
  Return
EndIf      
msWrite(nH,Chr(5)) 
Sleep(300)  
For ncont := 1 To 20
	msRead(nH,@cBuffer)  
	if(!Empty(cBuffer)) 
	    //Alert(cBuffer)  
	    cPeso :=IsNumber(cBuffer)    
        cBuffer := ""
	    Exit
	EndIf  


Next

cNum    := cPeso    

if(Val(cNum) > 0)
    aaDD(aDados,cNum)
    oLBox1:SetArray(aDados)
Else
     cPeso := "0,00"          
EndIf

oGet1 :Refresh()  

//msClosePort(nH)  
                
Return 





 Static Function IsNumber(cNum) 
 
 Local cNumeros := "1234567890,"      
 Local cResult  := ""  

 
 for ncont := 1 To Len(cNum)
     if(SubStr(cNum,ncont,1)$cNumeros) 
        cResult += SubStr(cNum,ncont,1)
     EndIf
 Next 
 
 
 cResult := Replace(cResult,",",".")
 cNum := Transform(Val(cResult),"@e 999.99") 
 
 
 
 Return  cNum
 

      
 

Static Function LerPesoTXT
Local cNum := ""  
Local nTamFile, nTamLin, cBuffer, nBtLidos   
cBuffer := Space(10)

if(file(cArqTxt))
	FT_FUse(cArqTxt) 
	FT_FGOTOP()
	cBuffer  := FT_FReadln()    
	FT_FUse()
	fClose(nHdl)  
	IF FERASE(cArqTxt) == -1	 
   		MsgStop('Falha na dele玢o do Arquivo ( FError'+str(ferror(),4)+ ')')	 
    ENDIF 
EndIf


cPeso :=cBuffer

cNum    := Replace(cPeso,",",".")
if(Val(cNum) > 0)
    aaDD(aDados,cNum)
    oLBox1:SetArray(aDados)
Else
     cPeso := "0,00"          
EndIf

oGet1 :Refresh()  
                
Return 