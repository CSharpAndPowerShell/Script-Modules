#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Install-Program {
	<#
    .SYNOPSIS
    Instalar programas.
    
    .DESCRIPTION
    Se encarga de instalar de manera desatendida paquetes MSI y EXE.

    .EXAMPLE
    Install-Program -Path C:\Ruta\Teamviewer.msi
	Install-Program -Path C:\Ruta\Teamviewer.exe
 
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
    [CmdletBinding()]
	Param (
		[parameter(mandatory=$true,position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta del instalador con extensión .msi.")]
		[ValidateNotNullorEmpty()]
		[string]$Path
	)
	
    Process {
		Try {
			If ($Path.EndsWith(".msi")) {
				Start-Process "$Path" /qb -Wait
			}
			ElseIf ($Path.EndsWith(".exe")) {
				Start-Process "$Path" /Silent -Wait
			}
		}
		Catch {
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
    }
}

Export-ModuleMember Install-Program