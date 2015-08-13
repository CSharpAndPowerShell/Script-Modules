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

Function Remove-AutoStart
{
    <#
    .SYNOPSIS
    Elimina un programa que arranque automaticamente inicio de sesión de cualquier usuario.
    
    .DESCRIPTION
    Esta función necesita el parámetro "Name".
 
    .EXAMPLE
    Remove-AutoStart -Name "Script"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
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
				Show-MessageBox -Message "La entrada no existe" -Title "Advertencia" | Out-Null
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}