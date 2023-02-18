project('mylib', 'c')

mylib = library('mylib', 'mylib.c', install: true)


install_headers('mylib.h')
pkg = import('pkgconfig')
pkg.generate(mylib)
