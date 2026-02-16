Dash docset generator for
[GNU Autoconf](https://www.gnu.org/savannah-checkouts/gnu/autoconf/autoconf.html)

### Instructions

- Download the pre-built documentation 
[](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/index.html)
    - Download the manual titled "HTML compressed ... - with one web page per node."

- `gnu-autoconf-dash-docset-generator MANUAL_SOURCE`
    - `GNU_Autoconf.docset` will be generated in the current working directory
    (or a specified builddir if `-b` was passed)
    - If `pipx` is installed, you can avoid `pip install`ing anything and just
    run `pipx run gnu-autoconf-dash-docset-generator MANUAL_SOURCE`
    - `MANUAL_SOURCE` will be the path to the html sources, after extracting
    from the gzipped tar file they are distributed in
    - For a full set of options: `gnu-libc-dash-docset-generator -h`
