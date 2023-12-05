function wah {
	BUILDDIR="$PWD"

	arrayCheck		# Checking for arrays and strings
	capsCheck		# Checking for capital letters pkgname.
	lettersCheck	# Checking for ñ in pkgname.
	validVerCheck	# Checking for number in pkgver
	priorityCheck	# Checking for valids priorities.
	blanckCheck		# Checking for blank spaces in DEBBUILD.
	archCheck		# Checking for a valid architecture.

	# Error management
	if ! [ "$error" -eq 0 ]; then
		exit 1
	fi

	pkgdir="$BUILDDIR/pkg/$pkgname"
	srcdir="$BUILDDIR/src/"

	echo -e "\e[1;32m==> \e[1;37mCreando el paquete: $pkgname $pkgver-$pkgrel ($(date +"%a %d %b %Y %T %Z" -u))"
	if ! [ -d "src" ]; then
		mkdir "$srcdir"
	fi

	if [ -d "pkg" ]; then
		echo -e "\e[1;32m==> \e[1;37mEliminando el directorio \$pkgdir/..."
		rm -rf $BUILDDIR/pkg
	fi

	mkdir -p "$pkgdir/DEBIAN"

	cd $srcdir

	if type package >/dev/null 2>&1; then
		echo -e "\e[1;32m==> \e[1;37mIniciando package()..."
		package
	fi

	echo -e "\e[1;32m==> \e[1;37mCreando el paquete «$pkgname»..."
	echo -e "	\e[1;34m-> \e[1;37mGenerando el archivo DEBIAN/control..."
	echo "Package: $pkgname" >> $pkgdir/DEBIAN/control

	if [ "$pkgpriority" != "" ]; then
		echo "Priority: $pkgpriority" >> $pkgdir/DEBIAN/control
	fi

	if [ "$section" != "" ]; then
		echo "Section: $section" >> $pkgdir/DEBIAN/control
	fi

	echo "Version: $pkgver-$pkgrel" >> $pkgdir/DEBIAN/control
	echo "Architecture: ${arch[$archNum]}" >> $pkgdir/DEBIAN/control
	echo "Maintainer: $maintainer" >> $pkgdir/DEBIAN/control
	echo "Installed-Size: $(du -ks $pkgdir --exclude $pkgdir/DEBIAN | cut -f 1)" >> $pkgdir/DEBIAN/control

	if [ "${#depends[@]}" -ne 0 ]; then
		actdepend="Depends: ${depends[0]}"

		if [ "${#depends[@]}" -gt 1 ]; then
			for ((i = 1; i < "${#depends[@]}"; i++)); do
				actdepend+=", ${depends[$i]}"
			done
		fi
		echo $actdepend >> $pkgdir/DEBIAN/control
	fi

    echo "Description: $pkgdesc" >> $pkgdir/DEBIAN/control

	echo -e "	\e[1;34m-> \e[1;37mGenerando el paquete..."
	dpkg-deb --build --root-owner-group $pkgdir "$BUILDDIR/$pkgname-$pkgver-$pkgrel-${arch[$archNum]}.deb" > /dev/null

	echo -e "\e[1;32m==> \e[1;37mCompilación terminada: $pkgname $pkgver-$pkgrel ($(date +"%a %d %b %Y %T %Z" -u))"
}