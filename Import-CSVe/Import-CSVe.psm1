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
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	#region "Parámetros"
	param
	(
		[parameter]
		[[ValidateNotNullOrEmpty()]]
		[String]$Path,
		[parameter]
		[String]$Delimiter = ";",
		[parameter]
		[String]$Value,
		[parameter]
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