#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Remove-Share {
    <#
    .SYNOPSIS
    Eliminar recursos compartidos.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Path", aunque solo el primero es obligatorio. Esta función verifica que el recurso esté compartido para intentar dejar de compartirlo. Si "RemovePath" se establece en $True se eliminará la carpeta que estaba compartida.
 
    .EXAMPLE
    Remove-Share -Sharename "P" -RemovePath "C:\P"
    Remove-Share "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre de recurso compartido a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Sharename,
		[Parameter(Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta hacia el recurso compartido a eliminar.")]
		[String]$Path
	)
	
    Process {
		Try {
	        If ((Get-WmiObject -Class WIN32_Share).Name.Contains($Sharename)) { #Verifica si el recurso está compatido.
	            $Share = (Get-WmiObject Win32_Share)[(Get-WmiObject Win32_Share).Name.IndexOf($Sharename)]
	            $Share.Delete() | Out-Null
	            If($Path.Length -ne 0) { #Se borra la carpeta compatida si se usa el parametro "Path"
	                Remove-Item $Path -Force -Recurse
	            }
	        }
		}
		Catch {
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
    }
}

Export-ModuleMember Remove-Share