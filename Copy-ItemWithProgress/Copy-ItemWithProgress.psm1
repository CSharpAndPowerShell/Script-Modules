﻿#requires -Version 4.0
#requires -Modules New-MsgBox
Function Copy-ItemWithProgress
{
	<#
    .SYNOPSIS
    Copia archivos y muestra una barra de progreso.
    
    .DESCRIPTION
    Copia y muestra barra de progreso, necesita parametros "Path" que es la ruta origen y "Destination" que sería el destino.
	
    .EXAMPLE
    Copy-ItemWithProgress -Path C:\Origen -Destination D:
	
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Path,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Destination
	)
	
	Process
	{
		$Files = Get-ChildItem $Path -Recurse
		$Destination = $Destination.TrimEnd("\")
		[Int]$i = 0
		Foreach ($File in $Files)
		{
			$i++
			If ($File.PSIsContainer -and $Files.mode.Contains("a"))
			{
				mkdir $File.PSParentPath -Force | Out-Null
			}
			$Dest = $Destination + $File.PSPath.Substring(38).Replace($Path, "")
			Try
			{
				Copy-Item -Path ($File.PSPath.Substring(38)) -Destination "$Dest" -Force
			}
			Catch
			{
				New-MsgBox -Message "$_" -Title "Error" | Out-Null
			}
			[Int]$Percent = (($i / $Files.Length) * 100)
			Write-Progress -Activity "Copiando" -Status "$Percent %  Completado" -CurrentOperation "Copiando '$File' a '$Dest'" -PercentComplete $Percent
		}
		Write-Progress -Activity "Copiando" -Completed
	}
}