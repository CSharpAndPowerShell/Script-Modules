#requires -Version 4.0
Function Rename-Drive {
    <#
    .SYNOPSIS
    Renombra unidades de disco local.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Name", ambos son obligatorios.
 
    .EXAMPLE
    Rename-Drive -Letter "C" -Name "Sistema"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
		[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Letra de la unidad a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		
		[Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nuevo nombre de la unidad.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
    )

    Process {
		Try {
	        $DriveLetter = "DriveLetter = '" + $Letter + ":'"
	        $Drive = Get-WmiObject -Class win32_volume -Filter $DriveLetter
	        $Drive.Label = $Name
	        $Drive.put() | Out-Null
		}
		Catch {
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Rename-Drive