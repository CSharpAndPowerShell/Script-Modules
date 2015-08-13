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
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del nuevo grupo.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Descripción del contenido o función del grupo.")]
		[String]$Description = "Grupo creado automáticamente"
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
                    Write-Error -Message "$_" -Category NotSpecified
				}
			}
		}
	}
}