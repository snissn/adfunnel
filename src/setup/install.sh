

echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
	  sudo apt-key add -
sudo apt-get update

sudo apt-get install postgresql-10 -y

user=$USER
pwd=$PWD


(

sudo -u postgres $pwd/setup_postgres.sh $user

) > db_password



sudo apt-get install python-pip
sudo pip install -r requirements.txt
