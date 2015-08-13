<#
CSharpAndPowerShell Modules, tries to help Microsoft Windows admins to write automated scripts easier.
Copyright (C) 2015  Cristopher Robles Ríos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

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
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
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