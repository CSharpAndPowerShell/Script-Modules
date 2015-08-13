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

Function Remove-Group
{
    <#
    .SYNOPSIS
    Borrar grupos locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name", esta función verifica que el grupo exista para intentar borrarlo.
 
    .EXAMPLE
    Remove-Group -Name "P"
    Remove-Group "P"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del grupo a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Begin { $Computer = [ADSI]"WinNT://$ENV:Computername" }
	
	Process
	{
		Try
		{
			If ((Get-WmiObject -Class "Win32_Group" -Filter "Name='$Name'").Name -eq $Name)
			{
				#Comprueba si el grupo local existe y lo elimina
				$Computer.Delete("Group", $Name)
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}