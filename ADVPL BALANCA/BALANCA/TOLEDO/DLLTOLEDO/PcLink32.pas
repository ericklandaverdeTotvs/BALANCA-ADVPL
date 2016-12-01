unit PcLink32;

interface

uses SysUtils,Dialogs,IniFiles;

function Inicializa(nCom,nConector,nCanal,nBalanca,nTipo:Integer;ARetorno: pchar): integer; export;

implementation

//
// Declaração das rotinas da DLL do Pclink - 32 bits
//
function SetLink(PortaSerial,PlacaPclock: Integer): Integer; stdcall; external 'PCLINK32.DLL';
function AttachModulo(Iden,Modu: Integer): Integer; stdcall; external 'PCLINK32.DLL';
function ReadModulo(Iden: Integer;Bru,Liq,Tar: PChar): LongInt; stdcall; external 'PCLINK32.DLL';
function AttachChannel(Iden,Cana,Modu: Integer): Integer; stdcall ;external 'PCLINK32.dll';
procedure KillLink(Iden: Integer); stdcall; external 'PCLINK32.DLL';


function Inicializa(nCom,nConector,nCanal,nBalanca,nTipo:Integer;ARetorno: pchar): integer; export;
var Id          :integer;
    status      :Integer;
    sResult     :string;
    conseq      :integer;
    grosBuf  : array [0..12] of char ;
    netBuf   : array [0..12] of char ;
    tareBuf  : array [0..12] of char ;
begin

  Result := 0;
  Id:=SetLink(nCom,nConector);
  if id <> -1 then
  begin

     // A conexão foi feita.
     // Associo a balança ao conector...
     if nCONECTOR <= 4 then
        // O conector é uma PCLOCK
        status := AttachChannel(id,nCanal,nBalanca)
     else
        // O conector é uma HARDKEY
        status := AttachModulo(id,nBalanca);

     FillChar(grosBuf, sizeOf(grosBuf), 32);
     FillChar(netBuf, sizeOf(netBuf), 32);
     FillChar(tareBuf, sizeOf(tareBuf), 32);
     conseq := ReadModulo(id,grosBuf,netBuf,tareBuf);
     if conseq <> 0 then
     begin
        if assigned(ARetorno) then
        begin
           If nTipo = 0 then
              strCat(ARetorno, grosBuf)
           Else if nTipo = 1 then
              strCat(ARetorno, netBuf)
           Else if nTipo = 2 then
              strCat(ARetorno, tareBuf);
        end;
        Result := 13
     end else
        Result := -conseq;
     KillLink(id);
  end;
end;

End.






