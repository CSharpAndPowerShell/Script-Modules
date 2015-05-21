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
		[String]$Group
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		#region "Funciones Locales"
		#Verifica si ya el usuario ha sido agregado al grupo
        Function Test-User ($Group, $Name)
		{
			#Obtiene la lista de usuarios que integran el grupo
			$Users = net localgroup $Group
            foreach ($User in $Users)
            {
                if ($User -eq $Name)
                {
                    return $false
                }
                else
                {
                    return $true
                }
            }
		}
		#endregion
		If (Test-User -Group $Group -Name $Name)
		{
			Try
			{
				#Si el grupo no existe se crea
				New-Group -Name $Group -Description "Este grupo ha sido creado implicitamente por 'Add-ToGroup'."
				$ToGroup = [ADSI]"WinNT://$ENV:Computername/$Group,group"
				$ToGroup.Add("WinNT://$Name")
			}
			Catch
			{
				Write-Error -Message "$_" -Category 'InvalidArgument'
			}
		}
	}
	#endregion
}