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

function Remove-NetworkDrive
{
	<#
    .SYNOPSIS
    Desmonta unidades de red.
    
    .DESCRIPTION
    Esta función necesita la letra de la unidad a desmontar "Letter". O utilice "All" para desmontar todas las unidades de red.
 
    .EXAMPLE
    Remove-NetworkDrive -Letter "C"
	Remove-NetworkDrive -All
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra de la unidad a desmontar.")]
		[Char]$Letter,
		[Parameter(Position = 1, HelpMessage = "Desmonta todas las unidades de red.")]
		[Switch]$All = $false
	)
	Begin
	{
		$WshNetwork = New-Object -ComObject Wscript.Network
	}
	Process
	{
		Try
		{
			if ($All)
			{
				foreach ($Letter in $WshNetwork.EnumNetworkDrives())
				{
					if ($Letter.Length -eq 2)
					{
						$WshNetwork.RemoveNetworkDrive($Letter + ":", $true)
					}
				}
			}
			else
			{
				$WshNetwork.RemoveNetworkDrive($Letter + ":", $true)
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}