#requires -RunAsAdministrator
#requires -Version 2.0
Function Set-UAC
{
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
    param
    (
        [Parameter(Position=0,HelpMessage="Habilita UAC (Control de cuentas de usuario).")]
        [switch]$Enable=$false,

        [Parameter(Position=0,HelpMessage="Deshabilita UAC (Control de cuentas de usuario).")]
        [switch]$Disable=$false
    )
	
    if($Enable -and $Disable)
    {
        Write-Warning "No puede habilitar y deshabilitar esta función al mismo tiempo.`n"
    }
    else
    {
        Switch ($true)
        {
            $Disable
            {
                Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0
                Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
            }
            $Enable
            {
                Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 1
				Set-ItemProperty -Path hklm:\software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 1
            }
        }
    }
}

Export-ModuleMember Set-UAC