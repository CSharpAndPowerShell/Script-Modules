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

Function Remove-AllShares
{
    <#
    .SYNOPSIS
    Elimina todos los recursos compartidos.
    
    .DESCRIPTION
    Esta función tiene los modificadores; "Hidden" y "NoSafe", aunque solo el primero es obligatorio. Esta función verifica que el recurso esté compartido para intentar dejar de compartirlo. Si "RemovePath" se establece en $True se eliminará la carpeta que estaba compartida.
 
    .EXAMPLE
    Remove-AllShares
    Remove-AllShares -Hidden
    Remove-AllShares -NoSafe
 
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	#region "Parámetros"
	Param (
		[Parameter(Position = 0, HelpMessage = "Se especifica para eliminar todos los recursos compartidos, incluyendo recursos administrativos de sistema.")]
		[Switch]$NoSafe = $false,
		[Parameter(Position = 0, HelpMessage = "Se especifica para eliminar todos los recursos compartidos y los ocultos, no elimina recursos administrativos.")]
		[Switch]$Hidden = $false
	)
	#endregion
	If ($NoSafe -and $Hidden)
	{
		Write-Error -Message "No puede establecer varios modificadores simultaneamente." -Category 'InvalidArgument'
	}
	Else
	{
		Try
		{
			[Int]$i = 0
			$Resources = (Get-WmiObject -Class WIN32_Share).Name #Obteniendo lista de recursos
			Foreach ($Resource in $Resources)
			{
				#Se eliminan los recursos
				$i++
				[Int]$Percent = (($i / $Resources.Length) * 100) #Porcentaje de la barra de progreso
				Switch ($true)
				{
					$NoSafe	{
						Write-Progress -Activity "Eliminando Recursos" -Status "$Percent %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete $Percent #Actualiza la barra de Progreso
						Remove-Share $Resource
					}
					$Hidden	{
						If (($Resource -ne "ADMIN$") -and ($Resource -ne "IPC$") -and ($Resources.Length -gt 2) -and ($Resource -ne "NETLOGON") -and ($Resource -ne "SYSVOL"))
						{
							Write-Progress -Activity "Eliminando Recursos" -Status "$Percent %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete $Percent #Actualiza la barra de Progreso
							Remove-Share $Resource
						}
					}
					Default
					{
						If ((!($Resource.Contains("$"))) -and ($Resource -ne "NETLOGON") -and ($Resource -ne "SYSVOL"))
						{
							Write-Progress -Activity "Eliminando Recursos" -Status "$Percent %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete $Percent #Actualiza la barra de Progreso
							Remove-Share $Resource
						}
					}
				}
			}
		}
		Catch
		{
			Write-Error -Message "$_" -Category 'NotSpecified'
		}
		Finally
		{
			Write-Progress -Activity "Eliminando Recursos" -Completed #Actualiza la barra de Progreso
		}
	}
}