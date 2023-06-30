# BlastPlus_build_scripts


Two scripts to automatically build NCBI Blast+ binaries from publicly released sources.

 
build_public_ftp_src.sh   - build from publicly released FTP sources
build_public_ncbi-cxx.sh  - build from experimental public GitHub repository



Tested on Apple M2 hardware, Ventura, comman line build, XCode, cmake installed. ( no homebrew).


usage:
./build_public_ftp_src.sh -h      --- print short help info
./build_public_ftp_src.sh         --- run build


./build_public_ncbi-cxx.sh -h     --- print short help info
./build_public_ncbi-cxx.sh        --- run build


Please be aware GitHub sources are not the same as "ftp released archives".


Also this scripts have been tested on MacOS, they are most likely to run on linux and other unixes 
where NCBI CXX could be build.

Happy computing!



