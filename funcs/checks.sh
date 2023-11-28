error=0

function blanckCheck {
	if [ "$maintainer" == "" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mmaintainer no puede estar vacío."
		error=$[error+1]
	fi
	if [ "$pkgdesc" == "" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgdesc no puede estar vacío."
		error=$[error+1]
	fi
	if [ "$pkgrel" == "" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgrel no puede estar vacío."
		error=$[error+1]
	fi
	if [ "$pkgver" == "" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgver no puede estar vacío."
		error=$[error+1]
	fi
	if [ "$pkgname" == "" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgname no puede estar vacío."
		error=$[error+1]
	fi
	for i in "${depends[@]}"; do
		if [ "$i" == "" ] && [ "${#depends[@]}" -ne 1 ]; then
			echo -e "\e[0;31m==> ERROR: \e[1;37mdepends no puede estar vacío."
			error=$[error+1]
		fi
	done
}

function archCheck {
	valid=false
	invalidnum=1

	actarch=$(arch)

	case "$actarch" in
		"x86_64")
			actarch="amd64"
		;;
		"i686")
			actarch="i386"
		;;
	esac

	for i in "${arch[@]}"; do
		if [ "$i" != "" ]; then
			if [ "$i" == "all" ]; then
				if [ "${#arch[@]}" -ge 2 ]; then
					echo -e "\e[0;31m==> ERROR: \e[1;37mNo se puede usar la arquitectura «all» con otras arquitecturas"
					error=$[error+1]
					invalidnum=1
				else
					valid=true
				fi
			else
				case "$i" in
					"$actarch")
						for ((i=0; i<${#arch[@]}; i++)); do
							if [ "${arch[i]}" == "$actarch" ]; then
								archNum=$i
							fi
						done
						valid=true
						break
					;;
					*)
						invalidnum=0
						valid=false
					;;
				esac
			fi
		fi
	done

	if [ "$invalidnum" -eq 0 ] && [ "$valid" == false ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37m$pkgname no está disponible para la arquitectura «$actarch»."
		error=$[error+1]
	fi
}

function compCheck {
	if [ "$error" -lt 1 ]; then
		if [ -f "$pkgname-$pkgver-$pkgrel-${arch[$archNum]}.deb" ]; then
			echo -e "\e[0;31m==> ERROR: \e[1;37mYa se ha compilado un paquete. (use -f para sobrescribirlo)"
			exit
		fi
	fi
}

function debCheck {
	if ! [ -f "DEBBUILD" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mPKGBUILD no existe."
		exit 1
	fi
}