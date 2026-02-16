#!/usr/bin/env python3

import argparse
from importlib import resources
from pathlib import Path
import plistlib
import shutil
import typing

from dash_docset_builder import (
        DB,
        DocsetSkeleton, 
        get_argparse_template, 
        get_title,
        Gnu_Index_Terms
)

def insert_page(db: DB, html_path: Path) -> None:
    page_name: str = get_title(html_path)
    page_name = page_name.replace(' (Autoconf)', '')

    page_type: str = "Guide"

    db.insert(page_name, page_type, str(html_path.name))

def main() -> None:
    parser: argparse.ArgumentParser = get_argparse_template()
    args: argparse.Namespace = parser.parse_args()
    index: Gnu_Index_Terms
    count: int

    if not args.MANUAL_SOURCE.exists():
        print(f"Error: invalid MANUAL_SOURCE '{str(args.MANUAL_SOURCE)}'")
        exit(1)

    docset_skeleton: DocsetSkeleton = DocsetSkeleton(
            "GNU_Autoconf", args.builddir
    )
    # docset_skeleton will exit if it encounters issues, so no need to handle 
    # it here

    db: DB = DB(docset_skeleton.index_file)
    
    # copy files from manual source to builddir
    _ = shutil.copytree(
            args.MANUAL_SOURCE, 
            docset_skeleton.documents_dir, 
            dirs_exist_ok=True
        )

    # insert pages
    for html_path in docset_skeleton.documents_dir.rglob("*.html"):
        insert_page(db, html_path)

    # insert terms
    for i in (
            ("Entry", "Concept-Index.html"),
            ("Macro", "M4-Macro-Index.html"),
            ("Macro", "Autoconf-Macro-Index.html"),
            ("Variable", "Cache-Variable-Index.html"),
            ("Variable", "Output-Variable-Index.html"),
            ("Function", "Program-_0026-Function-Index.html"),
            ("Entry", "Preprocessor-Symbol-Index.html"),
            ("Variable", "Environment-Variable-Index.html"),
    ):
        index = Gnu_Index_Terms(
                i[0],
                db, 
                Path(docset_skeleton.documents_dir, i[1]),
        )
        count = index.insert_index_terms("printindex-index-entry")
        if count == 0:
            # couldn't find anything; try again using the colon method
            count = index.insert_index_terms()
            if count == 0:
                # still couldn't find anything: warn the user
                print(f"Warning: couldn't find any index terms in '{i[1]}'")

    # generate plist
    plist: dict[str, typing.Any] = {
            "CFBundleIdentifier": "gnuautoconf",
            "CFBundleName": "GNU Autoconf",
            "DocSetPlatformFamily": "autoconf",
            "isDashDocset": True,
    }
    with open(docset_skeleton.info_plist_file, mode='wb') as f:
        plistlib.dump(plist, f)

    # add icon
    with resources.path(
            "gnu_autoconf_dash_docset_generator", 
            Path("resources", "icon.png")
    ) as fspath:
        _ = shutil.copy2(fspath, docset_skeleton.icon_file)

if __name__ == '__main__':
    main()
