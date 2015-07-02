Function Remove-Share
{
    <#
    .SYNOPSIS
    Eliminar recursos compartidos.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Path", aunque solo el primero es obligatorio. Esta función verifica que el recurso esté compartido para intentar dejar de compartirlo. Si "RemovePath" se establece en $True se eliminará la carpeta que estaba compartida.
 
    .EXAMPLE
    Remove-Share -Sharename "P" -Path
    Remove-Share "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de recurso compartido a eliminar.")]
		[ValidateNotNullOrEmpty()]
		[String]$Sharename,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Si se establece, se borra la carpeta compartida.")]
		[Switch]$Path = $false
	)
	
	Process
	{
		Try
		{
			#Eliminando Recurso compartido
			If ((Get-WmiObject -Class WIN32_Share -Filter "Name='$Sharename'").Name -eq $Sharename)
			{
				#Verifica si el recurso está compatido.
				$Share = (Get-WmiObject Win32_Share -Filter "Name='$Sharename'")
				$Share.Delete() | Out-Null
			}
		}
		Catch
		{
			Write-Error -Message "No ha sido posible eliminar el recurso compartido" -Category 'NotSpecified'
		}
		Try
		{
			if ($Path)
			{
				$SharePath = $Share.Path
				Remove-Item -Path "$SharePath" -Recurse -Force
			}
		}
		Catch
		{
			Write-Error -Message "No ha sido posible eliminar la carpeta del recurso compartido" -Category 'ObjectNotFound'
		}
	}
}