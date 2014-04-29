#!/bin/bash


LAUNCH_DIR=$PWD
SCRIPTS_ROOT_DIR=$PWD

cd ..
PROJECT_ROOT=$PWD

CUSTOM_DERIVED_DATA_DIR=~/tmp/Uploader.build


REPORT_DIR=$PROJECT_ROOT/deployment/test-results
COVERAGE_REPORT_DIR=$PROJECT_ROOT/deployment/coverage-results


IOS_VERSION=7.1
CONFIGURATION=Coverage


echo "----ruby info----"
which ruby
which rvm
echo "-----------------"



rm -rf "$CUSTOM_DERIVED_DATA_DIR"
mkdir -p "$CUSTOM_DERIVED_DATA_DIR"



