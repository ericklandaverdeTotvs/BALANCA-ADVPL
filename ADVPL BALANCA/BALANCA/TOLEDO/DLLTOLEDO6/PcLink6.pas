unit PcLink6;

interface

uses SysUtils,Dialogs;

function Inicializa(cTipoCON,cCom,cCanal:PChar; nCanalAt,nBalanca,nSMov,nAcao:Integer;ARetorno: Pchar): integer;

implementation

//
// Declaração das rotinas da DLL do Pclink6
//
function Display_Erro(IP_SETADO : Integer) : PChar; stdcall; external 'PCLINK6.DLL';
function Seta_Ip(IPStr : PChar): Integer; stdcall;external 'PCLINK6.DLL';
function W9091(IP_SETADO : Integer; Canal : PChar): Integer; stdcall;external 'PCLINK6.DLL';
function W9091Serial(Canal : Integer): Integer; stdcall;external 'PCLINK6.DLL';
function WOhaus(IP_SETADO : Integer; Canal : PChar): Integer; stdcall; external 'PCLINK6.DLL';
function WOhausSerial(Canal : Integer): Integer; stdcall;external 'PCLINK6.DLL';
Function Select_Canal(CANAL_SETADO : Integer) : integer; stdcall;external 'PCLINK6.DLL';
function Update_Canal(Canal : integer) : Integer; stdcall;external 'PCLINK6.DLL';
function Update_NoMotion(Canal : integer;Tempo : integer) : Integer; stdcall; external 'PCLINK6.DLL';
function Gross_Canal(Canal : integer) : PChar; stdcall;external 'PCLINK6.DLL';
function Net_Canal(Canal : integer) : PChar; stdcall;external 'PCLINK6.DLL';
function Tare_Canal(Canal : integer) : PChar; stdcall;external 'PCLINK6.DLL';
function DIO_InPort(Nip : integer): Integer; stdcall;external 'PCLINK6.DLL';
function DIO_InPortStr(Nip : integer): PChar; stdcall;external 'PCLINK6.DLL';
function DIO_InBit(Nip : integer;Entrada : Integer): Integer; stdcall;external 'PCLINK6.DLL';
function DIO_InBitStr(Nip : integer;Entrada : Integer): PChar; stdcall;external 'PCLINK6.DLL';
function DIO_OutPort(Nip : integer;Palavra : Integer): Integer; stdcall;external 'PCLINK6.DLL';
function DIO_OutPortStr(Nip : integer;Palavra : PChar): integer; stdcall;external 'PCLINK6.DLL';
function DIO_OutBit(Nip : integer;Saida,Estado: Integer): Integer; stdcall;external 'PCLINK6.DLL';
function DIO_OutBitStr(Nip : integer;Saida : Integer; Estado : PChar): integer; stdcall;external 'PCLINK6.DLL';
function Estado_EmMovimento(Canal : integer) : PChar; stdcall;external 'PCLINK6.DLL';
function Estado_Canal(Canal : integer) : PChar; stdcall;external 'PCLINK6.DLL';
Procedure Close_Canal(Canal : integer); stdcall;external 'PCLINK6.DLL';
procedure Deleta_Canal(Canal : integer); stdcall;external 'PCLINK6.DLL';
procedure CloseLicense; stdcall;external 'PCLINK6.DLL';
procedure FirVer(var Nome,ver,serial,Conex,Programa : PChar); stdcall;external 'PCLINK6.DLL';

{
/////////////////////////////////////////////////////////////////////////////\
// cTIPOCON:   Informa o tipo de comunicacao
// cCom:       Porta/IP
// cCanal:     Canal de comunicacao da placa FIREX(A,B,C ou D).
// nCanalAt:   Numero do canal ativo
// nBlanca:    Tipo da balança:
//                1 - 9091
//                2 - Ohaus
// nSMov:      Indica será controlado movimento ou nao
// nAcao:      Acao a ser executada:
//                0 - Fecha licensa de uso em relacao ao hardkey server
//                1 - Encerra comunicao
//                2 - Inicializa comunicação
//                3 - Ler Balanca
/////////////////////////////////////////////////////////////////////////////\
}

function Inicializa(cTipoCON,cCom,cCanal:PChar; nCanalAt,nBalanca,nSMov,nAcao:Integer;ARetorno: Pchar): integer;export;
var NumPlacaFirex,nRet        : Integer;
    smov,sest,gross,tare,net: string;
begin

   If nAcao = 0 Then
      begin
         //Fecha Aplicativo
         CloseLicense;
      end
   Else If nAcao = 1 Then
      begin
         If nCanalAt >= 0 Then
            Close_Canal(nCanalAt);

         // Para desligar as saídas
         DIO_OutPort(NumPlacaFirex,0);
      end
   Else If nAcao = 2 Then
      begin
         // Setar Comunicacao
         If cTipoCON='IP' Then    // comunicação ethernet
            begin
               // Seta o Enderecamento IP
               NumPlacaFirex := Seta_Ip(cCom);
               SLEEP(100);
               //Setar Balanca
               If nBalanca = 1 Then       //Balanca 9091
                  begin
                      nCanalAt := W9091(NumPlacaFirex,cCanal);
                  end
               Else if nBalanca = 2 Then  //Balanca Ohaus
                  begin
                      nCanalAt := WOhaus(NumPlacaFirex,cCanal);
                  end;

               If nCanalAt < 0 then
                  begin
                     //Verificar se deverei colocar mensagem aqui ou não
							
                  end;

            end
         Else   //comunicação serial
            begin
               If nBalanca = 1 Then
                  begin
                     nCanalAt := W9091Serial(StrToInt(cCOM));
                  end
               Else If nBalanca = 2 Then
                  begin
                     nCanalAt := WOhausSerial(StrToInt(cCOM));
                  end;

               If nCanalAT < 0 Then
                  begin
                  //Verificar se deverei colocar mensagem aqui ou não

                  end;
            end;
      end
   Else If nAcao = 3 Then
      begin
      //-----------------------------------------------
         if nCanalAt >= 0 then
          begin
            if Select_Canal(nCanalAt) = 0 then
               begin
                 gross := 'Erro';
                 tare  := '';
                 net   := '';
                 smov  := '';
                 sest  := '';
               end
            else
               begin
                  // Execute do IP1
                  if nSMov = 1 then
                     begin
                        nRet := Update_NoMotion(nCanalAt,5000);
                     end
                  else
                     begin
                        nRet :=  Update_Canal(nCanalAt);
                     end;

                  if (nRet  = 0) or (nRet  = 3) then
                     begin
                        if nRet = 0 then
                           begin
                              gross := StrPas(Gross_canal(nCanalAt));
                              tare := StrPas(Tare_canal(nCanalAt));
                              net := StrPas(Net_canal(nCanalAt));
                              smov := StrPas(Estado_EmMovimento(nCanalAt));
                            end;
                        if nRet = 3 then
                            begin
                              gross := 'Sobrecarga';
                              tare := '';
                              net := '';
                              smov := '';
                            end;

                        sest := StrPas(Estado_Canal(nCanalAt));
                     end;
                  // Aqui deve ser analisado caso a caso...se timeout, se sobrecarga
                  if (nRet <> 0) and (nRet <> 3) then
                     begin
                        gross := 'Erro';
                        tare  := '';
                        net   := '';
                        smov  := '';
                     end;
               end;
            //ExibePeso;
            If assigned(ARetorno) then
               begin
                  StrCat(ARetorno, PChar(Trim(gross)+'|'+Trim(tare)+'|'+Trim(net)+'|'+Trim(smov)+'|'));
               end;
          end;


      //-----------------------------------------------
      end;
   Result := nCanalAt;
end;
End.






