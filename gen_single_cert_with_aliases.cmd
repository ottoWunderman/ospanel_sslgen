@echo OFF
setlocal EnableDelayedExpansion

call env_vars.cmd

set /p dname=Enter domain name: || set dname=test

echo [trust_cert] > %dname%.cnf
echo subjectAltName=@alt_names >> %dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %dname%.cnf
rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %dname%.cnf
rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %dname%.cnf
echo [alt_names] >> %dname%.cnf
echo DNS.1=%dname% >> %dname%.cnf
echo DNS.2 = %dname%.ospanel.io >> %dname%.cnf

set /a "alias_nr = 2"
:another_alias
set /p _q="Add an alias? [press Y to continue, N to skip]: " || set _q=n

if /I "%_q%" == "y" (
	set /p aname="Enter alias name [you can use wildcard]: " || set aname=www
	echo DNS.%alias_nr%=!aname! >> %dname%.cnf
) else goto continue_gen

set /a "alias_nr+=1"
goto another_alias

:continue_gen
openssl genrsa -out %CERTS_PATH%\%dname%.key %key_bits%
openssl req -sha256 -new -key %CERTS_PATH%\%dname%.key -out %dname%.csr -subj /emailAddress="info\@ospanel\.io"/C=RU/stateOrProvinceName="Russian Federation"/L=Moscow/O="Open Server Panel"/OU=Software/CN=%dname%

openssl x509 -sha256 -req -days %days% -in %dname%.csr -extfile %dname%.cnf -extensions trust_cert -CA ca/trusted.crt -CAkey ca/trusted.key -out %CERTS_PATH%\%dname%.crt

openssl x509 -in %CERTS_PATH%\%dname%.crt -noout -purpose

del %dname%.csr
del %dname%.cnf

pause