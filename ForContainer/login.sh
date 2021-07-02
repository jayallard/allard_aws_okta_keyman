# $1 = org
# $2 = id
# both are required
if [[ -z $1 || -z $2 ]];
then
    echo "ERROR: USAGE: login org username"
    echo "IE: login MY-OKTA-ORG me@mydomain.com"
    exit -1;
fi
aws_okta_keyman -o $1 -u $2
echo "Org=$1"
echo "User Name=$2"
cp ~/.aws/credentials /usr/src/app/host/credentials
echo "Credentials have been copied to the host."
