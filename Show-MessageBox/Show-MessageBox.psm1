Function Show-MessageBox
{
	<#
    .SYNOPSIS
    Muestra una ventana de información o de opciones.
    
    .DESCRIPTION
	Muestra una ventana de mensaje o de opciones. Esta funcion se puede cargar a una variable y validad contra la etiqueta del botón.
	
    .EXAMPLE
	Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia"
	Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia" -Buttons YesNoCancel
    Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia" -Type Error -Buttons RetryCancel
	
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Cuerpo de la ventana.")]
		[string]$Message,
		[Parameter(ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Titulo de la ventana.")]
		[string]$Title,
		[Parameter(ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true, HelpMessage = "Tipo de botones a mostrar.")]
		[ValidateSet("OK", "OKCancel", "AbortRetryIgnore", "YesNoCancel", "YesNo", "RetryCancel")]
		[String]$Buttons = "OK",
        [Parameter(ValueFromPipeline = $true, Position = 3, ValueFromPipelineByPropertyName = $true, HelpMessage = "Tipo de ventana a mostrar.")]
		[ValidateSet("Error", "Information", "Warning")]
		[String]$Type = "Information"
	)
	
	Begin
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null 
	}
	
	Process
	{
        [Windows.Forms.MessageBox]::Show($Message, $Title, [Windows.Forms.MessageBoxButtons]::$Buttons, [System.Windows.Forms.MessageBoxIcon]::$Type,`
        [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)
	}
}