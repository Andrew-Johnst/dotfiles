#!/usr/bin/env bash
#/home/drew/.config/zsh/Scripts/Network-Namespace-Execute.sh
#
# Shell helper script file that is located in a directory called by the shell/user profile
# configuration file.

# Define variables for locations of necessary files and directories.
OPENVPN_CONF="/etc/openvpn/client/"

# Define ASCII Escape Code Color Variables.
CRED='\033[1;38;5;9m'
CBLUE='\033[1;38;5;12m'
CGREEN='\033[1;38;5;10m'
CR='\033[0m'

# Check for mandatory dependencies.
CHECKDEPS(){
	# List variable containing all the necessary dependency programs for the network-namespace
	# script to work.
	DEPS=(	"curl"			\
		  	"dnsutils"		\
		  	"dnsmasq"		\
		  	"iproute2"		\
		  	"openvpn"		\
		  	"python"		\
		  	"sudo"			\
		 )
	# Loop through the dependencies list and runn the bash built-in `command -v` to determine if the
	# program is installed; if `command -v` doesn't return anything, then check if any existence
	# pertaining to the package exists with a `whereis [PROGRAM]` and if there is still nothing,
	# append that to a variable to return a list of missing dependencies (if applicable).
	for i in "${DEPS[@]}"
	do
		[[ ! "$(whereis "$i" | grep "$i: [^\ \n].*$")" ]] && \
			MISSINGDEPS=("${MISSINGDEPS[@]}" "$i")
	done
	# If packages are missing, print that there are missing dependencies and which ones.
	[[ "$MISSINGDEPS" ]] && echo -e "${CBLUE}Missing Dependencies Found:${CR}" && \
		for i in "${MISSINGDEPS[@]}"; do echo -e "${CRED} -> ${CGREEN}$i${CR}"; done && \
		echo -e "\n${CRED}Please install these before using this script/function.${CR}" && \
		exit 1

	# Now check for the required "namespaced-openvpn" python script (either in the directory local
	# to this script, or in `/usr/local/sbin` or `/usr/local/bin`); if not found, then download it
	# and install it. 
	[[ ! -f "`pwd`/namespaced-openvpn.py" ]] && \
		[[ ! "$(find / -type f -name "namespaced-openvpn" 2>/dev/null)" ]] && \
		[[ ! -f "/usr/local/bin/namespaced-openvpn" ]] && \
		echo -e "${CRED}The ${CBLUE}\"namespaced-openvpn.py\"${CRED} script was not found in any" \
		"accessible directories.\nCalling the install function.\n" && GET_NS-OVPN_SCRIPT
}

# Function to download and install the namespaced-openvpn python script.
GET_NS-OVPN_SCRIPT(){
	# Start a loop that only accepts a "y" or "n" keypress (or SIGINT, which ends the script).	
	while [[ ! $yn =~ [yn] ]]
	do
		read -n 1 -p "$(echo -e Would you like to install the ${CBLUE}\"namespaced-openvpn\"${CR}? \
			["$CRED"Y"$CR"/"$CRED"n"$CR"]: ) " yn
		echo
	
		## Sanitizing the read command input.
		yn="$(echo $yn | tr '[:upper:]' '[:lower:]')"
	
		# Exit if user selects "[n]o" to committing the changes.
		[[ "$yn" == "n" ]] && echo -e \
			"${CRED}The \"namespaced-openvpn\" script was not already installed and will not " \
			"be installed.\nExiting..." && exit 1
	done

	# Run cURL to download the script and output it to: `/usr/bin/local/` directory.
	sudo curl -sLSo /usr/local/bin/namespaced-openvpn \
		https://raw.githubusercontent.com/slingamn/namespaced-openvpn/master/namespaced-openvpn
	sudo chmod +x /usr/local/bin/namespaced-openvpn

	echo -e "${CGREEN}The namespaced-openvpn python script has been installed to: " \
		"${CBLUE}\"/usr/local/bin/namespaced-openvpn\"${CGREEN} and made executable.${CR}"
}

# Function to verify there are no other instances of this specific namespace running.
#NOT_ALREADY_RUNNING(){
#
#}

# Function to actually start the namespace.
START_NETWORK_NAMESPACE(){
	[[ -f "$OPENVPN_CONF" ]] && echo -e "${CRED}The ${CBLUE}\"\$OPENVPN_CONF\"${CRED} variable" \
		"is either invalid or missing.${CR}" && GET_VALID_OVPN_FILE
		
	sudo /usr/local/bin/namespaced-openvpn --config "$OPENVPN_CONFIG" \
		--writepid /var/run/openvpn-protected-foo-"$USER".pid \
		--log /var/log/openvpn-protected-foo-"$USER".log \
		--daemon

	echo -e "\n\n\n${CGREEN}The network namespace appears to have successfully connected.${CR}\n"
}

# Function to stop the namespace.
STOP_NETWORK_NAMESPACE(){
	# This stops the OpenVPN tunnel by killing the process; this however still leaves the
	# "protected" namespace available.
	sudo pkill -F /var/run/openvpn-protected-foo-"$USER".pid
}

# Function to get a proper OpenVPN config file path.
GET_VALID_OVPN_FILE(){

	# Begin an "endless" while loop that will only terminate when a valid file is supplied.
	while [[ ! $VALID_FILE ]]
	do
		read -p "$(echo -e ${CBLUE}Input a valid file via its full path and filename: ${CRED} )" \
			FILENAME
		echo
		# Verify that the variable is a valid file and is a valid OpenVPN config file.
		[[ ! -f "$OPENVPN_CONFIG" ]] && echo -e "${CRED}The file:" \
			"${CBLUE}\"$OPENVPN_CONFIG\"${CRED} is invalid." && continue
		# Do a simple grep scan to search if there's the term: "openvpn" anywhere in the file.
		[[ ! "$(grep -i 'openvpn' "$OPENVPN_CONFIG")" ]] && echo -e "${CRED}The file: " \
			"${CBLUE}\"$OPENVPN_CONFIG\"${CRED} is not a valid OpenVPN file." && continue
		
		# This only runs if the previous two conditionals are not met (aka, it's a valid file and
		# presumably an OpenVPN configuration file). This sets the variable to use the file supplied
		# to connect to the OpenVPN server.
		echo -e "${CGREEN}Valid OpenVPN configuration file supplied.\n\n" \
			"The configuration file: ${CBLUE}\"$OPENVPN_CONFIG\"${CGREEN} will be used.\n"

		# Set the $OPENVPN_CONFIG variable to the specified filename, then break the while loop.
		OPENVPN_CONFIG="$FILENAME"
		break
	done
}

# This function is used within the shell (for example: "netns-exec [PROGRAM-TO-BE-EXECUTED]
# [ARGUMENTS-IF-APPLICABLE]"); however just to ensure that the network namespace has been properly
# initialized and is running, this function/task has been delegated to its own shell config helper
# script file.
#
# Function that runs the proceeding program inside of a "privelaged" network namespace, which is
# particularly useful for running only certain programs through a certain tunnel (for example,
# running BitTorrent through a network namespace setup to a tun[X] OpenVPN tunnel network
# interface).

