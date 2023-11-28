function -f {
	# DEBBUILD check
	debCheck

	source DEBBUILD

	# Checks
	blanckCheck	# Checking for blank spaces in DEBBUILD.
	archCheck	# Checking for a valid architecture.

	wah
}

function --force {
	-f
}
