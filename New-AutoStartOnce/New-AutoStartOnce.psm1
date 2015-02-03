#requires -RunAsAdministrator
#requires -Version 4.0
Function New-AutoStartOnce {
    <#
    .SYNOPSIS
    Registar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario una única vez.
    
    .DESCRIPTION
    Esta función necesita un parámetro, "Value", con el valor de lo que se requiere iniciar automáticamente.
 
    .EXAMPLE
    New-AutoStartOnce -Value "C:\Script.bat"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta al archivo a ejecutar en el siguiente reinicio.")]
		[ValidateNotNullOrEmpty()]
		[String]$Value
    )
	
    Process {
        $Name = $Value.Split("\")[-1]
        Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\RunOnce -Name $Name -Value $Value -Force | Out-Null
    }
}

Export-ModuleMember New-AutoStartOnce