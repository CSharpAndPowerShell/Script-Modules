#requires -Version 2.0
Function Rename-NetworkDrive
{
    <#
    .SYNOPSIS
    Renombra unidades de red.
    
    .DESCRIPTION
    Esta función necesita tres parámetros; "Letter" y "Name", ambos son obligatorios.
 
    .EXAMPLE
    Rename-NetworkDrive -Letter "Z" -Name "Backup"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param
    (
		[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Letra de la unidad de red a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		
		[Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nuevo nombre para la unidad de red.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
    )

    Process {
		Try
		{
	        $Drive = $Letter + ":"
	        $NetDrive = New-Object -ComObject Shell.Application
	        $NetDrive.NameSpace($Drive).Self.Name = $Name
		}
		Catch
		{
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
		}
    }
}

Export-ModuleMember Rename-NetworkDrive



