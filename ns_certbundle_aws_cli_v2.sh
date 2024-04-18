#!/bin/bash
echo "Trying to check if certs exist"

while getopts 'p:' OPTION; do
    case "$OPTION" in
        p)
            userinstallpath="$OPTARG"
            echo "Custom path provided is $OPTARG"
            ;;
        ?)
            echo "script usage: $(basename $0) [-p path_to_custom_aws_install_folder]"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

#Sets variables
cacert='/Library/Application Support/Netskope/STAgent/data/nscacert.pem'
tenantcert='/Library/Application Support/Netskope/STAgent/data/nstenantcert.pem'
certbundle='./netskope-cert-bundle.pem'
awscertbundlepath1='/usr/local/aws-cli/botocore/cacert.pem'
awscertbundlepath2='/usr/local/aws-cli/awscli/botocore/cacert.pem'
awscertbundle=''
userawscertbundle="${userinstallpath}/aws-cli/botocore/cacert.pem"
custom=false
if [ -f "$awscertbundlepath1" ]
then
    awscertbundle=$awscertbundlepath1
fi

if [ -f "$awscertbundlepath2" ]
then
    awscertbundle=$awscertbundlepath2
fi

#Verifies that the aws cert-bundle was found
if [ -f "$userawscertbundle" ]
then
    custom=true
fi
if [ "$custom" = false ] && [ ! -f "$awscertbundle" ]
then
    echo "AWS Cert not found. Please check that AWS CLI is installed on the system.
    Also if installed to a custom path, please provide using the '-p' option"
    exit 1
fi

#Appends the certs
if [ "$custom" = false ]
then
    if [ -f "$cacert" ] && [ -f "$tenantcert" ]
    then
        echo "$cacert"
        echo "$tenantcert"
        echo "$awscertbundle"
        
        if [ -f "$certbundle" ]
        then
           echo "Certificate bundle exists.Terminating processing ..."
           exit 0
        else
           cat "$tenantcert" "$cacert" "$awscertbundle" > "$certbundle"
           if [ $? = 0 ]
           then  
               echo "Certificate bundle created"
               exit 0
           else
               echo "Error!!"
               exit 1
           fi
        fi
    else
        echo "Required certs not found. Please check if Netskope Client is installed"
        exit 1
    fi
else
    if [ -f "$cacert" ] && [ -f "$tenantcert" ]
    then
        echo "$cacert"
        echo "$tenantcert"
        echo "$userawscertbundle"
        
        if [ -f "$certbundle" ]
        then
           echo "Certificate bundle exists.Terminating processing ..." 
           exit 0
        else
           cat "$tenantcert" "$cacert" "$userawscertbundle" > "$certbundle"
           if [ "$?" = 0 ]
           then  
               echo "Certificate bundle created"
               exit 0
           else
               echo "Error!!"
               exit 1
           fi
        fi
    else
        echo "Required certs not found. Please check if Netskope Client is installed"
        exit 1
    fi
fi
