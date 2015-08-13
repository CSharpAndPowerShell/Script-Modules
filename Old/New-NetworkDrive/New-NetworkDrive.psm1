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

Function New-NetworkDrive
{
    <#
    .SYNOPSIS
    Conectar y renombrar unidades de red.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Path", ambos son obligatorios. Si no se establece el parámetro "Name", la unidad tomará el nombre del recurso compartido, no se muestra el nombre del host ni la dirección IP donde se encuentra el recurso compartido.
	
    .EXAMPLE
    New-NetworkDrive -Letter "Z" -Path "\\127.0.0.1\C$"
    New-NetworkDrive -Letter "Z" -Path "\\127.0.0.1\C$" -Name "Sistema"
	
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra que será utilizada como punto de montaje para la unidad de red.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		[Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta UNC del recurso compartido.")]
		[ValidateNotNullOrEmpty()]
		[String]$Path,
		[Parameter(Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario con permiso sobre la unidad de red.")]
		[String]$User,
		[Parameter(Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Contraseña del usuario con permiso sobre la unidad de red.")]
		[String]$Pass,
		[Parameter(Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la unidad de red.")]
		[String]$Name
	)
	
	Begin
	{
		$WshNetwork = New-Object -ComObject Wscript.Network
	}
	
	Process
	{
		$Path = $Path.TrimEnd("\")
		Try
		{
			If ($User.Length -ne 0)
			{
				If ($Pass.Length -ne 0)
				{
					$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false, "$User", "$Pass")
				}
				Else
				{
					$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false, "$User")
				}
			}
			Else
			{
				$WshNetwork.MapNetworkDrive("$Letter" + ":", "$Path", $false)
			}
			If ($Name.Length -eq 0)
			{
                $Name = $Path.Split("\")[-1]
			}
		    Rename-Drive -Letter $Letter -Name "$Name"
		}
		Catch
		{
			Write-Error -Message "$_"
		}
	}
}
