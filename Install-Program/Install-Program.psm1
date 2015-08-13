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

Function Install-Program
{
	<#
    .SYNOPSIS
    Instalar programas.
    
    .DESCRIPTION
    Se encarga de instalar de manera desatendida paquetes MSI y EXE.
	
    .EXAMPLE
    Install-Program -Path C:\Ruta\Teamviewer.msi
	Install-Program -Path C:\Ruta\Teamviewer.exe
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	#region "Parámetros"
	Param
	(
		[parameter(mandatory = $true, position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta del instalador con extensión .msi.")]
		[ValidateNotNullorEmpty()]
		[string]$Path
	)
	#endregion
	#region "Funciones"
	Process
	{
		Try
		{
			If ($Path.EndsWith(".msi"))
			{
				Start-Process "$Path" /qb -Wait
			}
			ElseIf ($Path.EndsWith(".exe"))
			{
				Start-Process "$Path" /install /quiet -Wait
			}
			Else
			{
				Write-Error -Message "El archivo '$_' no es un programa." -Category 'InvalidType'
			}
		}
		Catch
		{
			Write-Error -Message "$_" -Category 'ObjectNotFound'
		}
	}
	#endregion
}
#region Alias
#Se utilizan alias para poder usar el módulo con otro nombre, para mantener compatibilidad
New-Alias -Name Install-MSI -value Install-Program -Description "Consultar: Get-Help Install-Program"
New-Alias -Name Install-EXE -value Install-Program -Description "Consultar: Get-Help Install-Program"
Export-ModuleMember -Function * -Alias *
#endregion