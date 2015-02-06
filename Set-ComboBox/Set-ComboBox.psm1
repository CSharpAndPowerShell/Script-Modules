Function Set-ComboBox {
	<#
	.SYNOPSIS
	Cargar datos a un ComboBox.
	
	.DESCRIPTION
	Usar para cargar datos a un ComboBox.
	
	.EXAMPLE
	Set-ComboBox -ComboBox $combobox1 -Items "Casa", "Carro", "Moto"
	
	.NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
	#>
	
	Param (
		[Parameter(Mandatory=$true)]
		[ValidateNotNull()]
		[System.Windows.Forms.ComboBox]$ComboBox,
		[Parameter(Mandatory=$true)]
		[ValidateNotNull()]
		$Items,
	    [Parameter(Mandatory=$false)]
		[Switch]$Append
	)
	
	If(!($Append)) {
		$ComboBox.Items.Clear()
	}
	If($Items -is [Object[]]) {
		$ComboBox.Items.AddRange($Items)
	}
	ElseIf($Items -is [Array]) {
		$ComboBox.BeginUpdate()
		ForEach($Item in $Items) {
			$ComboBox.Items.Add($Item)
		}
		$ComboBox.EndUpdate()
	}
	Else {
		$ComboBox.Items.Add($Items)
	}
}

Export-ModuleMember Set-ComboBox