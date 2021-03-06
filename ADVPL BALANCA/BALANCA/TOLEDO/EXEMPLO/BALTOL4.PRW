#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DEMOTOL4 � Autor �  ACD                  � Data � 30/07/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa para teste do uso de balanca usando dll PCLINCK 32���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o	  � CBBalToledo� Autor � Desenv.    ACD      � Data � 30/07/03 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o  � Seta as configuracoes para Balanca Toledo                  ���
��������������������������������������������������������������������������Ĵ��
���PARAMETROS � cCOM 		= Define a porta Serial                         ���
���           � cConector 	= Define o conector a sr utilizado              ���
���           � cCanal 		= Define qual canal do conector                 ���
���           � cBalanca 	= Define a balanca ligada no canal do coletor.  ���
��������������������������������������������������������������������������Ĵ��
��� Retorno	  � Array      = {nBruto,nLiquido,nTara}                       ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������

*/

USER FUNCTION DEMOTOL4
Local oDlg,oFont   
Private aPesos := {0,0,0}
Private oBruto,oLiq,oTara

DEFINE FONT oFont	NAME "Arial" Size 11,15 BOLD  	
DEFINE MSDIALOG oDlg FROM 5, 5 TO 15, 65 TITLE OemToAnsi("Teste DLL Toledo") FONT oFont
   @ 0.5,40 BUTTON "Carrega" SIZE 60,15  ACTION CarregaPeso() 
   @ 2.0,40 BUTTON "Fechar"  SIZE 60,15  ACTION oDlg:End()
   
   @ 0.7,01.3 SAY "Bruto        "  
   @ 2.2,01.3 SAY "Liquido      "
   @ 3.7,01.3 SAY "Tara         "

	@ 0.5,08.0 MSGET oBruto   VAR aPesos[1]     PICTURE "@E 9999.999"          SIZE 085,13 
	@ 2.0,08.0 MSGET oLiq     VAR aPesos[2]       PICTURE "@E 9999.999"          SIZE 085,13 
	@ 3.5,08.0 MSGET oTara    VAR aPesos[3]      PICTURE "@E 9999.999"          SIZE 085,13 


ACTIVATE MSDIALOG oDlg CENTERED

Return .T.

STATIC Function CarregaPeso()

aPesos	:= aClone(CBBalToledo('1','5',,'+9091')) //Esta funcao esta no ACDXFUN.PRW

oBruto:Refresh()
oLiq:Refresh()
oTara:Refresh() 

Return .t.