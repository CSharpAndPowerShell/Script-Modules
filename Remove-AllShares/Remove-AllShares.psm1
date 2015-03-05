#requires -RunAsAdministrator
#requires -Modules Remove-Share, New-MsgBox
#requires -Version 4.0
Function Remove-AllShares
{
    <#
    .SYNOPSIS
    Eliminar todos los recursos compartidos.
    
    .DESCRIPTION
    Esta función tiene los modificadores; "Hidden" y "NoSafe", aunque solo el primero es obligatorio. Esta función verifica que el recurso esté compartido para intentar dejar de compartirlo. Si "RemovePath" se establece en $True se eliminará la carpeta que estaba compartida.
 
    .EXAMPLE
    Remove-AllShares
    Remove-AllShares -Hidden
    Remove-AllShares -NoSafe
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Position = 0, HelpMessage = "Se especifica para eliminar todos los recursos compartidos, incluyendo recursos administrativos de sistema.")]
		[Switch]$NoSafe = $false,
		[Parameter(Position = 0, HelpMessage = "Se especifica para eliminar todos los recursos compartidos y los ocultos, no elimina recursos administrativos.")]
		[Switch]$Hidden = $false
	)
	
	If ($NoSafe -and $Hidden)
	{
		New-MsgBox -Message "No puede establecer varios modificadores simultaneamente." -Title "Error" | Out-Null
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
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
		Finally
		{
			Write-Progress -Activity "Eliminando Recursos" -Completed #Actualiza la barra de Progreso
		}
	}
}