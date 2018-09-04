#!/bin/sh 
################################################################## 
#Set application name 
appName=xagent
#minJavaVersionMajor=1 
#minJavaVersionMinor=7 
#minJavaVersionPatch=0 
##################################################################

############## Search Java ################
JAVA=java 
if [ -n "$JAVA_HOME" ]; then 
JAVA="$JAVA_HOME/bin/java" 
fi 

if [ -z "$JAVA_OPTS" ]; then 
JAVA_OPTS="-Xms64m -Xmx768m -XX:-UseSplitVerifier -cp ../lib/apache-xmlrpc-3.1.3/lib/xmlrpc-client-3.1.3.jar;../lib/apache-xmlrpc-3.1.3/lib/xmlrpc-common-3.1.3.jar;/usr/share/xqual/xstudio/lib/* "
#in case you use java 9+, replace this with
#JAVA_OPTS="-Xms64m -Xmx768m -XX:-UseSplitVerifier --add-modules java.se.ee -cp ../lib/apache-xmlrpc-3.1.3/lib/xmlrpc-client-3.1.3.jar;../lib/apache-xmlrpc-3.1.3/lib/xmlrpc-common-3.1.3.jar"
fi 

echo 'Searching for java...'
if ( which $JAVA 2>&1 > /dev/null ); then
echo `which $JAVA` 
else 
echo 'Cannot find Java, please install or correct your JAVA_HOME' 
exit 1 
fi 

echo ''

############## Check Version ################
#create tmp file name 
#tmpJavaVersion=`mktemp`

# query complete version by java 
#$JAVA -version 2>&1 | head -n 1 > $tmpJavaVersion

# clean output 
#javaVersion=`awk 'BEGIN {FS = "\""} {print $2}' $tmpJavaVersion`

# split version parts 
#javaVersionMajor=`awk 'BEGIN {FS = "."} {print $1}' << EOF 
#$javaVersion 
#EOF` 

#javaVersionMinor=`awk 'BEGIN {FS = "."} {print $2}' << EOF 
#$javaVersion 
#EOF` 

#javaVersionPatch=`awk 'BEGIN {FS = "."} {print $3}' << EOF 
#$javaVersion 
#EOF` 

#javaVersionPatch=`awk 'BEGIN {FS = "_"} {print $1}' << EOF 
#$javaVersionPatch 
#EOF` 

# Print found java version 
#echo "Found version: $javaVersionMajor.$javaVersionMinor.$javaVersionPatch" 
#echo "Required version: $minJavaVersionMajor.$minJavaVersionMinor.$minJavaVersionPatch" 

#if [ $javaVersionMajor -gt $minJavaVersionMajor ]; then 
#echo -n '' 
#else 
#if [ $javaVersionMajor -eq $minJavaVersionMajor ] && [ $javaVersionMinor -gt $minJavaVersionMinor ]; then 
#echo -n '' 
#else 
#if [ $javaVersionMajor -eq $minJavaVersionMajor ] && [ $javaVersionMinor -eq $minJavaVersionMinor ] && [ $javaVersionPatch -ge $minJavaVersionPatch ]; then 
#echo -n '' 
#else 
#echo 'Please update your Java to the required Java version!' 
#exit 1; 
#fi 
#fi 
#fi 

#echo ''

############## Start Application ################
#echo 'Found Java version is sufficient.'
echo 'Starting application...' 
cd /usr/share/xqual/xstudio
$JAVA $JAVA_OPTS -jar $appName.jar "$@"
# use $* instead of "$@" if you use a shell nor supporting this

# if you want to force XStudio using the cross platform look and feel (or another one you prefer) add the following option to java
# --overrideLf com.sun.javax.swing.plaf.metal.CrossPlatformLookAndFeel
