#requires -RunAsAdministrator
#requires -Version 4.0
Function New-AutoStart
{
    <#
    .SYNOPSIS
    Registar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario por siempre, hasta que se elimine; usar "Remove-AutoStartAllways".
    
    .DESCRIPTION
    Esta función necesita dos parámetros, "Value" y "Name", con el valor de lo que se requiere iniciar automáticamente.
 
    .EXAMPLE
    New-AutoStart -Value "C:\Mi programa.bat" -Name "Mi programa"
    New-AutoStart -Value "C:\Windows\System32\cmd.exe" -Name "Consola de CMD"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta al archivo a ejecutar en el siguiente reinicio.")]
		[ValidateNotNullOrEmpty()]
		[String]$Value,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la entrada que identifica el AutoStart.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\Run -Name $Name -Value $Value -Force | Out-Null
	}
}

Export-ModuleMember New-AutoStart