#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ibascula � Autor � Afonso Brito       � Fecha �  30/10/14   ���
�������������������������������������������������������������������������͹��
���Descripcion � Integracion con WIN4600 � BASCULA                        ���
��          �                                                             ���
�������������������������������������������������������������������������͹��
��  �Uso       � Especifico FaOP ya enviada para bascula.                 ���
��  Desea enviar nuevamentereva                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IBASCULA


//���������������������������������������������������������������������Ŀ
//� Declaracion de Variables                                             �
//�����������������������������������������������������������������������

Local cPathBC		:= ""
Local cEnter    	:= Chr(13)
Private cString     := ""

If SC2->C2_TPOP<>"F"   //NO FIRME
   MSGBOX("OP no esta Firme","Atencion","ALERT")
   Return
Endif

If SC2->C2_BASCULA=="S"   //YA ENVIADO PARA BASCULA
   if !MSGBOX("OP ya enviada para bascula. Desea enviar nuevamente?","Atencion","YESNO")  
     Return   
   endif  
Endif

_NUMOP := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN   

_FECHA := SUBSTR(DTOS(DATE()),3,2)+SUBSTR(DTOS(DATE()),5,2)+SUBSTR(DTOS(DATE()),7,2)

cQuery := "SELECT D4_COD, D4_OP, D4_QUANT, D4_DATA, D4_LOTECTL, D4_LOCAL FROM "+RetSQLName("SD4")+" SD4 " +cEnter
cQuery += "WHERE D4_OP = "+_NUMOP+" " +cEnter 
cQuery += "AND D4_COD <> '' " +cEnter
cQuery += "AND SD4.D_E_L_E_T_ = ' ' "+cEnter
cQuery += "ORDER BY  D4_OP "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)  

cPathBC:= SuperGetMV("MV_PATHBAS",.F.,"\WIN4600\") 
_ARQUIVO := cPathBC+"ORDENES.TXT"

If  !File(_ARQUIVO)
   handle := FCREATE(_ARQUIVO)
Else
   handle := FCREATE(_ARQUIVO)
Endif   
            
TRB->(DBGOTOP())
//Crea cabec     
cDEscPrd:= Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
cValPrd:= Transform(((SC2->C2_QUANT)),"@E 999999999.99")  //strTRan(cValTochar(SC2->C2_QUANT),".",",")
_ContCabec:="CA"+;			//Identificaci�n
";"+SC2->C2_NUM+;			//Orden de fabricaci�n
";"+SC2->C2_PRODUTO+;		//C�digo producto a fabricar
";"+SUBSTR(cDescPrd,1,50)+;	//Descripci�n del producto
";"+Alltrim(cValPrd)+;		//Cantidad a fabricar
";"+SB1->B1_UM+;			//Unidad de medida
";"+;						//Lote del producto a fabricar
";"							//N�mero de ciclos o cargas	

FWRITE(M->handle,_ContCabec+CHR(13)+CHR(10)) 

DO WHILE TRB->(! EOF()) 

	cDescComp:= Posicione("SB1",1,xFilial("SB1")+TRB->D4_COD,"B1_DESC")	
	cQuant := Transform(((TRB->D4_QUANT)),"@E 999999999.99")  

	_Conteudo := 	"LI"+;          //Identificaci�n
	";"+SC2->C2_NUM+;               //Orden de fabricaci�n
	";"+TRB->D4_COD+;               //C�digo de componente
	";"+SUBSTR(cDescComp,1,50)+;    //Descripci�n componente
	";"+Alltrim(cQuant)+;           //Cantidad a pesar
	";"+SB1->B1_UM+;                ///Unidad de medida
	";"+;                           //Fase de Fabricaci�n
	";"+;							//N� de l�nea.
	";"+Alltrim(TRB->D4_LOTECTL)+;  //Lote de Componente a utilizar
	";"+;							//Ubicaci�n
	";"+;							//B�scula
	";"+"2.0"+;						//Tolerancia en exceso
	";"+"1.0"						//Tolerancia en defecto

	
	FWRITE(M->handle,_Conteudo+CHR(13)+CHR(10)) 
	
	TRB->(DBSKIP())   
	
ENDDO

DBSELECTAREA("SC2")
RECLOCK("SC2",.F.)    
SC2->C2_BASCULA := "S"
SC2->(MSUNLOCK())

FCLOSE(M->handle)  

TRB->(DBCLOSEAREA())  

MSGBOX(_ARQUIVO + " Generado","Atencion","ALERT")  

Return