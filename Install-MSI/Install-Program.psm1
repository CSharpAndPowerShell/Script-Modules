#requires -Version 2.0
#requires -RunAsAdministrator
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
    Escrito por Cristopher Robles - crisrc012
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
    [CmdletBinding()]
	Param
	(
		[parameter(mandatory=$true,position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta del instalador con extensión .msi.")]
		[ValidateNotNullorEmpty()]
		[string]$Path
	)
	
    Process
    {
		try
		{
			if ($Path.EndsWith(".msi"))
			{
				Start-Process "$Path" /qr -Wait
			}
			elseif ($Path.EndsWith(".exe"))
			{
				Start-Process "$Path" /Silent -Wait
			}
		}
		Catch
		{
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Install-Program