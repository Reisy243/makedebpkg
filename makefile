SCRIPT = makedebpkg
INSTALL_DIR =

install:
	mkdir -p $(INSTALL_DIR)/usr/share/dpkg $(INSTALL_DIR)/bin
	cp $(SCRIPT) $(INSTALL_DIR)/bin/$(SCRIPT)
	chmod +x $(INSTALL_DIR)/bin/$(SCRIPT)
	cp -r funcs $(INSTALL_DIR)/usr/share/makedebpkg
	cp -r docs/DEBBUILD.proto $(INSTALL_DIR)/usr/share/dpkg

# Desinstalar el script
uninstall:
	rm -f $(INSTALL_DIR)/bin/$(SCRIPT)
	rm -rvf $(INSTALL_DIR)/usr/share/makedebpkg $(INSTALL_DIR)/usr/share/dpkg/DEBBUILD.proto
