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

Function New-AutoStartOnce
{
    <#
    .SYNOPSIS
    Registar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario una única vez.
    
    .DESCRIPTION
    Esta función necesita un parámetro, "Value", con el valor de lo que se requiere iniciar automáticamente.
 
    .EXAMPLE
    New-AutoStartOnce -Value "C:\Script.bat"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta al archivo a ejecutar en el siguiente reinicio.")]
		[ValidateNotNullOrEmpty()]
		[String]$Value
	)
	
	Process
	{
		$Name = $Value.Split("\")[-1]
		Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\RunOnce -Name $Name -Value $Value -Force | Out-Null
	}
}