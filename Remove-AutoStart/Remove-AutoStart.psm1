#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Remove-AutoStart
{
    <#
    .SYNOPSIS
    Registar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario por siempre, hasta que se elimine; usar "Remove-AutoStart".
    
    .DESCRIPTION
    Esta función necesita el parámetro "Name".
 
    .EXAMPLE
    Remove-AutoStart -Name "Script"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la entrada que identifica el AutoStart.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		Try
		{
			$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\"
			$Test = Get-ItemProperty $Key $Name -ErrorAction SilentlyContinue
			If ($Test -ne $null)
			{
				Remove-ItemProperty $Key -Name "$Name" -Force
			}
			Else
			{
				New-MsgBox -Message "La entrada no existe" -Title "Advertencia" | Out-Null
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}