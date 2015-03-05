#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Remove-User
{
    <#
    .SYNOPSIS
    Eliminar usuarios locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name", esta función verifica que el usuario exista para intentar borrarlo.
 
    .EXAMPLE
    Remove-User -Name "P"
    Remove-User "P"
	"P" | Remove-User
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de usuario a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Begin { $Computer = [ADSI]"WinNT://$ENV:COMPUTERNAME" }
	
	Process
	{
		Try
		{
			if ((Get-WmiObject -Class Win32_UserAccount -Filter "Name='$Name'").Name -eq $Name)
			{
				#Se valida si el usuario existe para borrarlo
				$User = $Computer.Delete("user", $Name)
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}