library Toledo;

uses
  SysUtils,
  Classes,
  Dialogs,
  PcLink32 in 'PcLink32.pas';


function ExecInClientDLL( aFuncID : integer; aParams, aBuff : pChar; Buff_Size : integer ): Integer; stdcall;
var
  nRet   : Integer;
  sParam : TStringList;
  pPar1,pPar2,pPar3,pPar4 : pChar;
  nPos : Integer;
  sString,sSeparador : String;
  nCom,nConector,nCanal,nBalanca : Integer;
begin
  sParam        := TStringList.Create;
  sSeparador    := ',';
  sString       := copy(StrPas(aParams),1,Length(StrPas(aParams)) );
  sParam.Add(sString);
  If Length(sString)<= 13 Then
      begin
         nCom        := StrToInt(Copy(sParam[0],1,1));
         nConector   := 5;
         nCanal      := 1;
         nBalanca    := -8132;
      end
  Else
      begin
         nCom        := StrToInt(Copy(sParam[0],1,1));
         nConector   := StrToInt(Copy(sParam[0],14,1));
         nCanal      := StrToInt(Copy(sParam[0],15,1));
         nBalanca    := StrToInt(Copy(sParam[0],16,5));
      end;

  nRet          := Inicializa(nCom,nConector, nCanal,nBalanca,aFuncID,aBuff);
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
