project('com.github.ryanafrish7.satellite', 'vala', 'c', version: '0.1.0')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

subdir('src')

executable(
    meson.project_name(),
    sources,
    dependencies: [
        dependency('gee-0.8'),
        dependency('granite', version: '>=5.2.3'),
        dependency('gtk+-3.0'),
        dependency('libgtop-2.0', version: '>=2.38.0'),
        meson.get_compiler('vala').find_library('posix'),
    ],
    vala_args: [
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install: true
)

subdir('data')
subdir('po')
