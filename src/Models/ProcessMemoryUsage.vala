public class Satellite.ProcessMemoryUsage {
    public uint64 resident { get; private set; }
    public uint64 shared { get; private set; }

    public ProcessMemoryUsage (int pid, uint64 resident, uint64 shared) {
        this.resident = resident;
        this.shared = shared;
    }

    public ProcessMemoryUsage.from_gtop_proc_mem (int pid, GTop.ProcMem proc_mem) {
        this (pid, proc_mem.resident, proc_mem.share);
    }
}
