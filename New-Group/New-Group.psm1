#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function New-Group
{
    <#
    .SYNOPSIS
    Crear grupos de usuario locales.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Description", aunque solo el primero es obligatorio. Esta función verifica si el grupo a crear existe, si no existe lo crea.
 
    .EXAMPLE
    New-Group -Name "Pali" -Description "Usuarios Palidejos"
    New-Group "Pali"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del nuevo grupo.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Descripción del contenido o función del grupo.")]
		[String]$Description
	)
	
	Begin
	{
		$Computer = [ADSI]"WinNT://$ENV:Computername"
	}
	
	Process
	{
		If (($Name -ne "Administradores") -and ($Name -ne "Usuarios"))
		{
			#Comprueba si el grupo local existe, si no existe se crea
			If (!((Get-WmiObject -Class Win32_Account -Filter "Name='$Name'").Name -eq "$Name"))
			{
				Try
				{
					$Group = $Computer.Create("Group", $Name)
					$Group.SetInfo()
					If ($Description.Length -ne 0)
					{
						$Group.Description = $Description
						$Group.SetInfo()
					}
				}
				Catch
				{
					New-MsgBox -Message "$_" -Title "Error"
				}
			}
		}
	}
}