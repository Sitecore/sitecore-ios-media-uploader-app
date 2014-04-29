#!/bin/bash


LAUNCH_DIR=$PWD
SCRIPTS_ROOT_DIR=$PWD

cd ..
PROJECT_ROOT=$PWD

cd "$PROJECT_ROOT/test"
    TMP_REPORT_DIR=$PWD/test-reports
    WORKSPACE_DIR=$PWD
cd "$LAUNCH_DIR"


CUSTOM_DERIVED_DATA_DIR=~/tmp/Uploader.build



REPORT_DIR=$PROJECT_ROOT/deployment/test-results
COVERAGE_REPORT_DIR=$PROJECT_ROOT/deployment/coverage-results



KILL_SIMULATOR=$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh
TEST_CONVERTER=ocunit2junit.rb
GCOVR=$SCRIPTS_ROOT_DIR/coverage/gcovr



IOS_VERSION=7.1
DEVICE=iPad
CONFIGURATION=Coverage
TEST_WORKSPACE=UploaderTests.xcworkspace




echo "----ruby info----"
which ruby
which rvm
echo "-----------------"


echo "----xcode info----"
xcode-select --print-path
xcodebuild -version

which gcovr
which ocunit2junit.rb

echo KILL_SIMULATOR $KILL_SIMULATOR
echo TEST_CONVERTER $TEST_CONVERTER
echo GCOVR $GCOVR
echo "-----------------"


echo "----Src Dir----"
echo LAUNCH_DIR $LAUNCH_DIR
echo SCRIPTS_ROOT_DIR $SCRIPTS_ROOT_DIR
echo PROJECT_ROOT $PROJECT_ROOT

echo TMP_REPORT_DIR $TMP_REPORT_DIR
echo WORKSPACE_DIR $WORKSPACE_DIR
echo "-----------------"

echo "----Target Dir----"
echo CUSTOM_DERIVED_DATA_DIR $CUSTOM_DERIVED_DATA_DIR
echo REPORT_DIR $REPORT_DIR
echo COVERAGE_REPORT_DIR $COVERAGE_REPORT_DIR
echo "-----------------"


echo "----Options----"
echo IOS_VERSION $IOS_VERSIONIOS_VERSIONIOS_VERSION
echo DEVICE $DEVICE
echo CONFIGURATION $CONFIGURATION
echo TEST_WORKSPACE $TEST_WORKSPACE
echo "-----------------"



rm -rf "$CUSTOM_DERIVED_DATA_DIR"
mkdir -p "$CUSTOM_DERIVED_DATA_DIR"


rm -rf "$REPORT_DIR"
mkdir -p "$REPORT_DIR"

rm -rf "$COVERAGE_REPORT_DIR"
mkdir -p "$COVERAGE_REPORT_DIR"




################  Testing
echo "---Build and Run tests---"

cd "$WORKSPACE_DIR"
xcodebuild -list


echo "========[BEGIN] iAsyncUrlSession-XCTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SCInstanceStorage

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SCInstanceStorage-XCTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER

    cd "$TMP_REPORT_DIR"
    cp *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] iAsyncUrlSession-SenTest========"


echo "-----------------"




################  COVERAGE
echo "---Collecting coverage reports---"
cd "$INTERMEDIATES_DIR"

echo "$GCOVR $CUSTOM_DERIVED_DATA_DIR --root=$PROJECT_ROOT --xml > $COVERAGE_REPORT_DIR/Coverage.xml"

"$GCOVR" "$CUSTOM_DERIVED_DATA_DIR" --root="$PROJECT_ROOT" --xml | tee "$COVERAGE_REPORT_DIR/Coverage.xml"
"$GCOVR" "$CUSTOM_DERIVED_DATA_DIR" --root="$PROJECT_ROOT"       | tee "$COVERAGE_REPORT_DIR/Coverage.txt"

cd "$LAUNCH_DIR"


echo "---Done---"
exit 0
##################################

