#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Remove-Group
{
    <#
    .SYNOPSIS
    Borrar grupos de usuario locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name", esta función verifica que el grupo exista para intentar borrarlo.
 
    .EXAMPLE
    Remove-Group -Name "P"
    Remove-Group "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del grupo a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		Try
		{
			$Groups = (Get-WmiObject -Class Win32_Group).Name
			If ($Groups.Contains($Name))
			{
				#Comprueba si el grupo local existe y lo elimina
				$Computer = [ADSI]"WinNT://$ENV:Computername"
				$Group = $Computer.Delete("Group", $Name)
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}