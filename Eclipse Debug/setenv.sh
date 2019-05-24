export CATALINA_OPTS=" \

-XX:+PrintGCTimeStamps \
-XX:+PrintGCDetails \
-XX:+PrintGCApplicationStoppedTime \
-XX:+PrintGCApplicationConcurrentTime \
-XX:+PrintHeapAtGC \
-Xloggc:../logs/gc.log"

############################################
#
# JAVA_OPTS
#
#############################################
 
 
# -server
export JAVA_OPTS="-server"
export JAVA_OPTS="$JAVA_OPTS -Xms1024M -Xmx1024M"
export JAVA_OPTS="$JAVA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=10116,suspend=n"
