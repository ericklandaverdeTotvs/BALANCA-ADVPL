library Toledo6;

uses
  SysUtils,
  Classes,
  Dialogs,
  PcLink6 in 'PcLink6.pas';

function ExecInClientDLL( aFuncID : integer; aParams, aBuff : pChar; Buff_Size : integer ): Integer; stdcall;
var
  nRet, nI   : Integer;
  sParam : TStringList;
  sString,sSeparador : String;
  cTipoCON,cCom,cCanal:PChar;
  nCanalAt,nBalanca,nSMov,nAcao:Integer;
begin
  sParam        := TStringList.Create;
  sSeparador    := '|';
  sString       := copy(StrPas(aParams),1,Length(StrPas(aParams)) );
  nI := 0;
  While nI <= Length(sString) DO
   begin
     Inc(nI);
     If Copy(sString,nI,1)='|' Then
         begin
            sParam.Add(Copy(sString,1,nI -1));
            sString := Copy(sString,nI+1,Length(sString));
            nI := 1;
         end;
   end;
  sParam.Add(sString);
 {
  For nI := 0 TO sParam.Count -1 do
   begin
      ShowMessage(sParam[nI]);
   end;
  }
  nRet          := Inicializa(PChar(sParam[0]),PChar(sParam[1]),PChar(sParam[2]),
                              StrToInt(sParam[3]),StrToInt(sParam[4]),
                              StrToInt(sParam[5]),StrToInt(sParam[6]),aBuff);

  Result        := nRet;

  sParam.Free;

end;
Exports
  // Essa será a única função lida pelo client do Protheus
  ExecInClientDLL;


{$R *.RES}

begin
  DecimalSeparator := '.';
end.
