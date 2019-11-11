@echo OFF
setlocal

call env_vars.cmd

set /p cname=Enter client name: || set cname=client

echo [trust_cert] > %cname%.cnf
echo keyUsage=digitalSignature,keyEncipherment >> %cname%.cnf
echo extendedKeyUsage=clientAuth >> %cname%.cnf

openssl genrsa -out %CERTS_PATH%\%cname%.key %key_bits%
openssl req -sha256 -new -utf8 -key %CERTS_PATH%\%cname%.key -out %cname%.csr -subj /emailAddress="info\@ospanel\.io"/C=RU/stateOrProvinceName="Russian Federation"/L=Moscow/O="Open Server Panel"/OU=Software/CN=%cname%
openssl x509 -sha256 -req -days %days% -in %cname%.csr -extfile %cname%.cnf -extensions trust_cert -CA ca/trusted.crt -CAkey ca/trusted.key -out %CERTS_PATH%\%cname%.crt

openssl x509 -in %CERTS_PATH%\%cname%.crt -noout -purpose

openssl pkcs12 -export -out %CERTS_PATH%\%cname%.pfx -inkey %CERTS_PATH%\%cname%.key -in %CERTS_PATH%\%cname%.crt -certfile ca/trusted.crt -passout pass:%pass%

del %cname%.csr
del %cname%.cnf

pause