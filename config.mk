SRC_ICON_FILE=$(SOURCE_DIR)/icon.png

ifdef VERSION
	MANUAL_URL = https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-${VERSION}/autoconf.html_node.tar.gz
else
	MANUAL_URL = https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf.html_node.tar.gz
endif
MANUAL_FILE = tmp/autoconf.html_node.tar.gz

$(MANUAL_FILE): tmp
	curl -L -o $@ $(MANUAL_URL)

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	tar -x -z -f $(MANUAL_FILE) -C $@

$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.sh $(SCRIPTS_DIR)/gnu/index-terms.sh $(DOCUMENTS_DIR)
	rm -f $@
	$(SOURCE_DIR)/src/index-pages.sh $@ $(DOCUMENTS_DIR)/*.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Entry" $@ $(DOCUMENTS_DIR)/Concept-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/M4-Macro-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/Autoconf-Macro-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/Autotest-Macro-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Cache-Variable-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Output-Variable-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Function" $@ $(DOCUMENTS_DIR)/Program-_0026-Function-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Entry" $@ $(DOCUMENTS_DIR)/Preprocessor-Symbol-Index.html
	$(SCRIPTS_DIR)/gnu/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Environment-Variable-Index.html
