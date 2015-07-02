Function Rename-NetworkAdapter
{
    <#
    .SYNOPSIS
    Renombra adaptadores de red.
    
    .DESCRIPTION
    Esta función necesita un parámetro, "Name" que sera el nombre de la interfaz y un tipo de adaptador.
 
    .EXAMPLE
    Rename-NetworkAdapter -Ethernet -Name "Ethernet"
	Rename-NetworkAdapter -Wireless -Name "Wireless"
	Rename-NetworkAdapter -Bluetooth -Name "Bluetooth"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(Position = 0, HelpMessage = "Renombra la interfaz Ethernet.")]
		[switch]$Ethernet = $false,
		[Parameter(Position = 0, HelpMessage = "Renombra la interfaz Wireless.")]
		[switch]$Wireless = $false,
		[Parameter(Position = 0, HelpMessage = "Renombra la interfaz Bluetooth.")]
		[switch]$Bluetooth = $false,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nuevo nombre de el adaptador.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		$Adapters = Get-WmiObject -Class Win32_NetworkAdapter -filter "AdapterType like 'Ethernet%' and not ServiceName like 'v%'" #v% excluye los nombres que comienzan con v, para no mostrar las interfaces virtuales
		if ($Ethernet)
		{
			foreach ($Adapter in $Adapters)
			{
				$AdapName = $Adapter.Name
				switch ($AdapName)
				{
					{
						($AdapName.Contains("GBE")) -or
						($AdapName.Contains("Gigabit")) -or
						($AdapName.Contains("Ethernet")) -or
						($AdapName.Contains("Wired"))
					} {
						$Adapter.NetConnectionID = $Name
						try
						{
							$Adapter.Put() | Out-Null
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
			}
		}
		if ($Wireless)
		{
			foreach ($Adapter in $Adapters)
			{
				$AdapName = $Adapter.Name
				switch ($AdapName)
				{
					{
						($AdapName.Contains("Wireless")) -or
						($AdapName.Contains("WiFi")) -or
						($AdapName.Contains("802.11"))
					} {
						$Adapter.NetConnectionID = $Name
						try
						{
							$Adapter.Put() | Out-Null
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
			}
		}
		if ($Bluetooth)
		{
			foreach ($Adapter in $Adapters)
			{
				$AdapName = $Adapter.Name
				switch ($AdapName)
				{
					{
						($AdapName.Contains("Bluetooth"))
					} {
						$Adapter.NetConnectionID = $Name
						try
						{
							$Adapter.Put() | Out-Null
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
			}
		}
	}
}