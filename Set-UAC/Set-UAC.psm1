#requires -RunAsAdministrator
#requires -Version 4.0
Function Set-UAC {
    <#
    .SYNOPSIS
    Modifica el control de cuentas de usuario.
    
    .DESCRIPTION
    Habilita y deshabilita el control de cuentas de usuario (UAC).
 
    .EXAMPLE
    Set-UAC -Disable
    Set-UAC -Enable
 
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Position=0,HelpMessage="Habilita UAC (Control de cuentas de usuario).")]
        [switch]$Enable=$false,
        [Parameter(Position=0,HelpMessage="Deshabilita UAC (Control de cuentas de usuario).")]
        [switch]$Disable=$false
    )
	
    If($Enable -and $Disable) {
		[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
		[void][System.Windows.Forms.MessageBox]::Show("No puede habilitar y deshabilitar esta función al mismo tiempo.","Error")
    }
    Else {
        Switch($true) {
            $Disable {
				$Value = 0
            }
            $Enable {
				$Value = 1
            }
        }
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value $Value
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value $Value
    }
}

Export-ModuleMember Set-UAC