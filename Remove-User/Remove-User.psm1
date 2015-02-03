#requires -RunAsAdministrator
#requires -Version 4.0
Function Remove-User {
    <#
    .SYNOPSIS
    Eliminar usuarios locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name", esta función verifica que el usuario exista para intentar borrarlo.
 
    .EXAMPLE
    Remove-User -Name "P"
    Remove-User "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
    
    [CmdletBinding()]
    Param (
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre de usuario a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
    Process {
		Try {
	        if ((Get-WmiObject -Class Win32_UserAccount).Name.Contains($Name)) { #Se valida si el usuario existe para borrarlo
		        $Computer = [adsi]"WinNT://$ENV:COMPUTERNAME"
		        $User = $Computer.Delete("user", $Name)
	        }
		}
		Catch {
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Remove-User