<#
Fun with strings
#>

$domain = "ou=abc,ou=level 2,ou=level 3,ou=scot,dc=mci,dc=local"
$domainarray = @($domain)
$domainlength = ([regex]::Matches($domainarray, "," )).count
$domaindccount = ([regex]::Matches($domainarray, "dc" )).count

write-host "object length $domainlength"
$domainreallength = @{expression=($domainlength - 1)}
write-host "object length -1 is " ($domainreallength.values)
$domainsplit = $domainarray -split ","

foreach ($i in $domainsplit) { write-host "objects within array $i";write-host "..."}
write-host "Last object in array is" $domainsplit[-1]
#$domainjoin = Join-Path -Path $domainsplit[-2] -ChildPath $domainsplit[-1] 

if ($domaindccount-le "5")
    {
    switch ($domaindccount)
    {
    1
    {# 'DC' regex count -eq 1
    Write-host "Error domain name input error"
    exit
    }
    2
    {# 'DC' regex count -eq 2
    $domainjoin = (($domainsplit[-2]) + "," + ($domainsplit[-1]))
    Write-host "domain name is" $domainjoin
    }
    3
    {# 'DC' regex count -eq 3
    $domainjoin = (($domainsplit[-3]) + "," + ($domainsplit[-2]) + "," + ($domainsplit[-1]))
    Write-host "domain name is" $domainjoin
    }
    4
    {# 'DC' regex count -eq 4
    $domainjoin = (($domainsplit[-4]) + "," + ($domainsplit[-3]) + "," + ($domainsplit[-2]) + "," + ($domainsplit[-1]))
    Write-host "domain name is" $domainjoin
    }
    5
    {# 'DC' regex count -eq 5
    $domainjoin = (($domainsplit[-5]) + "," + ($domainsplit[-4]) + "," + ($domainsplit[-3]) + "," + ($domainsplit[-2]) + "," + ($domainsplit[-1]))
    Write-host "domain name is" $domainjoin
    }
    }

        
        }
else 
    {
    Write-host "Error domain name input exceeding thresholds"
    exit
    }

exit