--- src/wcmValidateDevice.c.orig	2025-07-01 07:00:40.815298000 +0000
+++ src/wcmValidateDevice.c	2025-07-01 07:01:51.730402000 +0000
@@ -23,6 +23,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <stdint.h>
 
 struct checkData {
 	dev_t min_maj;
@@ -128,7 +129,7 @@
 static struct
 {
 	const char* type;
-	__u16 tool[5]; /* tool array is terminated by 0 */
+	uint16_t tool[5]; /* tool array is terminated by 0 */
 } wcmType [] =
 {
 	{ "stylus", { BTN_TOOL_PEN,       0                  } },
