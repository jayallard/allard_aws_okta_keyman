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

function copyCredsToHost {
    echo "---------------------------------------------------------"
    echo " Copy Creds to Host "
    echo "---------------------------------------------------------"
    echo "This copies the aws credentials file from the docker container to the directory"
    echo "on the host machine from which the container was run."
    echo "For best results, run the container from the host's aws folder so that it can deposit "
    echo "the credentials file directly where it needs to be."
    echo " "
    cp ~/.aws/credentials /usr/src/app/host/credentials
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
    echo "    copyCredsToHost - copies the aws credentials file to the host machine "
    echo " "
}

echo MODE=$MODE

# if mode is COPY_TO_HOST, then LOGIN, COPY CREDS to host, and exit.
if [[ $MODE == 'COPY_TO_HOST' ]];
then
    # make sure required env variables are set
    if [[ -z $OKTA_ORG || -z $OKTA_USER ]];
    then
        echo "ERROR: OKTA_ORG and OKTA_USER environment variables must be set."
        exit 1
    fi
    
    # login
    aws_okta_keyman -o $OKTA_ORG -u $OKTA_USER
    result=$?

    # if login failed... sad face.
    if [ $result -eq 0 ];
    then
        echo "Login Success."
        cp ~/.aws/credentials /usr/src/app/host/credentials
        echo "Credentials have been copied to the host."
        exit 0;
    else
        echo "Login failed."
        exit $result
    fi
fi;


# if the cred env variables are set then login.
# otherwise, skip it.
if [[ -n $OKTA_ORG && -n $OKTA_USER ]];
then
    aws_okta_keyman -o $OKTA_ORG -u $OKTA_USER
fi