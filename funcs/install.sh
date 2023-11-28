function -i {
    # DEBBUILD check
	debCheck
	source DEBBUILD

	# Checks
	blanckCheck	# Checking for blank spaces in DEBBUILD.
	archCheck	# Checking for a valid architecture.

	source DEBBUILD
	if [ -f "$pkgname-$pkgver-$pkgrel-${arch[$archNum]}.deb" ]; then
		echo -e "\e[1;33m==> ADVERTENCIA: \e[1;37mYa se ha compilado un paquete, instalando dicho paquete..."
	else
		wah
	fi
	echo -e "\e[0;32m==> \e[1;37mInstalando el paquete $pkgname con apt install..."
	sudo apt install ./"$pkgname-$pkgver-$pkgrel-${arch[$archNum]}.deb"
}

function --install {
	-i
}
