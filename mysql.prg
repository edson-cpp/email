Lparameters _Server As String, _Database As String, _User As String, _Password As String, _Table As String
Local _Object
Local _MysqlConnect
Local _Return As Single
Use email Exclusive
Zap
Use In email
_Object = Newobject('MysqlAccess')
_MysqlConnect = _Object.MysqlConnect()
_Return = _Object.ExecutesCommand(_MysqlConnect, 'Select id, nomedest, email From ' + Alltrim(_Table) + ' Where nenviar = false', 'cEmail')
_Object.MysqlUnconnect(_MysqlConnect)
*!*
_Object = Null

If _Return = -1 Then
	MessageBox('N?o foi poss?vel conectar-se com o servidor.', 16, 'Erro conex?o!')
	Do Form login
Else
	Try
		Select cEmail
		Scan
			Insert Into email(id, nomedest, email) Values(cEmail.id, cEmail.nomedest, cEmail.email)
		EndScan
	Catch To oErr
		MessageBox('N?o foi poss?vel inserir a base de emails na tabela email,' + Chr(13) + 'por favor verifique poss?vel problema na tabela email.', 16, 'Erro tabela!')
	EndTry
	Do Form send
EndIf

Define Class MysqlAccess As Custom
	Hidden _Connection As adodb.Connection
	_MysqlConnect = 0
	StrConnection = ''
	_Srv = _Server
	_Data = _Database
	_Uid = _User
	_Pwd = _Password

	Function MysqlConnect As Boolean
		*!* Conecta-se ao banco de dados a partir da string de conex?o
		This.StrConnection = "DRIVER={MySQL ODBC 5.1 Driver};SERVER=" + Alltrim(This._Srv) + ";DATABASE=" + Alltrim(This._Data) + ";USER=" + Alltrim(This._Uid) + ";PASSWORD=" + Alltrim(This._Pwd) + ";OPTION=3;"
		This._MysqlConnect = Sqlstringconnect(This.StrConnection)
		If This._MysqlConnect = -1 Then
			This.StrConnection = "DRIVER={MySQL ODBC 3.51 Driver};SERVER=" + Alltrim(This._Srv) + ";DATABASE=" + Alltrim(This._Data) + ";USER=" + Alltrim(This._Uid) + ";PASSWORD=" + Alltrim(This._Pwd) + ";OPTION=3;"
			This._MysqlConnect = Sqlstringconnect(This.StrConnection)
		Endif
		Return This._MysqlConnect
	Endfunc

	Function MysqlUnconnect As Boolean
		Lparameters _MysqlConnect As Integer
		*!*
		If (Vartype(_MysqlConnect) != 'N') Then
			_MysqlConnect = This._MysqlConnect
		Endif
		*!*
		If (_MysqlConnect >= 0) Then
			Return SQLDisconnect(_MysqlConnect)
		Else
			Return -1
		Endif
	Endfunc

	Function ExecutesCommand
		Lparameters _MysqlConnect As Integer, SqlCommand As String, CursorName As String
		*!*
		If (This._MysqlConnect >= 0) Then
			If (Vartype(_MysqlConnect) != 'N') Then
				_MysqlConnect = This._MysqlConnect
			Endif
			*!*
			Return SQLExec(_MysqlConnect, SqlCommand, CursorName)
		Else
			Return -1
		Endif
	Endfunc

	Hidden Procedure Init As void
		This._Connection = Newobject("adodb.Connection")
	Endproc

	Hidden Procedure Destroy As void
		This._Connection = Null
	Endproc
Enddefine
