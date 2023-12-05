
ver="1.0-3-alpha"

function -V {
	echo -e "makedebpkg (dpkg) $ver"
	echo -e "Copyright (c) 2023 Isaac David Orozco Delgado (Reisy RedPanda) <opensrcrdp@gmail.com>."
	echo -e ""
	echo -e "Esto es software libre; consulte el código fuente para conocer las condiciones de copia."
	echo -e "Este programa se ofrece SIN NINGUNA GARANTÍA, en la medida en que así lo permita la ley."
	exit 0
}

function --version {
	-V
}