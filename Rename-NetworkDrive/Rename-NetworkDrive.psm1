#requires -Version 4.0
#requires -Modules New-MsgBox
Function Rename-NetworkDrive {
    <#
    .SYNOPSIS
    Renombra unidades de red.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Name", ambos son obligatorios.
 
    .EXAMPLE
    Rename-NetworkDrive -Letter "Z" -Name "Backup"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
		[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Letra de la unidad de red a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		[Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nuevo nombre para la unidad de red.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
    )

    Process {
		Try {
	        $Drive = $Letter + ":"
	        $NetDrive = New-Object -ComObject Shell.Application
	        $NetDrive.NameSpace($Drive).Self.Name = $Name
		}
		Catch {
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
    }
}

Export-ModuleMember Rename-NetworkDrive