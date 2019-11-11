@echo OFF
setlocal

call env_vars.cmd

set /p dname=Enter domain name: || set dname=test

set dname=%dname: =%

rem for /f "delims=[] tokens=2" %%a in ('ping %dname% -n 1 ^| findstr "["') do (set domain_ip=%%a)

echo [trust_cert] > %dname%.cnf
echo subjectAltName=@alt_names >> %dname%.cnf
echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %dname%.cnf
echo extendedKeyUsage=serverAuth,clientAuth >> %dname%.cnf
rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %dname%.cnf
rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %dname%.cnf
echo [alt_names] >> %dname%.cnf
echo DNS.1 = %dname% >> %dname%.cnf
echo DNS.2 = %dname%.ospanel.io >> %dname%.cnf
rem echo IP.1 = %domain_ip% >> %dname%.cnf

openssl ecparam -name %ecc_curve_name% -genkey -out %CERTS_PATH%\%dname%.key

openssl req -new -key %CERTS_PATH%\%dname%.key -out %dname%.csr -subj /emailAddress="info\@ospanel\.io"/C=RU/stateOrProvinceName="Russian Federation"/L=Moscow/O="Open Server Panel"/OU=Software/CN=%dname%
rem Для создания самоподписанного сертификата
rem openssl x509 -sha256 -req -days %days% -in %dname%.csr -signkey %CERTS_PATH%\%dname%.key -out %CERTS_PATH%\%dname%.crt
rem Для создания сертификата, подписанного доверенным сертификатом
openssl x509 -req -days %days% -in %dname%.csr -extfile %dname%.cnf -extensions trust_cert -CA ca/trusted.crt -CAkey ca/trusted.key -out %CERTS_PATH%\%dname%.crt

openssl x509 -in %CERTS_PATH%\%dname%.crt -noout -purpose

del %dname%.csr
del %dname%.cnf

pause