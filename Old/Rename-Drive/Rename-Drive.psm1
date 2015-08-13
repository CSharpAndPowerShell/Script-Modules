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

Function Rename-Drive
{
    <#
    .SYNOPSIS
    Renombra unidades locales y de red.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Name", ambos son obligatorios.
 
    .EXAMPLE
    Rename-Drive -Letter "Z" -Name "Backup"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra de la unidad local o de red a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		[Parameter(Position = 1, Mandatory = $True, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nuevo nombre para la unidad local o de red.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Begin
	{
		$objDrive = New-Object -ComObject Shell.Application
	}
	
	Process
	{
		Try
		{
			$objDrive.NameSpace($Letter + ":").Self.Name = $Name
		}
		Catch
		{
			Write-Error -Message "$_"
		}
	}
}