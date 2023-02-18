project('hello', 'c')

mylib = dependency('mylib')
generator = find_program('generator')
generated = custom_target(
  'generated.h',
  output: 'generated.h',
  command : [generator, '@OUTPUT@']
)
executable('hello', ['hello.c', generated], install: true, dependencies: mylib)
