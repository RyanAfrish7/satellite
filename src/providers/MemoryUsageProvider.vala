public class Satellite.MemoryUsageProvider {
    public MemoryUsageProvider() {

    }

    public SystemMemoryUsage fetch_overall () {
        GTop.Memory memory;
        GTop.get_mem (out memory);

        return new SystemMemoryUsage.from_gtop_memory (memory);
    }

    public Gee.Map<int, ProcessMemoryUsage> fetch_by_pids (Gee.Set<int> pids) {
        Gee.Map<int, ProcessMemoryUsage> pid_memory_usage_map = new Gee.HashMap<int, ProcessMemoryUsage> ();

        foreach (int pid in pids) {
            GTop.ProcMem proc_mem;
            GTop.get_proc_mem (out proc_mem, pid);

            pid_memory_usage_map.set (pid, new ProcessMemoryUsage.from_gtop_proc_mem (pid, proc_mem));
        }

        return pid_memory_usage_map;
    }
}
