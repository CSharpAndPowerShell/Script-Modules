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
		[Parameter(Position = 0, HelpMessage = "Renombra la interfaz Bucle.")]
		[switch]$Bucle = $false,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nuevo nombre de el adaptador.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name
	)
	
	Process
	{
		$Adapters = Get-WmiObject -Class Win32_NetworkAdapter -filter "AdapterType like 'Ethernet%' and not ServiceName like 'v%'" #v% excluye los nombres que comienzan con v, para no mostrar las interfaces virtuales
		foreach ($Adapter in $Adapters)
		{
			$AdapName = $Adapter.Name
			switch ($AdapName)
			{
				#Ethernet
				{
					($AdapName.Contains("GBE")) -or
					($AdapName.Contains("Gigabit")) -or
					($AdapName.Contains("Ethernet")) -or
					($AdapName.Contains("Wired"))
				} {
					if ($Ethernet)
					{
						try
						{
							$i = 1;
							if ($i > 1)
							{
								$tmpName = $Name + " " + $i
								$Adapter.NetConnectionID = $tmpName
								$Adapter.Put() | Out-Null
							}
							else
							{
								$Adapter.NetConnectionID = $Name
								$Adapter.Put() | Out-Null
							}
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
				#Wireless
				{
					($AdapName.Contains("Wireless")) -or
					($AdapName.Contains("WiFi")) -or
					($AdapName.Contains("802.11"))
				} {
					if ($Wireless)
					{
						try
						{
							$i = 1;
							if ($i > 1)
							{
								$tmpName = $Name + " " + $i
								$Adapter.NetConnectionID = $tmpName
								$Adapter.Put() | Out-Null
							}
							else
							{
								$Adapter.NetConnectionID = $Name
								$Adapter.Put() | Out-Null
							}
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
				#Bluetooth
				{
					($AdapName.Contains("Bluetooth")) -or
					($AdapName.Contains("802.15.1"))
				} {
					if ($Bluetooth)
					{
						try
						{
							$i = 1;
							if ($i > 1)
							{
								$tmpName = $Name + " " + $i
								$Adapter.NetConnectionID = $tmpName
								$Adapter.Put() | Out-Null
							}
							else
							{
								$Adapter.NetConnectionID = $Name
								$Adapter.Put() | Out-Null
							}
						}
						catch
						{
							Write-Error "No ha sido posible cambiar de nombre a la interfaz."
						}
					}
				}
				#Bucle
				{
					($AdapName.Contains("bucle")) -or
					($AdapName.Contains("KM-TEST"))
				} {
					if ($Bucle)
					{
						try
						{
							$i = 1;
							if ($i > 1)
							{
								$tmpName = $Name + " " + $i
								$Adapter.NetConnectionID = $tmpName
								$Adapter.Put() | Out-Null
							}
							else
							{
								$Adapter.NetConnectionID = $Name
								$Adapter.Put() | Out-Null
							}
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