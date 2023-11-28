SCRIPT = makedebpkg
INSTALL_DIR =

install:
	cp $(SCRIPT) $(INSTALL_DIR)/bin/$(SCRIPT)
	chmod +x $(INSTALL_DIR)/bin/$(SCRIPT)
	@echo "$(SCRIPT) installed in $(INSTALL_DIR)/bin/$(SCRIPT)"
	mkdir -p $(INSTALL_DIR)/usr/share
	cp -r funcs $(INSTALL_DIR)/usr/share/makedebpkg

# Desinstalar el script
uninstall:
	rm -f $(INSTALL_DIR)/bin/$(SCRIPT)
	@echo "$(SCRIPT) uninstalled of $(INSTALL_DIR)/bin/$(SCRIPT)"
	rm -rvf $(INSTALL_DIR)/usr/share/makedebpkg
