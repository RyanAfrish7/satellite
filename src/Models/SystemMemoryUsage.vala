public class Satellite.SystemMemoryUsage {
    public uint64 total { get; private set; }

    public SystemMemoryUsage (uint64 total) {
        this.total = total;
    }

    public SystemMemoryUsage.from_gtop_memory (GTop.Memory memory) {
        this (memory.total);
    }
}
