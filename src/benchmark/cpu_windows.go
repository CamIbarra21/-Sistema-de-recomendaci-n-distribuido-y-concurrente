//go:build windows

package main

import (
	"syscall"
	"time"
)

// cpuTime devuelve el tiempo de CPU (usuario + kernel) acumulado por el proceso.
func cpuTime() time.Duration {
	h, err := syscall.GetCurrentProcess()
	if err != nil {
		return 0
	}
	var creation, exit, kernel, user syscall.Filetime
	if err := syscall.GetProcessTimes(h, &creation, &exit, &kernel, &user); err != nil {
		return 0
	}
	ticks := func(f syscall.Filetime) uint64 { return uint64(f.HighDateTime)<<32 | uint64(f.LowDateTime) }
	return time.Duration((ticks(kernel) + ticks(user)) * 100) // unidades de 100 ns
}
