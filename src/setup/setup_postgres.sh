user=$1
password=$( head -c 20 /dev/urandom | base64)
echo "drop schema adfunnel; DROP USER $user; CREATE SCHEMA adfunnel; CREATE USER $user PASSWORD '$password'; GRANT ALL ON SCHEMA adfunnel TO $user; GRANT ALL ON ALL TABLES IN SCHEMA adfunnel TO $user; " | psql > /dev/null
echo $password 
