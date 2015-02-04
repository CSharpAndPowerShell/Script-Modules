#requires -Version 4.0
Function New-MsgBox {
	<#
    .SYNOPSIS
    Muestra una ventana de información o de opciones.
    
    .DESCRIPTION
	Muestra una ventana de mensaje o de opciones. Esta funcion se puede cargar a una variable y validad contra la etiqueta del botón.
	
    .EXAMPLE
	New-MsgBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia"
	New-MsgBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia" -Buttons YesNoCancel
	
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	[CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true,Position=0,ValueFromPipelineByPropertyName=$true,HelpMessage="Cuerpo de la ventana.")]
        [string]$Message,
        [Parameter(ValueFromPipeline=$true,Position=1,ValueFromPipelineByPropertyName=$true,HelpMessage="Titulo de la ventana.")]
        [string]$Title,
        [Parameter(ValueFromPipeline=$true,Position=2,ValueFromPipelineByPropertyName=$true,HelpMessage="Tipo de botones a mostrar.")]
        [ValidateSet("OK","OKCancel","AbortRetryIgnore","YesNoCancel","YesNo","RetryCancel")]
        [String]$Buttons = "OK"
    )
	[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[System.Windows.Forms.MessageBox]::Show("$Message","$Title",$Buttons)
}

Export-ModuleMember New-MsgBox