@echo off
setlocal enabledelayedexpansion

call env_vars.cmd

echo Hash calculating...
for /f "tokens=*" %%G in ('dir /b /s %CERTS_PATH%\*.key') do (
	rem (echo openssl rsa -in %%G -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64) >> hashes.tmp
	rem (openssl x509 -in %%G -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64) >> hashes.tmp
	(openssl rsa -in %%G -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64) >> hashes.tmp
)

for /f "tokens=*" %%a in ('type hashes.tmp') do (
	set _pins_a=!_pins_a!pin-sha256=\"%%a\";
	set _pins_n=!_pins_n!pin-sha256="%%a";
)
echo HPKP generating...
echo Header always set Public-Key-Pins "%_pins_a%max-age=2592000">%CERTS_PATH%\hpkp_apache.conf
echo add_header Public-Key-Pins '%_pins_n%max-age=31536000';>%CERTS_PATH%\hpkp_nginx.conf

del hashes.tmp

pause