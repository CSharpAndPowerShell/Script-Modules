function Get-AutoStart
{
	<#
    .SYNOPSIS
    Devuelve lista de programas que se ejecutan al arranque.
    
    .DESCRIPTION
    Devuelve lista de programas que se ejecutan en cada arranque automáticamente. Util para obtener el nombre correcto de la entrada a borrar, para esto use "Remove-AutoStart".
 
    .EXAMPLE
    Get-AutoStart
	(Get-AutoStart)[0]
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	(Get-Item -Path hklm:\software\Microsoft\Windows\CurrentVersion\Run).Property
}
