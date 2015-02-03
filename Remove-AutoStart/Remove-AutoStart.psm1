#requires -RunAsAdministrator
#requires -Version 4.0
Function Remove-AutoStart {
    <#
    .SYNOPSIS
    Registar un programa para que arranque automaticamente en el siguiente inicio de sesión de cualquier usuario por siempre, hasta que se elimine; usar "Remove-AutoStart".
    
    .DESCRIPTION
    Esta función necesita el parámetro "Name".
 
    .EXAMPLE
    Remove-AutoStart -Name "Script"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre de la entrada que identifica el AutoStart.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
    )
	
    Process {
		Try {
			$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\"
			$Test = Get-ItemProperty $Key $Name -ErrorAction SilentlyContinue
			If($Test -ne $null) {
				Remove-ItemProperty $Key -Name "$Name" -Force
			}
			Else {
				[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
				[void][System.Windows.Forms.MessageBox]::Show("La entrada no existe","Advertencia")
			}
		}
		Catch {
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Remove-AutoStart