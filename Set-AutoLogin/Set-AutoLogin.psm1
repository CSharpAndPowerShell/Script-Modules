#requires -RunAsAdministrator
#requires -Version 4.0
Function Set-AutoLogin
{
    <#
    .SYNOPSIS
    Iniciar automáticamente la sesión de un usuario por tiempo indefinido.
    
    .DESCRIPTION
    Esta función necesita un parámetro para ser activada; "User"; y si el usuario con el que se quiere activar el autologin requiere contraseña, utilizar "Password". Para deshabilitar estar característica, utilice el parámetro "Disable".

    .EXAMPLE
    Set-AutoLogin -User "P" -Password "ContraseñaP"
    Set-AutoLogin -Disable
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Position = 0, HelpMessage = "Nombre del usuario que iniciará sesión automáticar.")]
		[ValidateNotNullOrEmpty()]
		[String]$User,
		[Parameter(Position = 0, HelpMessage = "Deshabilita el inicio de sesión automático.")]
		[Switch]$Disable = $false,
		[Parameter(Position = 1, HelpMessage = "Contraseña del usuario que iniciará sesión automática.")]
		[String]$Password
	)
	
	If ($Disable)
	{
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\"Windows NT"\CurrentVersion\Winlogon -Name AutoAdminLogon -Value 0 -Force | Out-Null
	}
	Else
	{
		If (($Password -eq $null) -or ($Password.Length -eq 0))
		{
			$Password = ""
		}
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\"Windows NT"\CurrentVersion\Winlogon -Name AutoAdminLogon -Value 1 -Force | Out-Null
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\"Windows NT"\CurrentVersion\Winlogon -Name DefaultUsername -Value $User -Force | Out-Null
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\"Windows NT"\CurrentVersion\Winlogon -Name DefaultPassword -Value $Password -Force | Out-Null
	}
}