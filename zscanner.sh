#!/bin/bash
echo "token started"
abc=$(curl --location --request POST 'https://z-cwp-int.us.auth0.com/oauth/token' --header 'Content-Type: application/json' --data-raw '{ "audience" : "https://api.zscwp.io/iac", "grant_type" : "client_credentials", "client_id" : "KM9TPNvqLuQ06OV1pL7GMsrs3ydglzHu", "client_secret" : "2fevB95DNUBpPw-FKI-e2Fo7EED1aaMMkrMg1FzmhXrqDyOouR3jqCxbx_GpoXxQ"}')
echo $abc
echo "token call done"
regex_hint=access_token
[[ $abc =~ $regex_hint\":\"(.+)\",\"expires_in\" ]]
token=${BASH_REMATCH[1]}
echo $token
$(curl --location --request GET 'https://int.api.zscwp.io/iac/onboarding/v1/cli/download?platform=Linux&arch=x86_64' --header "Authorization: Bearer $token" --header 'Content-Type: application/json' --data-raw '{
    "platform": "Linux",
    "arch": "x86_64"
}' --output zscanner_binary.tar.gz)
tar_contents=`tar -xzvf zscanner_binary.tar.gz`
echo $tar_contents
echo "binary downloaded and retrieved zscanner"
checkos=`uname -a`
echo $checkos
get_scanner=`sudo install zscanner /usr/local/bin && rm zscanner && chmod u+x zscanner`
echo $get_scanner
echo "check zscanner"
zversion=`zscanner version`
echo $zversion
zconfiglist=`./zscanner config list -a`
echo $zconfiglist
zconfigadd=`zscanner config add -k custom_region -v "{\"host\":\"https://int.api.zscwp.io\",\"auth\":{\"host\":\"https://z-cwp-int.us.auth0.com\",\"clientId\":\"KM9TPNvqLuQ06OV1pL7GMsrs3ydglzHu\",\"scope\":\"offline_access profile\",\"audience\":\"https://api.zscwp.io/iac\"}}"`
echo $zconfigadd
zconfiglist1=`zscanner config list -a`
echo $zconfiglist1
zlogout=`zscanner logout`
echo $zlogout
checkLogin=`zscanner login cc --client-id KM9TPNvqLuQ06OV1pL7GMsrs3ydglzHu --client-secret 2fevB95DNUBpPw-FKI-e2Fo7EED1aaMMkrMg1FzmhXrqDyOouR3jqCxbx_GpoXxQ -r CUSTOM`
echo $checkLogin
loginString='Logged in as system'
if [ "$checkLogin" == "$loginString" ]
then
  echo "successfully login to system"
else
  echo "Failed to login to system"
fi
zscan=`zscanner scan -d .`
echo $zscan
if [ $? == 0 ]
then
  echo "Scan passed and no violations"
else
  echo "Scan Violations reported"
  exit 1
fi
