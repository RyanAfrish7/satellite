project('com.github.ryanafrish7.satellite', 'vala', 'c')

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Orchestrator.vala',
    'src/shared/TreeViewUtils.vala',
    'src/models/ProcessInfo.vala',
    'src/models/ProcessCPUUsage.vala',
    'src/models/ProcessMemoryUsage.vala',
    'src/models/SystemMemoryUsage.vala',
    'src/views/CPUView.vala',
    'src/views/MemoryView.vala',
    'src/providers/ProcessInfoProvider.vala',
    'src/providers/ProcessCPUUsageProvider.vala',
    'src/providers/MemoryUsageProvider.vala',
    'src/stores/AbstractModel.vala',
    'src/stores/CPUViewModel.vala',
    'src/stores/MemoryViewModel.vala',
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

install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)
