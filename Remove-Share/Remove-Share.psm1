#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
Function Remove-Share
{
    <#
    .SYNOPSIS
    Eliminar recursos compartidos.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Path", aunque solo el primero es obligatorio. Esta función verifica que el recurso esté compartido para intentar dejar de compartirlo. Si "RemovePath" se establece en $True se eliminará la carpeta que estaba compartida.
 
    .EXAMPLE
    Remove-Share -Sharename "P" -RemovePath
    Remove-Share "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de recurso compartido a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Sharename,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Si se establece, se borra la carpeta compartida.")]
		[Switch]$RemovePath = $false
	)
	
	Process
	{
		Try
		{
			If ((Get-WmiObject -Class WIN32_Share -Filter "Name='$Sharename'").Name -eq $Sharename)
			{
				#Verifica si el recurso está compatido.
				$Share = (Get-WmiObject Win32_Share -Filter "Name='$Sharename'")
				$Share.Delete() | Out-Null
				if ($RemovePath)
				{
					$SharePath = $Share.Path
					Remove-Item -Path "$SharePath" -Recurse -Force
				}
			}
		}
		Catch
		{
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}