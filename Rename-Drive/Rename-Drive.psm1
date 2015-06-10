Function Rename-Drive
{
    <#
    .SYNOPSIS
    Renombra unidades locales y de red.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Letter" y "Name", ambos son obligatorios.
 
    .EXAMPLE
    Rename-Drive -Letter "Z" -Name "Backup"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra de la unidad local o de red a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[Char]$Letter,
		[Parameter(Position = 1, Mandatory = $True, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nuevo nombre para la unidad local o de red.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Begin
	{
		$objDrive = New-Object -ComObject Shell.Application
	}
	
	Process
	{
		Try
		{
			$objDrive.NameSpace($Letter + ":").Self.Name = $Name
		}
		Catch
		{
			Write-Error -Message "$_"
		}
	}
}