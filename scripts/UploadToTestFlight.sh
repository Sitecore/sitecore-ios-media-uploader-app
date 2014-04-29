LAUNCH_DIR=$PWD
BUILT_PRODUCTS_DIR=$1


cd "$BUILT_PRODUCTS_DIR"
pwd

IPA_FILE=`ls *.ipa`
DSYM_FILE=`ls *.dSYM.zip`
BUILD_DIR="./build"

echo "BUILT_PRODUCTS_DIR - $BUILT_PRODUCTS_DIR"
echo "IPA_FILE - $IPA_FILE"
echo "DSYM_FILE - $DSYM_FILE"
echo "DSYM_DIR - $DSYM_DIR"

if [ -f $DSYM_FILE ]; then
	
	mv $BUILD_DIR/*.app.dSYM .
	DSYM_DIR=`ls -d *.app.dSYM`
	zip  "$DSYM_DIR.zip" -r "$DSYM_DIR"
	
	DSYM_FILE=`ls *.dSYM.zip`
	echo "DSYM_FILE - $DSYM_FILE"
	
fi

curl http://testflightapp.com/api/builds.json \
-F file=@$IPA_FILE \
-F api_token='a3620a9760dc97411328bc73864c9a82_Mzk2NDIxMjAxMi0wNC0xMyAwNDowNzozMS42MDQ2NTQ' \
-F team_token='9a4cf26c2ba6dab0ae956567f92fc0c0_ODA1NzEyMDEyLTA0LTEzIDA0OjEzOjM5LjA5OTQ0Nw' \
-F notes='Built by Hudson' \
-F notify=True \
-F distribution_lists='Mobile iOS Team' \
-F dsym=@$DSYM_FILE

cd "$LAUNCH_DIR"
