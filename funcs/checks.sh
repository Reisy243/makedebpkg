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
		if [ "$i" == "" ] && [ "${#depends[@]}" -ne 0 ]; then
			echo -e "\e[0;31m==> ERROR: \e[1;37mdepends no puede estar vacío."
			error=$[error+1]
		fi
	done
}

function priorityCheck {
	valid=false
	priorities=("required" "important" "standard" "optional" "extra")
	for i in "${priorities[@]}"; do
		if [ "$pkgpriority" == "$i" ]; then
			valid=true
		fi
	done

	if [ "$valid" == false ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37m$pkgpriority no es una prioridad valida."
		error=$[error+1]
	fi
}

actarch=$(arch)

case "$actarch" in
	"x86_64")
		actarch="amd64"
	;;
	"i686")
		actarch="i386"
	;;
esac

archCheck() {
	valid=false

	if ! [ ${#arch[@]} -eq 0 ]; then
		for ((i=0; i<${#arch[@]}; i++)); do	
			if [ "${arch[$i]}" == "$actarch" ] || [ "${arch[$i]}" == "all" ]; then
				if [ "${arch[$i]}" == "all" ]; then
					if [ ${#arch[@]} -eq 1 ]; then
						archNum=$i
					else
						echo -e "\e[0;31m==> ERROR: \e[1;37mNo se puede usar la arquitectura «all» con otras arquitecturas"
						error=$[error+1]
						valid=true
						break
					fi
				fi
				valid=true
				archNum=$i
			fi
		done
	fi

	if [ $valid == false ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37m$pkgname no está disponible para la arquitectura «$actarch»."
		error=$[error+1]
	fi
}

compCheck() {
	if [ "$error" -lt 1 ]; then
		if [ -f "$pkgname-$pkgver-$pkgrel-${arch[$archNum]}.deb" ]; then
			echo -e "\e[0;31m==> ERROR: \e[1;37mYa se ha compilado un paquete. (use -f para sobrescribirlo)"
			exit
		fi
	fi
}

debCheck() {
	if ! [ -f "DEBBUILD" ]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mPKGBUILD no existe."
		exit 1
	fi
}

capsCheck(){
	if [[ "$pkgname" =~ [A-Z] ]]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgname no puede contener mayusculas."
		error=$[error+1]
	fi
}

lettersCheck(){
	if [[ "$pkgname" =~ [Ññ] ]]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgname no puede contener Ñ o ñ."
		error=$[error+1]
	fi
}

validVerCheck(){
	shopt -s nocasematch
	if [[ "${pkgver:0:1}" =~ [A-Z] ]]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37mpkgver no puede comenzar con letras."
		error=$[error+1]
	fi
	shopt -u nocasematch
}

arrayChecker(){
	local var="$1"
	if [[ "$(declare -p "$var" 2>/dev/null)" =~ "declare -a" ]]; then
		echo -e "\e[0;31m==> ERROR: \e[1;37m$var no puede ser un arreglo."
		error=$[error+1]
	fi
}

arrayCheck(){
	arrayChecker maintainer
	arrayChecker pkgdesc
	arrayChecker pkgrel
	arrayChecker pkgver
	arrayChecker pkgpriority
	arrayChecker section
}