@echo OFF
setlocal

call env_vars.cmd

rem Проверка наличия файла _domains.txt
if not exist _domains.txt (
	echo File '_domains.txt' not exists. Will create default one.
	echo localhost>_domains.txt
)

for /f "tokens=*" %%G in ('type _domains.txt') do (
	echo [trust_cert] > %%G.cnf
	echo subjectAltName=@alt_names >> %%G.cnf
	echo keyUsage=digitalSignature,keyEncipherment,dataEncipherment >> %%G.cnf
	echo extendedKeyUsage=serverAuth,clientAuth >> %%G.cnf
	rem echo authorityInfoAccess=OCSP;URI:http://localhost >> %%G.cnf
	rem echo crlDistributionPoints=URI:http://localhost/trusted.crl >> %%G.cnf
	echo [alt_names] >> %%G.cnf
	echo DNS.1 = %%G >> %%G.cnf
	echo DNS.2 = %%G.ospanel.io >> %%G.cnf

	openssl genrsa -out %CERTS_PATH%\%%G.key %key_bits%
	openssl req -sha256 -new -key %CERTS_PATH%\%%G.key -out %%G.csr -subj /emailAddress="info\@ospanel\.io"/C=RU/stateOrProvinceName="Russian Federation"/L=Moscow/O="Open Server Panel"/OU=Software/CN=%%G
	rem Для создания самоподписанного сертификата
	rem openssl x509 -sha256 -req -days %days% -in %%G.csr -signkey %CERTS_PATH%\%%G.key -out %CERTS_PATH%\%%G.crt
	rem Для создания сертификата, подписанного доверенным сертификатом
	openssl x509 -sha256 -req -days %days% -in %%G.csr -extfile %%G.cnf -extensions trust_cert -CA ca/trusted.crt -CAkey ca/trusted.key -out %CERTS_PATH%\%%G.crt
)

del *.csr
del *.cnf

pause