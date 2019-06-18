public class Satellite.ProcessCPUUsage {
    public int pid { get; private set; }
    public double cpu_usage { get; private set; }

    private GTop.ProcTime proc_time;

    public static double overall_cpu_usage;

    public ProcessCPUUsage (int pid, double cpu_usage, GTop.ProcTime proc_time) {
        this.pid = pid;
        this.cpu_usage = cpu_usage;
        this.proc_time = proc_time;
    }
}
