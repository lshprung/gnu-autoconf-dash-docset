SRC_ICON_FILE=$(SOURCE_DIR)/icon.png

VERSION=2.72
MANUAL_URL  = https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-${VERSION}/autoconf.html_node.tar.gz
MANUAL_FILE = tmp/autoconf.html_node.tar.gz

$(MANUAL_FILE): tmp
	curl -o $@ $(MANUAL_URL)

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	tar -x -z -f $(MANUAL_FILE) -C $@

$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.sh $(SOURCE_DIR)/src/index-terms.sh $(DOCUMENTS_DIR)
	rm -f $@
	$(SOURCE_DIR)/src/index-pages.sh $@ $(DOCUMENTS_DIR)/*.html
	$(SOURCE_DIR)/src/index-terms.sh "Entry" $@ $(DOCUMENTS_DIR)/Concept-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/M4-Macro-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/Autoconf-Macro-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Macro" $@ $(DOCUMENTS_DIR)/Autotest-Macro-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Cache-Variable-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Output-Variable-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Function" $@ $(DOCUMENTS_DIR)/Program-_0026-Function-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Entry" $@ $(DOCUMENTS_DIR)/Preprocessor-Symbol-Index.html
	$(SOURCE_DIR)/src/index-terms.sh "Variable" $@ $(DOCUMENTS_DIR)/Environment-Variable-Index.html
