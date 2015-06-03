Function Add-ToGroup
{
    <#
    .SYNOPSIS
    Agrega usuarios o grupos a grupos locales.
    
    .DESCRIPTION
    Esta función necesita dos parámetros; "Name" y "Group". Esta función verifica si el usuario o grupo existen en el grupo, si no existen los agrega.

    .EXAMPLE
    Add-ToGroup -Name "NuevoUsuario" -Group "Administradores"
 
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	#region "Parámetros"
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo a añadir.")]
		[ValidateNotNullOrEmpty()]
		[String]$Name,
		[Parameter(Mandatory = $True, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Grupo al que pertenecerá el usuario o grupo.")]
		[ValidateNotNullOrEmpty()]
        [Array]$Group
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		Try
        {
            foreach ($G in $Group)
            {
                New-Group -Name $G
				$ToGroup = [ADSI]"WinNT://$ENV:Computername/$G,group"
				$ToGroup.Add("WinNT://$Name")
            }
		}
		Catch
		{
			Write-Error -Message "$_" -Category 'InvalidArgument'
		}
    }
    #endregion
}