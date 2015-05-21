﻿Function Install-Program
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
    Escrito por Cristopher Robles y Leider Rivera Martínez
 
    .LINK
    https://github.com/PowerShellScripting
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