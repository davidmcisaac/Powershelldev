$domain = "ou=abc,ou=level 2,dc=level 3,dc=scottish,dc=mci,dc=local"
$a = @($domain)

$alength = ([regex]::Matches($a, "," )).count
$areallen = @{expression=($alength - 1)}

$b = $domain -split ","
write-host " array created"
$b[-1]
