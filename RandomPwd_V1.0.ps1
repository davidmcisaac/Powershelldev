<#
source http://blogs.technet.com/b/poshchap/archive/2016/01/29/use-a-foreach-loop-in-parameter-validation.aspx
current sets random password length to 12, (second section is for the number of alpa numeric characters)
Going to use this code as part of password reset tool for AD users
#>
Add-Type -AssemblyName System.web;[System.Web.Security.Membership]::GeneratePassword(12,5)
