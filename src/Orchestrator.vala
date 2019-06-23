public class Satellite.Orchestrator {
    ProcessInfoProvider process_info_provider;
    ProcessCPUUsageProvider process_cpu_usage_provider;
    MemoryUsageProvider memory_usage_provider;

    CPUView cpu_view;
    CPUViewModel cpu_model;

    MemoryView memory_view;
    MemoryViewModel memory_view_model;

    const int UPDATE_INTERVAL = 1800;

    public Orchestrator (
        Satellite.CPUView cpu_view,
        Satellite.MemoryView memory_view
    ) {
        this.cpu_view = cpu_view;
        this.memory_view = memory_view;
        this.process_info_provider = new ProcessInfoProvider ();
        this.process_cpu_usage_provider = new ProcessCPUUsageProvider ();
        this.memory_usage_provider = new MemoryUsageProvider ();
    }

    private void init_cpu () {
        cpu_model = new CPUViewModel (process_info_provider, process_cpu_usage_provider);
        cpu_view.set_model (cpu_model);
    }
    
    private void init_memory () {
        memory_view_model = new MemoryViewModel (process_info_provider, memory_usage_provider);
        memory_view.set_model (memory_view_model);
    }

    public void init () {
        init_cpu ();
        init_memory ();
    }

    public void start () {
        Timeout.add (UPDATE_INTERVAL, () => {
            cpu_model.refresh ();
            memory_view_model.refresh ();
            return true;
        });
    }
}
