Function Remove-AutoStart
{
    <#
    .SYNOPSIS
    Elimina un programa que arranque automaticamente inicio de sesión de cualquier usuario.
    
    .DESCRIPTION
    Esta función necesita el parámetro "Name".
 
    .EXAMPLE
    Remove-AutoStart -Name "Script"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre de la entrada que identifica el AutoStart.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		Try
		{
			$Key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\"
			$Test = Get-ItemProperty $Key $Name -ErrorAction SilentlyContinue
			If ($Test -ne $null)
			{
				Remove-ItemProperty $Key -Name "$Name" -Force
			}
			Else
			{
				Show-MessageBox -Message "La entrada no existe" -Title "Advertencia" | Out-Null
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" | Out-Null
		}
	}
}