function -h {
	echo -e "makedebpkg (dpkg) $ver"
	echo -e ""
	echo -e "Genera paquetes compatibles con dpkg, clon de makepkg de Archlinux"
	echo -e ""
	echo -e "Uso: $0 [opciones]"
	echo -e ""
	echo -e "Opciones:"
	echo -e "	-h, --help	Muestra este mensaje de ayuda y sale"
	echo -e "	-V, --version	Muestra información de la versión y sale"
	echo -e "	-f, --force	Sobrescribe el paquete existente"
	echo -e "	-i, --install	Instala el paquete tras una compilación exitosa"
	exit 0
}

function --help {
	-h
}