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
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
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
			Write-Error -Message "$_"
		}
	}
}