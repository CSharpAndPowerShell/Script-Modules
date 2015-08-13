<#
CSharpAndPowerShell Modules, tries to help Microsoft Windows admins to write automated scripts easier.
Copyright (C) 2015  Cristopher Robles Ríos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

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
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Position = 0, HelpMessage = "Habilita UAC (Control de cuentas de usuario).")]
		[switch]$Enable = $false,
		[Parameter(Position = 0, HelpMessage = "Deshabilita UAC (Control de cuentas de usuario).")]
		[switch]$Disable = $false
	)
	
	If ($Enable -and $Disable)
	{
		Show-MessageBox -Message "No puede habilitar y deshabilitar esta función al mismo tiempo." -Title "Error" | Out-Null
	}
	Else
	{
		Switch ($true)
		{
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