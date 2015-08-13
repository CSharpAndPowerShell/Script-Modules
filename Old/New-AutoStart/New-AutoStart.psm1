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

Function New-AutoStart
{
    <#
    .SYNOPSIS
    Registrar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario por siempre, hasta que se elimine; usar "Remove-AutoStart".
    
    .DESCRIPTION
    Esta función necesita dos parámetros, "Value" y "Name", con el valor de lo que se requiere iniciar automáticamente.
 
    .EXAMPLE
    New-AutoStart -Value "C:\Mi programa.bat" -Name "Mi programa"
    New-AutoStart -Value "C:\Windows\System32\cmd.exe" -Name "Consola de CMD"
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	#region "Parametros"
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta al archivo a ejecutar en el siguiente reinicio.")]
		[ValidateNotNullOrEmpty()]
		[String]$Value,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la entrada que identifica el AutoStart.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		if ($Name -eq $null)
		{
			$Name = $Value.Split("\")[-1]
		}
		try
		{
			Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name $Name -Value $Value -Force -ErrorAction 'Stop' | Out-Null
		}
		catch
		{
			Write-Error -Message "No tiene permiso para realizar esta acción." -Category 'PermissionDenied'
		}
	}
	#endregion
}