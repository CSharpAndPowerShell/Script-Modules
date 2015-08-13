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

Function Import-CSVe
{
	<#
    .SYNOPSIS
    Importa CSV y reemplaza datos.
    
    .DESCRIPTION
    Importa un archivo CSV y reemplaza datos, para poder utilizar un archivo CSV genérico y cambiar datos masivamente.
	
    .EXAMPLE
    Import-CSVe -Path C:\Usuarios.csv -Value "00" -NewValue "02" | New-User
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	#region "Parámetros"
	param
	(
		[parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$Path,
		[parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
		[String]$Delimiter = ";",
		[parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
		[String]$Value,
		[parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 3, ValueFromPipelineByPropertyName = $true)]
		[String]$NewValue
	)
	#endregion
	#region "Funciones"
	Process
	{
		try
		{
			#Se carga el contenido del CSV en texto plano
			$CSV = Get-Content $Path
			#Se recorre el CSV en texto plano
			For ($i = 0; $i -lt $CSV.Length; $i++)
			{
				#Se reemplazan los valores requeridos
				$CSV[$i] = $CSV[$i].Replace($Value, $NewValue)
			}
			#Se escribe el texto plano editado a un CSV temporal
			Set-Content -Value $CSV -Path "$env:TEMP\tmp.csv" -Force
			#Se importa el CSV con formato y se devuelve el CSV editado en formato HashTable
			Return Import-Csv -Path "$env:TEMP\tmp.csv" -Delimiter $Delimiter -Encoding Default
		}
		catch
		{
			Write-Error -Message "No se ha podido importar el archivo CSV" -Category 'InvalidArgument'
		}
	}
	#endregion
}