# For Mac OS:
### Note: The scripts assumes that the installation path is `/usr/local/aws-cli`. This procedure is meant to setup Netskope Environment Variables for AWS CLI.

1. Download the `ns_certbundle_aws_cli_v2.sh` found in this repo
2. Create the nskp_config folder in the .aws directory to hold the certificate bundle.\
`mkdir ~/.aws/nskp_config`
3. Move the downloaded script ‘ns_certbundle_aws_cli_v2.sh’ to the config folder.\
`mv ~/Downloads/ns_certbundle_aws_cli_v2.sh ~/.aws/nskp_config`
4. Make script executable.\
`chmod u+x ~/.aws/nskp_config/ns_certbundle_aws_cli_v2.sh`
5. Run the script.\
`./ns_certbundle_aws_cli_v2.sh`
6. Make sure to add the the env var to what ever shell file you call home.\
`export AWS_CLI_BUNDLE=$HOME/.aws/nskp_config/netskope-cert-bundle.pem`

