#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#Import GPG Key
echo "Importing AlmaLinux 8 new GPG Key"
# Wait for the URL to be reachable
echo "Waiting for RPM-GPG-KEY-AlmaLinux to be reachable"
until rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux
do
    rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux
    sleep 2
done
#Wait for the repo
echo "Waiting for repo to be reacheable"
curl --retry 20 -s -o /dev/null "https://download.docker.com/linux/centos/docker-ce.repo"
echo "Adding repo"
until dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
do
   dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
   sleep 2
done
dnf remove podman buildah
echo "Installing docker support"
until dnf -y install docker-ce docker-ce-cli containerd.io
do
    dnf -y install docker-ce docker-ce-cli containerd.io
    sleep 2
done
systemctl start docker.service
systemctl enable docker.service

# TODO(darwin2): Ask benoitbMTL to remove all content except the app config from the darwin2 config file.
# assignees: robinmordasiewicz
dnf install -y git patch
git clone --branch version-1.1 https://github.com/AJLab-GH/darwin2.git /root/darwin2
cat << 'EOF' > /root/darwin2/go/config/app_config.go.diff
@@ -41,12 +41,11 @@
 	defer configMutex.Unlock()

 	defaultConfig := AppConfig{
-		NAME:           "Default",
-		DVWAURL:        "https://dvwa.corp.fabriclab.ca",
-		BANKURL:        "https://bank.corp.fabriclab.ca/bank.html",
-		JUICESHOPURL:   "https://juiceshop.corp.fabriclab.ca",
-		PETSTOREURL:    "https://petstore3.corp.fabriclab.ca/api/v3/pet",
-		SPEEDTESTURL:   "https://speedtest.corp.fabriclab.ca",
+		NAME:           "FortiGate",
+		DVWAURL:        "${var_fgt-DVWAURL}",
+		BANKURL:        "${var_fgt-BANKURL}",
+		JUICESHOPURL:   "${var_fgt-JUICESHOPURL}",
+		PETSTOREURL:    "${var_fgt-PETSTOREURL}",
 		USERNAMEAPI:    "userapi",
 		PASSWORDAPI:    "fortinet123!",
 		VDOMAPI:        "root",
@@ -54,16 +53,14 @@
 		FWBMGTPORT:     "443",
 		MLPOLICY:       "DVWA_POLICY",
 		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: "fortiweb",
 	}

-	configsMap["Azure Lab"] = AppConfig{
-		NAME:           "Azure Lab",
-		DVWAURL:        "https://dvwa.canadaeast.cloudapp.azure.com",
-		BANKURL:        "https://dvwa.canadaeast.cloudapp.azure.com/bank.html",
-		JUICESHOPURL:   "https://juiceshop.canadaeast.cloudapp.azure.com",
-		PETSTOREURL:    "https://petstore3.canadaeast.cloudapp.azure.com/api/v3/pet",
-		SPEEDTESTURL:   "https://speedtest.canadaeast.cloudapp.azure.com",
+	configsMap["FortiWeb"] = AppConfig{
+		NAME:           "Fortiweb",
+		DVWAURL:        "${var_fwb-DVWAURL}",
+		BANKURL:        "${var_fwb-BANKURL}",
+		JUICESHOPURL:   "${var_fwb-JUICESHOPURL}",
+		PETSTOREURL:    "${var_fwb-PETSTOREURL}",
 		USERNAMEAPI:    "userapi",
 		PASSWORDAPI:    "fortinet123!",
 		VDOMAPI:        "root",
@@ -71,15 +68,14 @@
 		FWBMGTPORT:     "8443",
 		MLPOLICY:       "DVWA_POLICY",
 		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: ""}
+	}

-	configsMap["Fabric Lab (fortiweb)"] = AppConfig{
-		NAME:           "Fabric Lab (fortiweb)",
-		DVWAURL:        "https://dvwa.corp.fabriclab.ca",
-		BANKURL:        "https://bank.corp.fabriclab.ca/bank.html",
-		JUICESHOPURL:   "https://juiceshop.corp.fabriclab.ca",
-		PETSTOREURL:    "https://petstore3.corp.fabriclab.ca/api/v3/pet",
-		SPEEDTESTURL:   "https://speedtest.corp.fabriclab.ca",
+	configsMap["Azure Firewall"] = AppConfig{
+		NAME:           "Azure Firewall",
+		DVWAURL:        "${var_azfw-DVWAURL}",
+		BANKURL:        "${var_azfw-BANKURL}",
+		JUICESHOPURL:   "${var_azfw-JUICESHOPURL}",
+		PETSTOREURL:    "${var_azfw-PETSTOREURL}",
 		USERNAMEAPI:    "userapi",
 		PASSWORDAPI:    "fortinet123!",
 		VDOMAPI:        "root",
@@ -87,15 +83,14 @@
 		FWBMGTPORT:     "443",
 		MLPOLICY:       "DVWA_POLICY",
 		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: "fortiweb"}
+	}

-	configsMap["Fabric Lab (fortiweb2)"] = AppConfig{
-		NAME:           "Fabric Lab (fortiweb2)",
-		DVWAURL:        "https://dvwa.corp.fabriclab.ca",
-		BANKURL:        "https://bank.corp.fabriclab.ca/bank.html",
-		JUICESHOPURL:   "https://juiceshop.corp.fabriclab.ca",
-		PETSTOREURL:    "https://petstore3.corp.fabriclab.ca/api/v3/pet",
-		SPEEDTESTURL:   "https://speedtest.corp.fabriclab.ca",
+	configsMap["Azure App Gateway"] = AppConfig{
+		NAME:           "Azure App Gateway",
+		DVWAURL:        "${var_appgw-DVWAURL}",
+		BANKURL:        "${var_appgw-BANKURL}",
+		JUICESHOPURL:   "${var_appgw-JUICESHOPURL}",
+		PETSTOREURL:    "${var_appgw-PETSTOREURL}",
 		USERNAMEAPI:    "userapi",
 		PASSWORDAPI:    "fortinet123!",
 		VDOMAPI:        "root",
@@ -103,60 +98,12 @@
 		FWBMGTPORT:     "443",
 		MLPOLICY:       "DVWA_POLICY",
 		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: "fortiweb2"}
-
-	configsMap["FortiWeb Cloud"] = AppConfig{
-		NAME:           "FortiWeb Cloud",
-		DVWAURL:        "https://dvwa.96859.fortiwebcloud.net",
-		BANKURL:        "https://bank.96859.fortiwebcloud.net/bank.html",
-		JUICESHOPURL:   "https://juiceshop.96859.fortiwebcloud.net",
-		PETSTOREURL:    "https://petstore3.96859.fortiwebcloud.net/api/v3/pet",
-		SPEEDTESTURL:   "",
-		USERNAMEAPI:    "",
-		PASSWORDAPI:    "",
-		VDOMAPI:        "",
-		FWBMGTIP:       "",
-		FWBMGTPORT:     "",
-		MLPOLICY:       "",
-		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: ""}
-
-	configsMap["FortiPoc"] = AppConfig{
-		NAME:           "FortiPoc",
-		DVWAURL:        "https://192.168.1.10",
-		BANKURL:        "https://192.168.1.10/bank.html",
-		JUICESHOPURL:   "https://192.168.1.20",
-		PETSTOREURL:    "https://192.168.1.30/api/v3/pet",
-		SPEEDTESTURL:   "https://192.168.1.40",
-		USERNAMEAPI:    "userapi",
-		PASSWORDAPI:    "fortinet123!",
-		VDOMAPI:        "root",
-		FWBMGTIP:       "192.168.1.2",
-		FWBMGTPORT:     "443",
-		MLPOLICY:       "DVWA_POLICY",
-		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: ""}
-
-	configsMap["Local Lab"] = AppConfig{
-		NAME:           "Local Lab",
-		DVWAURL:        "https://dvwa.corp.fabriclab.ca",
-		BANKURL:        "https://bank.corp.fabriclab.ca/bank.html",
-		JUICESHOPURL:   "https://juiceshop.corp.fabriclab.ca",
-		PETSTOREURL:    "https://petstore3.corp.fabriclab.ca/api/v3/pet",
-		SPEEDTESTURL:   "https://speedtest.corp.fabriclab.ca",
-		USERNAMEAPI:    "userapi",
-		PASSWORDAPI:    "fortinet123!",
-		VDOMAPI:        "root",
-		FWBMGTIP:       "192.168.4.2",
-		FWBMGTPORT:     "443",
-		MLPOLICY:       "DVWA_POLICY",
-		USERAGENT:      "FortiWeb Demo Tool",
-		FABRICLABSTORY: ""}
+	}

 	// Add your defaultConfig to the configsMap
 	configsMap[defaultConfig.NAME] = defaultConfig

-	currentName = "Default"
+	currentName = "FortiGate"

 	// Ensure that CurrentConfig reflects the configuration pointed to by currentName.
 	var exists bool

EOF
cd /root/darwin2/go/config || exit
patch app_config.go app_config.go.diff

cd /root/darwin2/vue/src/components/05-tool || exit
patch ConfigForm.vue ConfigForm.vue.diff

cd /root/darwin2 || exit
docker build -t "darwin2:latest" .

docker run --restart=always --name darwin2 -d -p 80:8080 darwin2
