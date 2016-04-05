<#
Fun with strings
Trying to work out dynamic methods to build domain name.
Another reason is find out a users parent directory.
i.e. 
if user in this ou "ou=Manager,ou=GLA,ou=Scotland,ou=UK,ou=Europe,dc=mci,dc=local"
take me to one level up
ou=GLA,ou=Scotland,ou=UK,ou=Europe,dc=mci,dc=local"
#>

$ouSplit = New-Object System.Collections.ArrayList
$t = New-Object System.Collections.ArrayList
#DN -eq Distinguished Name from $usr = get-aduser testuser;$usr.DistinguishedName
$usrDn ="CN=testuser,ou=Manager,ou=GLA,ou=Scotland,ou=UK,ou=Europe,dc=mci,dc=local"
$usrDnArray = @($usrDn)
$ouLngth = ([regex]::Matches($usrDnArray, "," )).count
$ouDCcount = ([regex]::Matches($usrDnArray, "dc" )).count

write-host "object length $ouLngth"
$ouActLngth = @{expression=($ouLngth - 1)}
$ouParent = @{expression=($ouLngth - 2)}
write-host "object length -1 is " ($ouActLngth.values)
$ouSplit = $usrDnArray -split ","

foreach ($i in $ouSplit) 
    {#write out contents of array to ensure that it has been slit properly
    write-host "objects within array $i";
    write-host "..."
    }
#$t = $ouSplit[2 + 3 ..($ouSplit.length - 2)]
write-host "Last object in array is" $ouSplit[-1]

if ($ouDCcount-le "5")
    {#if count is less than 5 then. Execute switch direction to determine/split domain name from ldap string
    switch ($ouDCcount)
    {
    1
    {# 'DC' regex count -eq 1
    Write-host "Error domain name input error"
    exit
    }
    2
    {# 'DC' regex count -eq 2
    $domainjoin = (($ouSplit[-2]) + "," + ($ouSplit[-1]))
    Write-host "domain ldap name is" $domainjoin
    }
    3
    {# 'DC' regex count -eq 3
    $domainjoin = (($ouSplit[-3]) + "," + ($ouSplit[-2]) + "," + ($ouSplit[-1]))
    Write-host "domain ldap name is" $domainjoin
    }
    4
    {# 'DC' regex count -eq 4
    $domainjoin = (($ouSplit[-4]) + "," + ($ouSplit[-3]) + "," + ($ouSplit[-2]) + "," + ($ouSplit[-1]))
    Write-host "domain ldap name is" $domainjoin
    }
    5
    {# 'DC' regex count -eq 5
    $domainjoin = (($ouSplit[-5]) + "," + ($ouSplit[-4]) + "," + ($ouSplit[-3]) + "," + ($ouSplit[-2]) + "," + ($ouSplit[-1]))
    Write-host "domain ldap name is" $domainjoin
    }
    }

        
        }
else 
    {#bomb out and write error
    Write-host "Error domain name input exceeding thresholds"
    exit
    }
exit