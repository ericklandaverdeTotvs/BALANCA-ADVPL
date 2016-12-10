#Include "TOTVS.CH"
User Function TstSenhaP()

  cUser := 'ADMIN'
  cPsw := ''
  cServiceName := 'MSG005'

  // Chamada da tela do SenhaP
  cSenhaP := GetSenhAp( cUser, cPsw, cServiceName ) 

  MsgStop( "O ID gerado foi: " + cSenhaP )

Return