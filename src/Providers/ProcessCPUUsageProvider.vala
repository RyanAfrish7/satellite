public class Satellite.ProcessCPUUsageProvider {
    GTop.Cpu? last_cpu;
    Gee.Map<int, GTop.ProcTime?> pid_cpu_usage_map;

    public ProcessCPUUsageProvider () {
        pid_cpu_usage_map = new Gee.HashMap<int, GTop.ProcTime?> ();
    }

    private double get_cpu_usage_time_from_proc_time (GTop.ProcTime proc_time) {
        return ((double)proc_time.utime + (double)proc_time.stime) / proc_time.frequency;
    }
    
    private ProcessCPUUsage fetch_cpu_usage (int pid, double real_time_interval) {
        GTop.ProcTime proc_time;
        GTop.get_proc_time (out proc_time, pid);
        
        GTop.ProcTime? last_proc_time = pid_cpu_usage_map.get (pid);

        if (last_proc_time == null) {
            last_proc_time = proc_time;
        }

        double cpu_time_spent = get_cpu_usage_time_from_proc_time (proc_time) - get_cpu_usage_time_from_proc_time (last_proc_time);
        double cpu_usage = real_time_interval != 0
            ? cpu_time_spent / real_time_interval * 100.0
            : 0;

        pid_cpu_usage_map.set (pid, proc_time);

        return new ProcessCPUUsage (pid, cpu_usage, proc_time);
    }

    private double get_cpu_usage_time_from_cpu (GTop.Cpu cpu) {
        return ((double)(cpu.user + cpu.sys + cpu.nice)) / cpu.frequency;
    }
    
    public Gee.Map<int, ProcessCPUUsage>? fetch_cpu_usages (Gee.Set<int>? pids) {
        GTop.Cpu cpu;
        GTop.get_cpu (out cpu);

        if (last_cpu == null) {
            last_cpu = cpu;
        }

        double cpu_time_spent = get_cpu_usage_time_from_cpu (cpu) - get_cpu_usage_time_from_cpu (last_cpu);
        double real_time_interval = ((double)cpu.total / cpu.frequency) - ((double)last_cpu.total / last_cpu.frequency);

        ProcessCPUUsage.overall_cpu_usage = real_time_interval != 0
            ? cpu_time_spent / real_time_interval * 100.0
            : 0;

        last_cpu = cpu;

        Gee.Map<int, ProcessCPUUsage> pid_cpu_usage_map = new Gee.HashMap<int, ProcessCPUUsage> ();
        
        foreach (int pid in pids) {
            ProcessCPUUsage cu = fetch_cpu_usage (pid, real_time_interval);
            pid_cpu_usage_map.set (pid, cu);
        }

        return pid_cpu_usage_map.read_only_view;
    }
}
