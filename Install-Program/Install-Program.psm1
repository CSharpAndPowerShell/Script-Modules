#requires -RunAsAdministrator
#requires -Modules Show-MessageBox
Function Install-Program
{
	<#
    .SYNOPSIS
    Instalar programas.
    
    .DESCRIPTION
    Se encarga de instalar de manera desatendida paquetes MSI y EXE.
	
    .EXAMPLE
    Install-Program -Path C:\Ruta\Teamviewer.msi
	Install-Program -Path C:\Ruta\Teamviewer.exe
 
    .NOTES
    Escrito por Cristopher Robles y Leider Rivera Martínez
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param
	(
		[parameter(mandatory = $true, position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta del instalador con extensión .msi.")]
		[ValidateNotNullorEmpty()]
		[string]$Path
	)
	
	Process
	{
		Try
		{
			If ($Path.EndsWith(".msi"))
			{
				Start-Process "$Path" /qb -Wait
			}
			ElseIf ($Path.EndsWith(".exe"))
			{
				Start-Process "$Path" /install /quiet -Wait
			}
		}
		Catch
		{
			Show-MessageBox -Message "$_" -Title "Error" -Type Error | Out-Null
		}
	}
}