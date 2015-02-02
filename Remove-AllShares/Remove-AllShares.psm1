#requires -RunAsAdministrator
#requires -Version 2.0
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
    
    [CmdletBinding()]
    Param
	(		
		[Parameter(Position=0,HelpMessage="Se especifica para eliminar todos los recursos compartidos, incluyendo recursos administrativos de sistema.")]
		[Switch]$NoSafe=$false,
		
		[Parameter(Position=0,HelpMessage="Se especifica para eliminar todos los recursos compartidos y los ocultos, no elimina recursos administrativos.")]
		[Switch]$Hidden=$false
	)
	
    Process
    {
		if($NoSafe -and $Hidden)
		{
			Write-Warning "No puede establecer varios modificadores al mismo tiempo.`nEste modulo no tiene poderes de super vaca."
		}
		else
		{
			Try
			{
				$Resources = (Get-WmiObject -Class WIN32_Share).Name #Obteniendo lista de recursos
				Foreach ($Resource in $Resources)
				{ #Se eliminan los recursos
	                $i++ #Porcentaje de la barra de progreso
					Switch($true)
					{
						$NoSafe
						{
	                        Write-Progress -Activity "Eliminando Recursos" -Status "$i %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete (($i / $Resources.Length) * 100 ) #Actualiza la barra de Progreso
							Remove-Share $Resource
						}
						$Hidden
						{
							if(($Resource -ne "ADMIN$") -and ($Resource -ne "IPC$") -and ($Resources.Length -gt 2) -and ($Resource -ne "NETLOGON") -and ($Resource -ne "SYSVOL"))
							{
	                            Write-Progress -Activity "Eliminando Recursos" -Status "$i %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete (($i / $Resources.Length) * 100 ) #Actualiza la barra de Progreso
								Remove-Share $Resource
							}
						}
						default
						{
							if((!($Resource.Contains("$"))) -and ($Resource -ne "NETLOGON") -and ($Resource -ne "SYSVOL"))
							{
	                            Write-Progress -Activity "Eliminando Recursos" -Status "$i %  Completado" -CurrentOperation "Eliminando $Resource..." -PercentComplete (($i / $Resources.Length) * 100 ) #Actualiza la barra de Progreso
								Remove-Share $Resource
							}
						}
					}
				}
			}
			Catch
			{
				[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
				[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
			}
			Finally
			{
				Write-Progress -Activity "Eliminando Recursos" -Completed #Actualiza la barra de Progreso
			}
		}
    }
}

Export-ModuleMember Remove-AllShares



