#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �          � Autor � LUIS LACOMBE          � Data �          ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �83 8819-6539                    ���
���   �                         �        �gustavo.lacombe@gmail.com       ���
�������������������������������������������������������������������������Ĵ��
���Descricao �  Le peso da balanca rodoviaria Lider modelo LD 1001        ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function BalRodov

Private cPesoAt      := Space(30)
Private cPesStr    := Space(30)     
Private cCfg     :="COM1:4800,n,8,1"
Private nH       := 0


SetPrvt("oDlg1","oSay1","oSay2","oPesStr","oPeso","oSBtn1")

oDlg1      := MSDialog():New( 091,232,304,578,"Balan�a rodovi�ria",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 028,016,{||"STRING DA COM1"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay2      := TSay():New( 045,017,{||"PESO TRATADO"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,059,008)
oPesStr    := TGet():New( 028,088,{|u| If(PCount()>0,cPesStr:=u,cPesStr)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesStr",,)
oPeso      := TGet():New( 048,088,{|u| If(PCount()>0,cPesoAt:=u,cPesoAt)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesoAt",,)
oSBtn1     := SButton():New( 072,120,1,{|| LerPeso()},oDlg1,,"", )

oDlg1:Activate(,,,.T.)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Programa � LerPeso  � Autor � LUIS LACOMBE          � Data � 18/04/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Faz a requisicao de peso para a balanca e le o retorno.     ���
���          �Para funcionar, eh importante verificar o protocolo de      ���
���          �comunicacao da balanca. No caso da TOLEDO,ela tem que estar ���
���          �usando o protocolo que responda ao sinal ENQ, por exemplo   ���
���          �o protocolo P05 ou P05A. Importante lembrar que a funcao    ���
���          �nao trata a estabilizacao de peso. Se quiser receber o peso ���
���          �somente quando ele estabilizar,use o protocolo adequado como���
���          �P05 da TOLEDO.                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function LerPeso()

Local cPeso := 0
Local cBuffer

cCfg      :="COM1:4800,n,8,1"

lRet       := msOpenPort(nH,cCfg)
if(!lRet)
 Alert("Falha ao conectar com a porta serial")
 Return
EndIf

//msWrite(nH,Chr(5))
//Sleep(200)
For ncont := 1 To 50
 msRead(nH,@cBuffer)
 if(!Empty(cBuffer))
 		ALERT(cBuffer)
     cPesStr := cBuffer
  cPeso := IsNumber(cBuffer)
  Exit
 EndIf
Next
msClosePort(nH) 

cPesoAt  := cPeso

// PRA TESTAR O PROGRAMA SEM BALANCA
//nPeso := Val(cSimPes)

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Programa � IsNumber � Autor � LUIS LACOMBE          � Data � 18/04/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Separa os caracteres numericos da string recebida da balanca���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IsNumber(cNum)

Local nPosPar  
Local cPesB     := ""
Local cNumeros  := "0123456789." 
Local cNewNum   := ""
Local nPes      := 0


//bloco que separa o numero da string enviada pela balanca
For nCont := 1 To Len(cNum)
    if(SubStr(cNum,nCont,1)=="E")
        Exit
    EndIf 
   
    if(SubStr(cNum,nCont,1)=="I") // peso instavel 
        Return "-1"       
    EndIf
   
    if(SubStr(cNum,nCont,1)$cNumeros)
       cNewNum += SubStr(cNum,nCont,1)
    EndIf
Next nCont

cPesB  :=  cNewNum

Return cPesB
