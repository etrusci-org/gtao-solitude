@echo off

:: --- Configuration ---
:: Please see "First Time Configuration" in README.md before changing stuff here.

set firewallRuleName=gtao-solitude
set networkTimeout=15
set repeatInterval=180
set startupDelay=240


:: --- Magic ---
:: Do only change stuff here if you know what you're doing.

set breakTime=5
set txtSafeToClose=(it is currently safe to close this window)
set txtUnsafeToClose=(do not close this window now)

cls
echo YOU CAN NOW START THE GAME AND JOIN A PUBLIC SESSION ...
echo %txtSafeToClose%
timeout /t %startupDelay% /nobreak > nul

netsh advfirewall show currentprofile state|find /I " ON">Nul&&(set initialFirewallState=on)||set initialFirewallState=off

:magicloop

cls
echo PERFORMING MAGIC ...
echo %txtUnsafeToClose%

if %initialFirewallState%==off (
    echo - enabling firewall
    netsh advfirewall set currentprofile state on > nul
    timeout /t %breakTime% /nobreak > nul
)

echo - enabling rule %firewallRuleName%
netsh advfirewall firewall set rule name=%firewallRuleName% new enable=yes > nul
timeout /t %networkTimeout% /nobreak > nul

echo - disabling rule %firewallRuleName%
netsh advfirewall firewall set rule name=%firewallRuleName% new enable=no > nul
timeout /t %breakTime% /nobreak > nul

if %initialFirewallState%==off (
    echo - disabling firewall
    netsh advfirewall set currentprofile state off > nul
    timeout /t %breakTime% /nobreak > nul
)

cls
echo IDLING ...
echo %txtSafeToClose%
timeout /t %repeatInterval% /nobreak > nul

goto magicloop
