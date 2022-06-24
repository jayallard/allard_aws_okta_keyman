function login {
    echo "---------------------------------------------------------"
    echo " Login "
    echo "---------------------------------------------------------"
    echo " Running aws_okta_keyman "
    echo " "
    # $1 = org, $2 = user name
    if [[ -z $1 || -z $2 ]];
    then
        echo "Usage: login ORG USERNAME"
    else
        aws_okta_keyman --org $1 --username $2
    fi
}

function test {
    echo "---------------------------------------------------------"
    echo " Test "
    echo "---------------------------------------------------------"
    echo " This executes a simple AWS command, for test purposes."
    echo " "
    aws sts get-caller-identity
}

function creds {
    echo "---------------------------------------------------------"
    echo " Credentials "
    echo "---------------------------------------------------------"
    echo " For more details: cat ~/.aws/credentials "
    echo " "
    cat ~/.aws/credentials | grep aws_access_key_id && cat ~/.aws/credentials | grep aws_secret_access_key
}

function h {
    echo "---------------------------------------------------------"
    echo " Help "
    echo "---------------------------------------------------------"
    echo " Command Aliases: "
    echo "    h - this help screen "
    echo "    login - login to aws "
    echo "          Usage: login ORG USERNAME "
    echo "    test - test aws connectivity "
    echo "    creds - show your temporary access key and secret "
    echo " "
}

# if the cred env variables are set then login.
# otherwise, skip it.
if [[ -n $OKTA_ORG && -n $OKTA_USER ]];
then
    aws_okta_keyman -o $OKTA_ORG -u $OKTA_USER
fi